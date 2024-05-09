//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation
import SwiftSyntax

struct StrideableConformance: Conformance {
    let name = "Strideable"
    
    func implementation(
        for type: some TypeSyntaxProtocol,
        valueType: some SyntaxProtocol,
        modifiers: DeclModifierListSyntax
    ) -> MemberBlockSyntax {
        """
        \(modifiers)typealias Stride = \(valueType).Stride

        \(modifiers)func distance(to other: Self) -> Stride {
            value.distance(to: other.value)
        }

        \(modifiers)func advanced(by n: Stride) -> Self {
            Self(value.advanced(by: n))
        }
        """
    }
}
