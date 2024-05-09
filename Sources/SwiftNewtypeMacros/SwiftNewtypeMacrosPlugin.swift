//
//  File.swift
//  
//
//  Created by Fabian Mücke on 08.05.24.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwiftNewtypeMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        NewtypeMacro.self,
    ]
}
