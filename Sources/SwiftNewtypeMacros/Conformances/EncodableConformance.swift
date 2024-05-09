//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct EncodableConformance: Conformance {
    let name = "Encodable"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)func encode(to encoder: Encoder) throws {
            try value.encode(to: encoder)
        }
        """
    }
}
