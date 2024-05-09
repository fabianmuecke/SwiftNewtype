// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: arbitrary)
@attached(
    extension,

    conformances:
    Newtype,
    CustomStringConvertible,
    RawRepresentable,
    Sendable,
    Identifiable,
    Equatable,
    Hashable,
    Comparable,
    Decodable,
    Encodable,
    ExpressibleByNilLiteral,
    ExpressibleByStringLiteral,
    ExpressibleByFloatLiteral,
    ExpressibleByIntegerLiteral,
    Strideable,
    ExpressibleByBooleanLiteral,
    ExpressibleByArrayLiteral,
    ExpressibleByDictionaryLiteral,
    ExpressibleByExtendedGraphemeClusterLiteral,
    ExpressibleByUnicodeScalarLiteral,
    ExpressibleByStringInterpolation,

    names:
    named(value),
    named(init),
    arbitrary
)
public macro Newtype(_ conforming: Any.Type...) = #externalMacro(module: "SwiftNewtypeMacros", type: "NewtypeMacro")
