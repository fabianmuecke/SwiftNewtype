//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct HashableConformance: Conformance {
    let name = "Hashable"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)func hash(into hasher: inout Hasher) {
            value.hash(into: &hasher)
        }
        """
    }
}
