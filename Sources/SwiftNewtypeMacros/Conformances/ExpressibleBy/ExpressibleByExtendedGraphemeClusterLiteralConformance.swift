//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct ExpressibleByExtendedGraphemeClusterLiteralConformance: Conformance {
    let name = "ExpressibleByExtendedGraphemeClusterLiteral"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)init(extendedGraphemeClusterLiteral value: String) {
            self.init(\(valueType)(extendedGraphemeClusterLiteral: value))
        }
        """
    }
}
