//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

protocol Conformance {
    var name: String { get }

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax

    func conform(
        type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) throws -> ExtensionDeclSyntax
}

extension Conformance {
    func conform(
        type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) throws -> ExtensionDeclSyntax {
        try ExtensionDeclSyntax(
            """
            extension \(type.trimmed): \(raw: name) {
                \(implementation(for: type, valueType: valueType, modifiers: modifiers))
            }
            """
        )
    }
}

let allConformances: [String: any Conformance] = Dictionary(uniqueKeysWithValues: [
    EquatableConformance(),
    HashableConformance(),
    DecodableConformance(),
    EncodableConformance(),
    CodableConformance(),
    ComparableConformance(),
    RawRepresentableConformance(),
    SendableConformance(),
    IdentifiableConformance(),
    StrideableConformance(),
    ExpressibleByNilLiteralConformance(),
    ExpressibleByStringLiteralConformance(),
    ExpressibleByFloatLiteralConformance(),
    ExpressibleByIntegerLiteralConformance(),
    ExpressibleByBooleanLiteralConformance(),
    ExpressibleByExtendedGraphemeClusterLiteralConformance(),
    ExpressibleByUnicodeScalarLiteralConformance(),
    ExpressibleByStringInterpolationConformance()
].map { (conformance: any Conformance) -> (String, any Conformance) in
    (conformance.name, conformance)
})
