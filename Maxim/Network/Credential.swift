//
//  Credential.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import struct Foundation.Date

struct Credential {
    
    let iso8601Full: String
    let awsRegion: String
    let awsService: String
    let aws4Request: String = "aws4_request"
    
    let constructed: String
    
    init(date: Date,
         iso8601Formatter: ISO8601Formatter = ISO8601Formatter(),
         awsRegion: String,
         awsService: String) {
        self.awsRegion = awsRegion
        self.awsService = awsService
        self.iso8601Full = iso8601Formatter.string(from: date, style: .full)
        constructed = [iso8601Formatter.string(from: date, style: .short),
                       awsRegion,
                       awsService,
                       "aws4_request"].joined(separator: "/")
    }
}
