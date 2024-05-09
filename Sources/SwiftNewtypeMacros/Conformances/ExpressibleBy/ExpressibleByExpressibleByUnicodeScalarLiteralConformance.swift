//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct ExpressibleByUnicodeScalarLiteralConformance: Conformance {
    let name = "ExpressibleByUnicodeScalarLiteral"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)init(unicodeScalarLiteral value: String) {
            self.init(\(valueType)(unicodeScalarLiteral: value))
        }
        """
    }
}
