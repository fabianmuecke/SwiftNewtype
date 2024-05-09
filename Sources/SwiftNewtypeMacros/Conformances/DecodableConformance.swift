//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct DecodableConformance: Conformance {
    let name = "Decodable"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)init(from decoder: Decoder) throws {
            self.init(try \(valueType)(from: decoder))
        }
        """
    }
}
