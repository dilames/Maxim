//
//  Polly+Implementation.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//


extension Polly.Synthesize {
    
    var parameters: [String: String] {
        switch self {
        case .spell(let text, let voice, let format): return [
            "OutputFormat": "\(format)",
            "Text": "\(text)",
            "VoiceId": "\(voice)",
            "SampleRate": "16000"
            ]
        }
    }
    
    var path: String {
        return "/v1/speech"
    }
    
}
