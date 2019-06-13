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

private enum Canonical {
    
    struct Request {
        
        enum Error: LocalizedError {
            case unwrapping
            case encoding
        }
        
        let HTTPRequestMethod: String
        let CanonicalURI: String
        let CanonicalQueryString: String
        let CanonicalHeaders: String
        let SignedHeaders: String
        let RequestPayload: String
        
        let hash: String
        
        init(request: URLRequest) throws {
            guard let method = request.httpMethod else { throw Error.unwrapping }
            HTTPRequestMethod = method
            guard let url = request.url else { throw Error.unwrapping }
            CanonicalURI = url.path
            CanonicalQueryString = url.query ?? ""
            guard let headers = request.allHTTPHeaderFields else { throw Error.unwrapping }
            SignedHeaders = headers.map{ $0.key.lowercased() }.sorted().joined(separator: ";")
            CanonicalHeaders = headers.map({ $0.key.lowercased() + ":" + $0.value }).sorted().joined(separator: "\n")
            guard let rawBody = request.httpBody else { throw Error.unwrapping }
            guard let httpBody = String(data: rawBody, encoding: .utf8) else { throw Error.encoding }
            RequestPayload = httpBody.sha256()
            hash = [
                HTTPRequestMethod, CanonicalURI, CanonicalQueryString,
                CanonicalHeaders, "", SignedHeaders, RequestPayload
                ].joined(separator: "\n").sha256()
        }
        
    }
    
}

private struct Credential {
    
    
    
}

private struct StringToSign {
    
}

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
        
        guard let headers = request.allHTTPHeaderFields else { return urlRequest }
        
        let signedHeaders = headers.map{ $0.key.lowercased() }.sorted().joined(separator: ";")
        
        let canonicalRequest = try! Canonical.Request(request: request)
        
        let canonicalRequestHash = canonicalRequest.hash
        
        let credential = [iso8601Formatter.string(from: date, style: .short),
                          AWSRegion,
                          AWSService,
                          "aws4_request"]
            .joined(separator: "/")
        
        let stringToSign = [
            "AWS4-HMAC-SHA256",
            iso8601Formatter.string(from: date, style: .full),
            credential,
            canonicalRequestHash
            ].joined(separator: "\n")
        
        guard
            let signature = hmacStringToSign(stringToSign: stringToSign,
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
    
    // kSecret = your secret access key
    // kDate = HMAC("AWS4" + kSecret, Date)
    // kRegion = HMAC(kDate, Region)
    // kService = HMAC(kRegion, Service)
    // kSigning = HMAC(kService, "aws4_request")
    
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
