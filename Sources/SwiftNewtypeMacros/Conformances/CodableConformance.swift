//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct CodableConformance: Conformance {
    let name = "Codable"

    private let decodable = DecodableConformance()
    private let encodable = EncodableConformance()

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        var result = decodable.implementation(for: type, valueType: valueType, modifiers: modifiers)
        result.members.append(contentsOf: encodable.implementation(for: type, valueType: valueType, modifiers: modifiers).members)
        return result
    }
}
