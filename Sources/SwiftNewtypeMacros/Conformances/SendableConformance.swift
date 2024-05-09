//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct SendableConformance: Conformance {
    let name = "Sendable"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        """
    }

    func conform(
        type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) throws -> ExtensionDeclSyntax {
        try ExtensionDeclSyntax(
            "extension \(type.trimmed): @unchecked Sendable {}"
        )
    }
}
