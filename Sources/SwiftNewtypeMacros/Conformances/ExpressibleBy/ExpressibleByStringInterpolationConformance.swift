//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct ExpressibleByStringInterpolationConformance: Conformance {
    let name = "ExpressibleByStringInterpolation"

    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)init(stringInterpolation: \(valueType).StringInterpolation) {
            self.init(\(valueType)(stringInterpolation: stringInterpolation))
        }
        """
    }
}
