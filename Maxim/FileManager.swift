//
//  FileManager.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

extension FileManager {
    
    enum Error: LocalizedError {
        case missingDirectory
    }
    
    func directory(_ directory: SearchPathDirectory, in domain: SearchPathDomainMask, withPath path: String) throws -> URL {
        guard let directoryPath = NSSearchPathForDirectoriesInDomains(directory, domain, true).first?.appending("/" + path) else {
            throw Error.missingDirectory
        }
        try createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        return URL(fileURLWithPath: directoryPath)
    }
    
}
