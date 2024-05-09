//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct ExpressibleByIntegerLiteralConformance: Conformance {
    let name = "ExpressibleByIntegerLiteral"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)init(integerLiteral value: Int) {
            self.init(\(valueType)(integerLiteral: value))
        }
        """
    }
}
