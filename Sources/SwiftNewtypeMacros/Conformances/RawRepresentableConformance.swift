//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct RawRepresentableConformance: Conformance {
    let name = "RawRepresentable"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)var rawValue: RawValue {
            value.rawValue
        }

        \(modifiers)init?(rawValue: \(valueType).RawValue) {
            guard let value = \(valueType)(rawValue: rawValue) else {
                return nil
            }
            self.init(value)
        }
        """
    }
}
