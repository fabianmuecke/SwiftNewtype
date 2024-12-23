//
//  File.swift
//  
//
//  Created by Fabian Mücke on 10.05.24.
//

import Foundation

/// A protocol representing all Newtype type wrappers.
/// 
/// Conformance to this will be added to all types marked with `@Newtype`, unless ``NoConformances`` argument is provided. 
public protocol Newtype {
    /// The wrapped value type.
    associatedtype Value
    
    var value: Value { get }
    
    /// Initializes a new instance of the ``Newtype``.
    init(_ value: Value)
}
