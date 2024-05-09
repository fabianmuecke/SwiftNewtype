//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct ComparableConformance: Conformance {
    let name = "Comparable"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.value < rhs.value
        }
        """
    }
}
