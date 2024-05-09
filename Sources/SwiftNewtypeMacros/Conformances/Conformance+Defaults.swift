//
//  File.swift
//
//
//  Created by Fabian Mücke on 08.05.24.
//

import Foundation

let defaultConformances: [String: [any Conformance]] = [
    "String": [EquatableConformance(), HashableConformance(), CodableConformance(), ExpressibleByStringLiteralConformance(),
               ExpressibleByStringInterpolationConformance(), SendableConformance()],
    "Int": integerConformances,
    "Int32": integerConformances,
    "Int64": integerConformances,
    "UInt": integerConformances,
    "UInt32": integerConformances,
    "UInt64": integerConformances,
    "URL": [EquatableConformance(), HashableConformance(), CodableConformance(), SendableConformance()],
    "Date": [EquatableConformance(), HashableConformance(), ComparableConformance(), CodableConformance(), SendableConformance()],
    "Float": floatConformances,
    "Double": floatConformances,
    "UUID": [EquatableConformance(), HashableConformance(), CodableConformance(), SendableConformance()]
]

let integerConformances: [any Conformance] = [
    EquatableConformance(),
    HashableConformance(),
    ComparableConformance(),
    CodableConformance(),
    ExpressibleByIntegerLiteralConformance(),
    SendableConformance()
]
let floatConformances: [any Conformance] = [
    EquatableConformance(),
    HashableConformance(),
    ComparableConformance(),
    CodableConformance(),
    ExpressibleByFloatLiteralConformance(),
    SendableConformance()
]
