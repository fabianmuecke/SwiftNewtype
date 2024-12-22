//
//  ExpressibleByGraphemeClusterConformance.swift
//  SwiftNewtype
//
//  Created by Fabian Mücke on 22.12.24.
//
import Foundation
import SwiftSyntax

struct ExpressibleByGraphemeClusterLiteralConformance: Conformance {
    let name = "ExpressibleByGraphemeClusterLiteral"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)init(extendedGraphemeClusterLiteral: ExtendedGraphemeClusterLiteralType) {
            self.init(\(valueType)(extendedGraphemeClusterLiteral: extendedGraphemeClusterLiteral))
        }
        """
    }
}
