//
//  Some.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/24/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire

class Signer: RequestAdapter {
    
    private let AWSAccessKeyId: String = Environment.value(forKey: .awsAccessKeyId)
    private let AWSSecretKey: String = Environment.value(forKey: .awsSecretKey)
    private let AWSRegion: String = Environment.value(forKey: .awsRegion)
    private let AWSService: String = Environment.value(forKey: .awsService)
    
    private var iso8601Formatter = ISO8601Formatter()
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        var request = urlRequest
        let date = Date()
        
        guard
            let url = request.url,
            let host = url.host
            else { return urlRequest }
        
        request.addValue(host, forHTTPHeaderField: "Host")
        request.addValue(iso8601Formatter.string(from: date, style: .full), forHTTPHeaderField: "X-Amz-Date")
        
        let canonicalRequest = try! Canonical.Request(request: request)
        
        let signedHeaders = canonicalRequest.SignedHeaders
        
        let credentials = Credential(date: date,
                                     iso8601Formatter: iso8601Formatter,
                                     awsRegion: AWSRegion,
                                     awsService: AWSService)
        
        let credential = credentials.constructed
        
        let stringToSigns = StringToSign(date: date,
                     iso8601Formatter: iso8601Formatter,
                     credential: credentials,
                     canonicalRequest: canonicalRequest)
        
        let stringToSign = stringToSigns.constructed
        
        guard
            let signature: String = hmacStringToSign(stringToSign: stringToSign,
                                                     secretSigningKey: AWSSecretKey,
                                                     shortDateString: iso8601Formatter.string(from: date, style: .short))
            else { return urlRequest }
        
        let authorization = "AWS4-HMAC-SHA256"
            + " Credential="
            + AWSAccessKeyId
            + "/"
            + credential
            + ", SignedHeaders="
            + signedHeaders
            + ", Signature="
            + signature
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func hmacStringToSign(stringToSign: String, secretSigningKey: String, shortDateString: String) -> String? {
        let k1 = "AWS4" + secretSigningKey
        guard
            let sk1 = try? HMAC(key: [UInt8](k1.utf8), variant: .sha256).authenticate([UInt8](shortDateString.utf8)),
            let sk2 = try? HMAC(key: sk1, variant: .sha256).authenticate([UInt8](AWSRegion.utf8)),
            let sk3 = try? HMAC(key: sk2, variant: .sha256).authenticate([UInt8](AWSService.utf8)),
            let sk4 = try? HMAC(key: sk3, variant: .sha256).authenticate([UInt8]("aws4_request".utf8)),
            let signature = try? HMAC(key: sk4, variant: .sha256).authenticate([UInt8](stringToSign.utf8))
            else { return .none }
        return signature.toHexString()
    }
}
