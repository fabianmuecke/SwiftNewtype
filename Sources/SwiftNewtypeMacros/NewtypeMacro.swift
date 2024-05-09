//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct NewtypeMacro: MemberMacro, ExtensionMacro {
    struct Error: Swift.Error {
        let message: String
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        if let enumDecl = declaration.as(EnumDeclSyntax.self) {
            return try basicMembers(for: enumDecl)
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            guard let valueType = node.conformToTypes?.first else {
                throw Error(message: "Value type argument missing.")
            }
            return try basicMembers(for: structDecl, valueType: valueType)
        }
        throw Error(message: "@Newtype can only be applied to enums or structs")
    }

    public static func expansion(
        of attribute: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        if let enumDecl = declaration.as(EnumDeclSyntax.self) {
            return try processEnum(enumDecl: enumDecl, process: { valueType, modifiers, caseName in
                var result = try basicEnumExtensions(enumType: type, valueType: valueType, modifiers: modifiers, caseName: caseName)
                try appendConformances(for: type, types: attribute.conformToTypes, valueType: valueType, modifiers: modifiers, to: &result)
                return result
            })
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            return try processStruct(structDecl: structDecl) { modifiers in
                guard let types = attribute.conformToTypes,
                      let valueType = types.first else {
                    throw Error(message: "Value type argument missing.")
                }

                var result = try basicStructExtensions(structType: type, valueType: valueType, modifiers: modifiers)
                try appendConformances(for: type, types: types.dropFirst(), valueType: valueType, modifiers: modifiers, to: &result)
                return result
            }
        }
        throw Error(message: "@Newtype can only be applied to enums or structs")
    }

    private static func appendConformances<Types: Collection>(
        for type: some TypeSyntaxProtocol,
        types: Types?,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax,
        to result: inout [ExtensionDeclSyntax]
    ) throws where Types.Element == DeclReferenceExprSyntax {
        try result.append(CustomStringConvertibleConformance().conform(type: type, valueType: valueType, modifiers: modifiers))

        if let conformTypes = types, !conformTypes.isEmpty {
            if conformTypes.contains(where: { $0.trimmedDescription == "NoConformances" }) {
                return
            }
            try result.append(NewtypeConformance().conform(type: type, valueType: valueType, modifiers: modifiers))
            for conformType in conformTypes {
                let name = conformType.trimmedDescription
                if let conformances = defaultConformances[name] {
                    for conformance in conformances {
                        try result.append(conformance.conform(type: type, valueType: valueType, modifiers: modifiers))
                    }
                } else if let conformance = allConformances[name] {
                    try result.append(conformance.conform(type: type, valueType: valueType, modifiers: modifiers))
                } else {
                    throw Error(message: "No default conformance to \(conformType.trimmedDescription) available!")
                }
            }
        } else if let conformances = defaultConformances[valueType.trimmedDescription] {
            try result.append(NewtypeConformance().conform(type: type, valueType: valueType, modifiers: modifiers))
            for conformance in conformances {
                try result.append(conformance.conform(type: type, valueType: valueType, modifiers: modifiers))
            }
        }
    }

    private static func basicMembers(for enumDecl: EnumDeclSyntax) throws -> [DeclSyntax] {
        try processEnum(enumDecl: enumDecl) { type, modifiers, _ in
            [subscriptDecl(for: type, modifiers: modifiers)]
        }
    }

    private static func basicMembers(for structDecl: StructDeclSyntax, valueType: DeclReferenceExprSyntax) throws -> [DeclSyntax] {
        try processStruct(structDecl: structDecl) { modifiers in
            [
                """
                \(modifiers)var value: \(valueType)
                """,
                subscriptDecl(for: valueType, modifiers: modifiers)
            ]
        }
    }

    private static func subscriptDecl(for type: some SyntaxProtocol, modifiers: DeclModifierListSyntax) -> DeclSyntax {
        """
        \(modifiers)subscript<T>(dynamicMember keyPath: KeyPath<\(type), T>) -> T {
            value[keyPath: keyPath]
        }
        """
    }

    private static func basicEnumExtensions(
        enumType: some TypeSyntaxProtocol,
        valueType: TypeSyntax,
        modifiers: DeclModifierListSyntax,
        caseName: String
    ) throws -> [ExtensionDeclSyntax] {
        try [
            ExtensionDeclSyntax(
                """
                extension \(enumType.trimmed) {
                    \(modifiers)var value: \(valueType) {
                        switch self {
                            case let .\(raw: caseName)(value): value
                        }
                    }

                    \(modifiers)init(_ value: \(valueType)) {
                        self = .\(raw: caseName)(value)
                    }

                    \(modifiers)init?(optional value: \(valueType)?) {
                        guard let value else {
                            return nil
                        }
                        self = .\(raw: caseName)(value)
                    }
                }
                """
            )
        ]
    }

    private static func basicStructExtensions(
        structType: some TypeSyntaxProtocol,
        valueType: DeclReferenceExprSyntax,
        modifiers: DeclModifierListSyntax
    ) throws -> [ExtensionDeclSyntax] {
        try [
            ExtensionDeclSyntax(
                """
                extension \(structType.trimmed) {
                    \(modifiers)init(_ value: \(valueType)) {
                        self.value = value
                    }

                    \(modifiers)init?(optional value: \(valueType)?) {
                        guard let value else {
                            return nil
                        }
                        self = .init(value)
                    }
                }
                """
            )
        ]
    }

    private static func processEnum<T>(
        enumDecl: EnumDeclSyntax,
        process: (TypeSyntax, DeclModifierListSyntax, String) throws -> T
    ) throws -> T {
        let cases = enumDecl.memberBlock.members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        guard cases.count == 1,
              let kase = cases.first?.elements.first else {
            throw Error(message: "@Newtype must declare exactly one case")
        }
        guard let type = kase.parameterClause?.parameters.first?.type else {
            throw Error(message: "@Newtype enum case must declare an associated value")
        }

        let caseName = kase.name.trimmedDescription
        var modifiers = enumDecl.modifiers.trimmedDescription == "private"
            ? DeclModifierListSyntax()
            : enumDecl.modifiers.trimmed
        if let index = modifiers.lastIndex(where: { _ in true }) {
            modifiers[index].trailingTrivia = .space
        }
        return try process(type, modifiers, caseName)
    }

    private static func processStruct<T>(
        structDecl: StructDeclSyntax,
        process: (DeclModifierListSyntax) throws -> T
    ) throws -> T {
        var modifiers = structDecl.modifiers.trimmedDescription == "private"
            ? DeclModifierListSyntax()
            : structDecl.modifiers.trimmed
        if let index = modifiers.lastIndex(where: { _ in true }) {
            modifiers[index].trailingTrivia = .space
        }
        return try process(modifiers)
    }
}

extension AttributeSyntax {
    var conformToTypes: [DeclReferenceExprSyntax]? {
        arguments?.children(viewMode: .sourceAccurate).compactMap {
            $0.as(LabeledExprSyntax.self)?.expression.as(DeclReferenceExprSyntax.self)
        }
    }

    func exprSyntax(matching key: String) -> ExprSyntax? {
        guard let arguments else {
            return nil
        }
        return arguments.children(viewMode: .sourceAccurate)
            .first { $0.firstToken(viewMode: .sourceAccurate)?.text == key }?
            .as(LabeledExprSyntax.self)?
            .expression
    }
}

extension LabeledExprListSyntax {
    func exprSyntax(matching key: String) -> ExprSyntax? {
        children(viewMode: .sourceAccurate)
            .first { $0.firstToken(viewMode: .sourceAccurate)?.text == key }?
            .as(LabeledExprSyntax.self)?
            .expression
    }
}
