//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct ExpressibleByStringLiteralConformance: Conformance {
    let name = "ExpressibleByStringLiteral"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)init(stringLiteral value: String) {
            self.init(\(valueType)(stringLiteral: value))
        }
        """
    }
}
