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
    
    private var AWSAccessKeyId = "AKIAJOOWOH5RJ3AAILKA"
    private let AWSSecretKey = "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"
    private let AWSRegion = "us-east-2"
    private let AWSService = "polly"
    private let AWS4Request = "aws4_request"
    
    private let hmacShaTypeString = "AWS4-HMAC-SHA256"
    
    private let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyyMMdd'T'HHmmssXXXXX"
        return formatter
    }()
    
    private func iso8601() -> (full: String, short: String) {
        let date = iso8601Formatter.string(from: Date())
        let shortDate = date[..<date.index(date.startIndex, offsetBy: 8)]
        return (full: date, short: String(shortDate))
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var signedRequest = urlRequest
        let date = iso8601()
        
        guard
            let bodyData = signedRequest.httpBody,
            let body = String(data: bodyData, encoding: .utf8),
            let url = signedRequest.url, let host = url.host
            else { return urlRequest }
        
        signedRequest.addValue(host, forHTTPHeaderField: "Host")
        signedRequest.addValue(date.full, forHTTPHeaderField: "X-Amz-Date")
        
        guard
            let headers = signedRequest.allHTTPHeaderFields,
            let httpMethod = signedRequest.httpMethod
            else { return urlRequest }
        
        let signedHeaders = headers.map{ $0.key.lowercased() }.sorted().joined(separator: ";")
        
        let canonicalHeaders = headers.map({ $0.key.lowercased() + ":" + $0.value }).sorted().joined(separator: "\n")
        
        let canonicalRequestHash = [
            httpMethod,
            url.path,
            url.query ?? "",
            canonicalHeaders,
            "",
            signedHeaders,
            body.sha256()
            ].joined(separator: "\n").sha256()
        
        let credential = [date.short, AWSRegion, AWSService, AWS4Request].joined(separator: "/")
        
        let stringToSign = [
            hmacShaTypeString,
            date.full,
            credential,
            canonicalRequestHash
            ].joined(separator: "\n")
        
        guard
            let signature = hmacStringToSign(stringToSign: stringToSign,
                                             secretSigningKey: AWSSecretKey,
                                             shortDateString: date.short)
            else { return urlRequest }
        
        let authorization = hmacShaTypeString
            + " Credential="
            + AWSAccessKeyId
            + "/"
            + credential
            + ", SignedHeaders="
            + signedHeaders
            + ", Signature="
            + signature
        signedRequest.addValue(authorization, forHTTPHeaderField: "Authorization")
        return signedRequest
    }
    
    private func hmacStringToSign(stringToSign: String, secretSigningKey: String, shortDateString: String) -> String? {
        let k1 = "AWS4" + secretSigningKey
        guard
            let sk1 = try? HMAC(key: [UInt8](k1.utf8), variant: .sha256).authenticate([UInt8](shortDateString.utf8)),
            let sk2 = try? HMAC(key: sk1, variant: .sha256).authenticate([UInt8](AWSRegion.utf8)),
            let sk3 = try? HMAC(key: sk2, variant: .sha256).authenticate([UInt8](AWSService.utf8)),
            let sk4 = try? HMAC(key: sk3, variant: .sha256).authenticate([UInt8](AWS4Request.utf8)),
            let signature = try? HMAC(key: sk4, variant: .sha256).authenticate([UInt8](stringToSign.utf8))
            else { return .none }
        return signature.toHexString()
    }
}
