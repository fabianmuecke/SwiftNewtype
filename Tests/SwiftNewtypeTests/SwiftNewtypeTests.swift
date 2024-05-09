// MacrosTests.swift

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may
// still make use of the macro itself in end-to-end tests.
#if canImport(SwiftNewtypeMacros)
import SwiftNewtypeMacros

let testMacros: [String: Macro.Type] = [
    "Newtype": NewtypeMacro.self
]
#endif

// swiftformat:disable trailingSpace
final class MacrosTests: XCTestCase {
    func testDiscreteMacro() throws {
        #if canImport(SwiftNewtypeMacros)
        assertMacroExpansion(
            """
            @Newtype(String)
            public struct MyTypeAlias {}
            """, 
            expandedSource: 
            """
            public struct MyTypeAlias {
            
                public var value: String
            
                public subscript <T>(dynamicMember keyPath: KeyPath<String, T>) -> T {
                    value[keyPath: keyPath]
                }}

            extension MyTypeAlias {
                public init(_ value: String) {
                    self.value = value
                }

                public init?(optional value: String?) {
                    guard let value else {
                        return nil
                    }
                    self = .init(value)
                }
            }

            extension MyTypeAlias: CustomStringConvertible {
                public var description: String {
                    String(describing: value)
                }
            }
            
            extension MyTypeAlias: Newtype {
                public typealias Value = String
            }

            extension MyTypeAlias: Equatable {
                public static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.value == rhs.value
                }
            }

            extension MyTypeAlias: Hashable {
                public func hash(into hasher: inout Hasher) {
                    value.hash(into: &hasher)
                }
            }

            extension MyTypeAlias: Codable {
                public init(from decoder: Decoder) throws {
                    self.init(try String(from: decoder))
                }
                public func encode(to encoder: Encoder) throws {
                        try value.encode(to: encoder)
                    }
            }

            extension MyTypeAlias: ExpressibleByStringLiteral {
                public init(stringLiteral value: String) {
                    self.init(String(stringLiteral: value))
                }
            }

            extension MyTypeAlias: ExpressibleByStringInterpolation {
                public init(stringInterpolation: String.StringInterpolation) {
                    self.init(String(stringInterpolation: stringInterpolation))
                }
            }

            extension MyTypeAlias: @unchecked Sendable {
            }
            """, 
            macros: testMacros
        )

        assertMacroExpansion(
            """
            @Newtype(NoConformances)
            enum MyTypeAlias { case myTypeAlias(String) }
            """,
            expandedSource:
            """
            enum MyTypeAlias { case myTypeAlias(String) 

                subscript <T>(dynamicMember keyPath: KeyPath<String, T>) -> T {
                    value[keyPath: keyPath]
                }}

            extension MyTypeAlias {
                var value: String {
                    switch self {
                        case let .myTypeAlias(value):
                        value
                    }
                }

                init(_ value: String) {
                    self = .myTypeAlias(value)
                }

                init?(optional value: String?) {
                    guard let value else {
                        return nil
                    }
                    self = .myTypeAlias(value)
                }
            }

            extension MyTypeAlias: CustomStringConvertible {
                var description: String {
                    String(describing: value)
                }
            }
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            @Newtype
            public enum MyTypeAlias { case myTypeAlias(String) }
            """,
            expandedSource:
            """
            public enum MyTypeAlias { case myTypeAlias(String) 

                public subscript <T>(dynamicMember keyPath: KeyPath<String, T>) -> T {
                    value[keyPath: keyPath]
                }}

            extension MyTypeAlias {
                public var value: String {
                    switch self {
                        case let .myTypeAlias(value):
                        value
                    }
                }

                public init(_ value: String) {
                    self = .myTypeAlias(value)
                }

                public init?(optional value: String?) {
                    guard let value else {
                        return nil
                    }
                    self = .myTypeAlias(value)
                }
            }

            extension MyTypeAlias: CustomStringConvertible {
                public var description: String {
                    String(describing: value)
                }
            }

            extension MyTypeAlias: Newtype {
                public typealias Value = String
            }

            extension MyTypeAlias: Equatable {
                public static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.value == rhs.value
                }
            }

            extension MyTypeAlias: Hashable {
                public func hash(into hasher: inout Hasher) {
                    value.hash(into: &hasher)
                }
            }

            extension MyTypeAlias: Codable {
                public init(from decoder: Decoder) throws {
                    self.init(try String(from: decoder))
                }
                public func encode(to encoder: Encoder) throws {
                        try value.encode(to: encoder)
                    }
            }

            extension MyTypeAlias: ExpressibleByStringLiteral {
                public init(stringLiteral value: String) {
                    self.init(String(stringLiteral: value))
                }
            }

            extension MyTypeAlias: ExpressibleByStringInterpolation {
                public init(stringInterpolation: String.StringInterpolation) {
                    self.init(String(stringInterpolation: stringInterpolation))
                }
            }

            extension MyTypeAlias: @unchecked Sendable {
            }
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            @Newtype
            private enum MyTypeAlias { case myTypeAlias(String) }
            """,
            expandedSource:
            """
            private enum MyTypeAlias { case myTypeAlias(String) 

                subscript <T>(dynamicMember keyPath: KeyPath<String, T>) -> T {
                    value[keyPath: keyPath]
                }}

            extension MyTypeAlias {
                var value: String {
                    switch self {
                        case let .myTypeAlias(value):
                        value
                    }
                }

                init(_ value: String) {
                    self = .myTypeAlias(value)
                }

                init?(optional value: String?) {
                    guard let value else {
                        return nil
                    }
                    self = .myTypeAlias(value)
                }
            }

            extension MyTypeAlias: CustomStringConvertible {
                var description: String {
                    String(describing: value)
                }
            }

            extension MyTypeAlias: Newtype {
                typealias Value = String
            }

            extension MyTypeAlias: Equatable {
                static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.value == rhs.value
                }
            }

            extension MyTypeAlias: Hashable {
                func hash(into hasher: inout Hasher) {
                    value.hash(into: &hasher)
                }
            }

            extension MyTypeAlias: Codable {
                init(from decoder: Decoder) throws {
                    self.init(try String(from: decoder))
                }
                func encode(to encoder: Encoder) throws {
                        try value.encode(to: encoder)
                    }
            }

            extension MyTypeAlias: ExpressibleByStringLiteral {
                init(stringLiteral value: String) {
                    self.init(String(stringLiteral: value))
                }
            }

            extension MyTypeAlias: ExpressibleByStringInterpolation {
                init(stringInterpolation: String.StringInterpolation) {
                    self.init(String(stringInterpolation: stringInterpolation))
                }
            }

            extension MyTypeAlias: @unchecked Sendable {
            }
            """,
            macros: testMacros
        )

        let expandedBaseCode = 
            """
            public enum URLTypeAlias { case url(String) 

                public subscript <T>(dynamicMember keyPath: KeyPath<String, T>) -> T {
                    value[keyPath: keyPath]
                }}

            extension URLTypeAlias {
                public var value: String {
                    switch self {
                        case let .url(value):
                        value
                    }
                }

                public init(_ value: String) {
                    self = .url(value)
                }

                public init?(optional value: String?) {
                    guard let value else {
                        return nil
                    }
                    self = .url(value)
                }
            }

            extension URLTypeAlias: CustomStringConvertible {
                public var description: String {
                    String(describing: value)
                }
            }

            extension URLTypeAlias: Newtype {
                public typealias Value = String
            }
            """
        assertMacroExpansion(
            """
            @Newtype
            public enum URLTypeAlias { case url(String) }
            """,
            expandedSource:
            """
            \(expandedBaseCode)

            extension URLTypeAlias: Equatable {
                public static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.value == rhs.value
                }
            }

            extension URLTypeAlias: Hashable {
                public func hash(into hasher: inout Hasher) {
                    value.hash(into: &hasher)
                }
            }

            extension URLTypeAlias: Codable {
                public init(from decoder: Decoder) throws {
                    self.init(try String(from: decoder))
                }
                public func encode(to encoder: Encoder) throws {
                        try value.encode(to: encoder)
                    }
            }

            extension URLTypeAlias: ExpressibleByStringLiteral {
                public init(stringLiteral value: String) {
                    self.init(String(stringLiteral: value))
                }
            }

            extension URLTypeAlias: ExpressibleByStringInterpolation {
                public init(stringInterpolation: String.StringInterpolation) {
                    self.init(String(stringInterpolation: stringInterpolation))
                }
            }

            extension URLTypeAlias: @unchecked Sendable {
            }
            """,
            macros: testMacros
        )

        func assertConformance(
            to protocols: String,
            expandsTo expected: String,
            line: UInt = #line
        ) {
            assertMacroExpansion(
                """
                @Newtype(\(protocols))
                public enum URLTypeAlias { case url(String) }
                """,
                expandedSource:
                """
                \(expandedBaseCode)

                \(expected)
                """,
                macros: testMacros,
                line: line
            )
        } 
        assertConformance(
            to: "Equatable, Hashable", 
            expandsTo: 
            """
            extension URLTypeAlias: Equatable {
                public static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.value == rhs.value
                }
            }

            extension URLTypeAlias: Hashable {
                public func hash(into hasher: inout Hasher) {
                    value.hash(into: &hasher)
                }
            }
            """
        )
        assertConformance(
            to: "Decodable",
            expandsTo:
            """
            extension URLTypeAlias: Decodable {
                public init(from decoder: Decoder) throws {
                    self.init(try String(from: decoder))
                }
            }
            """
        )

        assertConformance(
            to: "Encodable",
            expandsTo:
            """
            extension URLTypeAlias: Encodable {
                public func encode(to encoder: Encoder) throws {
                    try value.encode(to: encoder)
                }
            }
            """
        )

        assertConformance(
            to: "Codable",
            expandsTo:
            """
            extension URLTypeAlias: Codable {
                public init(from decoder: Decoder) throws {
                    self.init(try String(from: decoder))
                }
                public func encode(to encoder: Encoder) throws {
                        try value.encode(to: encoder)
                    }
            }
            """
        )

        assertConformance(
            to: "RawRepresentable",
            expandsTo:
            """
            extension URLTypeAlias: RawRepresentable {
                public var rawValue: RawValue {
                    value.rawValue
                }

                public init?(rawValue: String.RawValue) {
                    guard let value = String(rawValue: rawValue) else {
                        return nil
                    }
                    self.init(value)
                }
            }
            """
        )

        assertConformance(
            to: "Sendable",
            expandsTo:
            """
            extension URLTypeAlias: @unchecked Sendable {
            }
            """
        )

        assertConformance(
            to: "Identifiable",
            expandsTo:
            """
            extension URLTypeAlias: Identifiable {
                public var id: String.ID {
                    value.id
                }
            }
            """
        )

        assertConformance(
            to: "Strideable",
            expandsTo:
            """
            extension URLTypeAlias: Strideable {
                public typealias Stride = String.Stride

                public func distance(to other: Self) -> Stride {
                    value.distance(to: other.value)
                }

                public func advanced(by n: Stride) -> Self {
                    Self (value.advanced(by: n))
                }
            }
            """
        )

        assertConformance(
            to: "ExpressibleByNilLiteral",
            expandsTo:
            """
            extension URLTypeAlias: ExpressibleByNilLiteral {
                public init(nilLiteral _: ()) {
                    self.init(nil)
                }
            }
            """
        )

        assertConformance(
            to: "ExpressibleByStringLiteral",
            expandsTo:
            """
            extension URLTypeAlias: ExpressibleByStringLiteral {
                public init(stringLiteral value: String) {
                    self.init(String(stringLiteral: value))
                }
            }
            """
        )

        assertConformance(
            to: "ExpressibleByFloatLiteral",
            expandsTo:
            """
            extension URLTypeAlias: ExpressibleByFloatLiteral {
                public init(floatLiteral value: Double) {
                    self.init(String(floatLiteral: value))
                }
            }
            """
        )

        assertConformance(
            to: "ExpressibleByIntegerLiteral",
            expandsTo:
            """
            extension URLTypeAlias: ExpressibleByIntegerLiteral {
                public init(integerLiteral value: Int) {
                    self.init(String(integerLiteral: value))
                }
            }
            """
        )

        assertConformance(
            to: "ExpressibleByBooleanLiteral",
            expandsTo:
            """
            extension URLTypeAlias: ExpressibleByBooleanLiteral {
                public init(booleanLiteral value: Bool) {
                    self.init(String(booleanLiteral: value))
                }
            }
            """
        )

        assertConformance(
            to: "ExpressibleByExtendedGraphemeClusterLiteral",
            expandsTo:
            """
            extension URLTypeAlias: ExpressibleByExtendedGraphemeClusterLiteral {
                public init(extendedGraphemeClusterLiteral value: String) {
                    self.init(String(extendedGraphemeClusterLiteral: value))
                }
            }
            """
        )

        assertConformance(
            to: "ExpressibleByUnicodeScalarLiteral",
            expandsTo:
            """
            extension URLTypeAlias: ExpressibleByUnicodeScalarLiteral {
                public init(unicodeScalarLiteral value: String) {
                    self.init(String(unicodeScalarLiteral: value))
                }
            }
            """
        )

        assertConformance(
            to: "ExpressibleByStringInterpolation",
            expandsTo:
            """
            extension URLTypeAlias: ExpressibleByStringInterpolation {
                public init(stringInterpolation: String.StringInterpolation) {
                    self.init(String(stringInterpolation: stringInterpolation))
                }
            }
            """
        )

        assertMacroExpansion(
            """
            @Newtype
            private enum MyTypeAlias { case myTypeAlias(URL) }
            """,
            expandedSource:
            """
            private enum MyTypeAlias { case myTypeAlias(URL) 

                subscript <T>(dynamicMember keyPath: KeyPath<URL, T>) -> T {
                    value[keyPath: keyPath]
                }}

            extension MyTypeAlias {
                var value: URL {
                    switch self {
                        case let .myTypeAlias(value):
                        value
                    }
                }

                init(_ value: URL) {
                    self = .myTypeAlias(value)
                }

                init?(optional value: URL?) {
                    guard let value else {
                        return nil
                    }
                    self = .myTypeAlias(value)
                }
            }

            extension MyTypeAlias: CustomStringConvertible {
                var description: String {
                    String(describing: value)
                }
            }

            extension MyTypeAlias: Newtype {
                typealias Value = URL
            }

            extension MyTypeAlias: Equatable {
                static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.value == rhs.value
                }
            }

            extension MyTypeAlias: Hashable {
                func hash(into hasher: inout Hasher) {
                    value.hash(into: &hasher)
                }
            }

            extension MyTypeAlias: Codable {
                init(from decoder: Decoder) throws {
                    self.init(try URL(from: decoder))
                }
                func encode(to encoder: Encoder) throws {
                        try value.encode(to: encoder)
                    }
            }

            extension MyTypeAlias: @unchecked Sendable {
            }
            """,
            macros: testMacros
        )

        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}

// swiftformat:enable trailingSpace
