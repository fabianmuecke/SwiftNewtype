//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct ExpressibleByFloatLiteralConformance: Conformance {
    let name = "ExpressibleByFloatLiteral"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)init(floatLiteral value: Double) {
            self.init(\(valueType)(floatLiteral: value))
        }
        """
    }
}
