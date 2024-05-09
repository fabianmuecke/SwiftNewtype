//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct ExpressibleByBooleanLiteralConformance: Conformance {
    let name = "ExpressibleByBooleanLiteral"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)init(booleanLiteral value: Bool) {
            self.init(\(valueType)(booleanLiteral: value))
        }
        """
    }
}
