//
//  Authorization.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

struct Authorization {
    
    let AWSAccessKeyId: String
    let AWS4Alghorithm: String = "AWS4-HMAC-SHA256"
    let credential: Credential
    
}
