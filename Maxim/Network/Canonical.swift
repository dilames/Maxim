//
//  Canonical.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import CryptoSwift

enum Canonical {
    
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
