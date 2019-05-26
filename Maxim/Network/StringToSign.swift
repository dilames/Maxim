//
//  StringToSign.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

struct StringToSign {
    
    let AWS4Alghorithm: String = "AWS4-HMAC-SHA256"
    let iso8601Full: String
    let credential: Credential
    let canonicalRequest: Canonical.Request
    
    let constructed: String
    
    init(date: Date,
         iso8601Formatter: ISO8601Formatter = ISO8601Formatter(),
         credential: Credential,
         canonicalRequest: Canonical.Request) {
        self.iso8601Full = iso8601Formatter.string(from: date, style: .full)
        self.credential = credential
        self.canonicalRequest = canonicalRequest
        self.constructed = [
            AWS4Alghorithm,
            iso8601Full,
            credential.constructed,
            canonicalRequest.hash
            ].joined(separator: "\n")
    }
    
}
