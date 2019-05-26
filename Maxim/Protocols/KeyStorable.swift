//
//  KeyStorable.swift
//  Maxim
//
//  Created by Andrew Chersky on 1/18/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

protocol KeyStorable {
    
    associatedtype Storage
    associatedtype ValueType
    
    var storage: Storage { get set }
    var key: String { get set }
    var hasStored: Bool { get }
    
    init()
    init(forKey key: KeyRepresentable, in storage: Storage)
    init(value: ValueType?, forKey key: KeyRepresentable, in storage: Storage)
    
    func store(value: ValueType?)
    func stored() -> ValueType?
}

// MARK: Private - KeyStorable
private extension KeyStorable {
    // Don't make this -init() public. Private modifier preverts from hardcoding string keys
    init(forKey key: String, in storage: Storage) {
        self.init()
        self.key = key
        self.storage = storage
    }
    
    init(value: ValueType?, forKey key: String, in storage: Storage) {
        self.init(forKey: key, in: storage)
        if let value = value { store(value: value) }
    }
}

// MARK: Default - KeyStorable
extension KeyStorable {
    
    var hasStored: Bool {
        return stored() != nil
    }
    
    init(forKey key: KeyRepresentable, in storage: Storage) {
        self.init(forKey: key.identifier, in: storage)
    }
    
    init(value: ValueType?, forKey key: KeyRepresentable, in storage: Storage) {
        self.init(value: value, forKey: key.identifier, in: storage)
    }
    
}

extension KeyStorable {
    func store(value: ValueType?) {
        fatalError("""
            \(String(describing: type(of: self))) can't write values to storage \(String(describing: Storage.self))
            because \(#function) doesn't implemented
            """)
    }
    
    func stored() -> ValueType? {
        fatalError("""
            \(String(describing: type(of: self))) can't read values from storage \(String(describing: Storage.self))
            """)
    }
}
