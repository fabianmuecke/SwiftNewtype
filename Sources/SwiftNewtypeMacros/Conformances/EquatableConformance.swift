//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct EquatableConformance: Conformance {
    let name = "Equatable"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.value == rhs.value
        }
        """
    }
}
