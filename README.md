# SwiftNewtype
Inspired by [Haskell's Newtype](https://wiki.haskell.org/Newtype) this project brings compile-time safety for typealiases, leveraging wrapper types and providing default implementations for common protocols to these by generating the necessary code via a Swift macro.

## Why use Newtypes?

Swift already offers `typealias`es to add some human readable semantics to a type, which is great. But two different `typealias`es pointing at the same underlying type are assignment compatible, which can lead to getting them mixed up, if not careful. Consider this example:
```swift
typealias UserId = Int
typealias AddressId = Int

let array: [(UserId, AdressId)] = [
    (user.id, address.id),
    …
]

// This won't give a compiler error
let addressIds: [UserId] = array.map { $0.1 }
```

While this example is obviously easy and you'd of course never do that, in a large code base this will eventually happen, especially, if dealing with nested lists or dictionaries or closures / callbacks, where the parameter list (or return value) changes over time. The compiler will not help you, if you're refactoring a larger codebase. You're bound to miss some spots.

This is where the concept of compile-time safe type wrappers (or [Newtype](https://wiki.haskell.org/Newtype), as they're called in Haskell) comes to the rescue.

Doing this:
```swift
struct UserId { var value: Int }
struct AddressId { var value: Int }
```

will get you a good step into the right direction, but eventually you'll want support for some of the `Foundation` protocols, that `Int` conforms to (such as `Encodable`, `Decodable`, `Equatable`, `Hashable`, `Comparable`, …). And careful here with the default implementations the compiler provides! While they'll work great for `Equatable` and `Hashable`, the `Decodable` implementation is not going to do what you want in this case.

Don't worry. `SwiftNewtype` is here to help.

## Installation

To depend on SwiftNewtype in a SwiftPM package, add the following to your Package.swift.
```swift
dependencies: [
  .package(url: "https://github.com/fabianmuecke/SwiftNewtype.git", from: "<latest SwiftNewtype tag>"),
],
```
To add SwiftNewtype as a dependency of your Xcode project, go to the Package Dependencies tab of your Xcode project, click the plus button and search for https://github.com/fabianmuecke/SwiftNewtype.git.

## Usage
Declare your compile-time safe wrapper types like this:
```swift
import SwiftNewtype

@Newtype
enum UserId { case userId(Int) }

@Newtype
enum AddressId { case addressId(Int) }
```

Using these wrapper types, your `UserId` and `AddressId` will no longer be assignment compatible. For ease of use, this macro will generate a `value` property to access the associated value, as well as two initializers (`init(_:)` and `init(optional:)` for easier wrapping) and a `subscript(dynamicMember:)`, allowing to add `@dynamicMemberLookup`, should you want that behavior. It'll also generate default conformances to some `Foundation` protocols the used value type (`Int` in the example above) conforms to. See [Conformance+Defaults.swift](./Sources/SwiftNewtypeMacros/Conformances/Conformance+Defaults.swift) for a complete list of the default conformances this will add.

If, for some reason, you do not want to conform to anything, provide `NoConformances` as a parameter like this:

```swift
@Newtype(NoConformances)
enum UserId { case userId(Int) }
```

If you want to specify which protocol conformances you want generated, simply pass in a list of the protocols like this:
```swift
@Newtype(Equatable, Hashable)
enum UserId { case userId(Int) }
```

> [!IMPORTANT]
> Make sure to only pass in protocols your associated value type actually conforms to, as SwiftSyntax cannot check this!

### Custom conformances
Additionally, all Newtypes will conform to the [`Newtype`]() protocol (unless `NoConformances` is provided), which will help to provide default conformances to other protocols.

Say you want your wrapped types to conform to GRDB's [`DatabaseValueConvertible`](https://swiftpackageindex.com/groue/grdb.swift/v6.27.0/documentation/grdb/databasevalueconvertible) protocol, if the wrapped value type does. You could do something like this:

```swift
extension Newtype where Value: DatabaseValueConvertible {
    var databaseValue: DatabaseValue {
        value.databaseValue
    }

    static func fromDatabaseValue(_ dbValue: DatabaseValue) -> Self? {
        Self.init(Value.fromDatabaseValue(dbValue))
    }
}
```

and define your Newtype like this:
```swift
@Newtype
enum UserId: DatabaseValueConvertible { case userId(Int) }
```

### Structs
"But I don't like enums. Can't I just use structs?"

Sure. I designed this to use an `enum` instead of a struct, because that allows to use pattern matching for unwrapping the value and still getting some help from the compiler, plus better readability by providing a useful name for the `case`, but if you prefer to have a `struct` for the simplicity of it, use it like this:
```swift
@Newtype(Int)
public struct UserId {}
```
The first argument supplied will be treated as the desired value type. The example above will generate the value property like this `public var value: Int`. Otherwise it will behave the same as the `enum` usage described above. You can provide `NoConformances` or specific protocols to conform to as additional arguments.

## Alternatives
* [Tagged](https://github.com/pointfreeco/swift-tagged)  
An easy to adopt one-size-fits-all approach I've been using for years, before Swift macros came along. If SwiftNewtype isn't exactly what you're looking for, this might be it.
* [NewType](https://github.com/apple/swift-syntax/blob/main/Examples/Sources/MacroExamples/Implementation/Member/NewTypeMacro.swift)  
A simple macro solution from the SwiftSyntax examples, generating conformance to `RawRepresentable`, which should also get you pretty far.
