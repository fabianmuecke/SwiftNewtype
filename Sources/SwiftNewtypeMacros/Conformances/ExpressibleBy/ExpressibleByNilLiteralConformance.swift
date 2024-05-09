//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct ExpressibleByNilLiteralConformance: Conformance {
    let name = "ExpressibleByNilLiteral"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)init(nilLiteral _: ()) {
            self.init(nil)
        }
        """
    }
}
