//
//  ExpressibleByUnicodeScalarLiteral.swift
//  SwiftNewtype
//
//  Created by Fabian Mücke on 22.12.24.
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
        \(modifiers)init(unicodeScalarLiteral: UnicodeScalarLiteralType) {
            self.init(\(valueType)(unicodeScalarLiteral: unicodeScalarLiteral))
        }
        """
    }
}
