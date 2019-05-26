//
//  KeyRepresentable.swift
//  Maxim
//
//  Created by Andrew Chersky on 1/18/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

public protocol KeyRepresentable {
    var prefix: String { get }
    var identifier: String { get }
}

public extension KeyRepresentable where Self: RawRepresentable, Self.RawValue == String {
    var identifier: String {
        return rawValue
    }
}

public extension KeyRepresentable {
    var prefix: String {
        return Environment.value(forKey: .bundleIdentifier)
    }
    var identifier: String {
        return prefix + "." + String(reflecting: self)
    }
}
