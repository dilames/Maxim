//
//  BundleProperty.swift
//  Maxim
//
//  Created by Andrew Chersky on 1/18/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

final class BundleProperty<PropertyType>: KeyStorable {
    
    typealias Storage = Bundle
    typealias ValueType = PropertyType
    
    internal var storage: Bundle = Bundle.main
    internal var key: String = ""
    
}

extension KeyStorable where Storage == Bundle {
    func stored() -> ValueType? {
        return storage.object(forInfoDictionaryKey: key) as? ValueType
    }
}
