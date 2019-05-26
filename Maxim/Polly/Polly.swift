//
//  Polly.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/7/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

enum Polly {
    
    static var base: String {
        return "https://polly.us-east-2.amazonaws.com"
    }
    
    enum Synthesize {
        case spell(text: String, voice: Polly.Voice, format: Polly.Output)
    }
    
    enum Task {
        case create(text: String)
    }
    
}
