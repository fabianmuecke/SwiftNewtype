//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct IdentifiableConformance: Conformance {
    let name = "Identifiable"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)var id: \(valueType).ID {
            value.id
        }
        """
    }
}
