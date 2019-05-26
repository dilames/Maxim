//
//  Polly+Task.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

extension Polly.Task {
    
    var parameters: [String: String] {
        switch self {
        case .create(let text): return [
            "LanguageCode": "\(Polly.Language.ru_RU.rawValue)",
            "OutputFormat": "\(Polly.Output.mp3)",
            "Text": "\(text)",
            "OutputS3BucketName": "roborock",
            "VoiceId": "\(Polly.Voice.Maxim)",
            "SampleRate": "16000"
            ]
        }
    }
    
    var path: String {
        return "/v1/synthesisTasks"
    }
    
}
