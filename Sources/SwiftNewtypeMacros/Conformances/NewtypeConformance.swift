//
//  File.swift
//
//
//  Created by Fabian Mücke on 10.05.24.
//

import Foundation
import SwiftSyntax

struct NewtypeConformance: Conformance {
    let name = "Newtype"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)typealias Value = \(valueType)
        """
    }
}
