//
//  Environment.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

public final class Environment {
    
    private init() {}
    
    public enum Keys: String, RawRepresentable, KeyRepresentable {
        case bundleIdentifier = "CFBundleIdentifier"
        case shortVersion = "CFBundleShortVersionString"
        case awsRegion = "AWSRegion"
        case awsService = "AWSService"
        case awsSecretKey = "AWSSecretKey"
        case awsAccessKeyId = "AWSAccessKeyId"
    }
    
    static func value<ValueType>(forKey key: Keys) -> ValueType {
        guard let value = BundleProperty<ValueType>(forKey: key, in: Bundle.main).stored() else {
            fatalError("\(String(describing: self)) property for key: \(key.identifier) can't be nil")
        }
        return value
    }
}
