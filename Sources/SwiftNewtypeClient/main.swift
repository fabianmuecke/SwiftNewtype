// main.swift

import Foundation
import SwiftNewtype

let a = 17
let b = 25

@Newtype(Equatable, Hashable, Codable, Comparable)
@dynamicMemberLookup
enum MyTypeAlias { case myTypeAlias(String) }

@Newtype(NoConformances)
enum ConformToNothing { case foo(String) }

@Newtype
@dynamicMemberLookup
enum DefaultConformance { case defaultConformance(String) }


let foo = MyTypeAlias("foo")
if case let .myTypeAlias(foo) = foo {
    print(foo)
}

print(String(decoding: try JSONEncoder().encode(MyTypeAlias("bar")), as: UTF8.self))
print(foo.utf8)
print(foo == MyTypeAlias("bar"))
print(foo == .myTypeAlias("foo"))
print(foo < .myTypeAlias("foo"))
