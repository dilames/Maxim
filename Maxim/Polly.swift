//
//  Polly.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/7/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

enum Language: String {
    case arb = "arb"
    case cmn_CN = "cmn-CN"
    case cy_GB = "cy-GB"
    case da_DK = "da-DK"
    case de_DE = "de-DE"
    case en_AU = "en-AU"
    case en_GB = "en-GB"
    case en_GB_WLS = "en-GB-WLS"
    case en_IN = "en-IN"
    case en_US = "en-US"
    case es_ES = "es-ES"
    case es_MX = "es-MX"
    case es_US = "es-US"
    case fr_CA = "fr-CA"
    case fr_FR = "fr-FR"
    case is_IS = "is-IS"
    case it_IT = "it-IT"
    case ja_JP = "ja-JP"
    case hi_IN = "hi-IN"
    case ko_KR = "ko-KR"
    case nb_NO = "nb-NO"
    case nl_NL = "nl-NL"
    case pl_PL = "pl-PL"
    case pt_BR = "pt-BR"
    case pt_PT = "pt-PT"
    case ro_RO = "ro-RO"
    case ru_RU = "ru-RU"
    case sv_SE = "sv-SE"
    case tr_TR = "tr-TR"
}

enum Voice: String {
    case Aditi
    case Amy
    case Astrid
    case Bianca
    case Brian
    case Carla
    case Carmen
    case Celine
    case Chantal
    case Conchita
    case Cristiano
    case Dora
    case Emma
    case Enrique
    case Ewa
    case Filiz
    case Geraint
    case Giorgio
    case Gwyneth
    case Hans
    case Ines
    case Ivy
    case Jacek
    case Jan
    case Joanna
    case Joey
    case Justin
    case Karl
    case Kendra
    case Kimberly
    case Lea
    case Liv
    case Lotte
    case Lucia
    case Mads
    case Maja
    case Marlene
    case Mathieu
    case Matthew
    case Maxim
    case Mia
    case Miguel
    case Mizuki
    case Naja
    case Nicole
    case Penelope
    case Raveena
    case Ricardo
    case Ruben
    case Russell
    case Salli
    case Seoyeon
    case Takumi
    case Tatyana
    case Vicki
    case Vitoria
    case Zeina
    case Zhiyu
}

enum Gender: String {
    case Female
    case Male
}

enum Output: String {
    case mp3
    case ogg_vorbis
    case pcm
}

enum Polly {
    
    enum Synthesize {
        case spell(text: String)
    }
    
    enum Task {
        case create(text: String)
    }
    
}

extension Polly.Synthesize {
    
    var parameters: [String: String] {
        switch self {
        case .spell(let text): return [
            "OutputFormat": "\(Output.mp3)",
            "Text": "\(text)",
            "VoiceId": "\(Voice.Maxim)",
            "SampleRate": "16000"
            ]
        }
    }
    
    var path: String {
        return "/v1/speech"
    }
    
}

extension Polly.Task {
    
    var parameters: [String: String] {
        switch self {
        case .create(let text): return [
            "LanguageCode": "\(Language.ru_RU.rawValue)",
            "OutputFormat": "\(Output.mp3)",
            "Text": "\(text)",
            "OutputS3BucketName": "roborock",
            "VoiceId": "\(Voice.Maxim)",
            "SampleRate": "16000"
            ]
        }
    }
    
    var path: String {
        return "/v1/synthesisTasks"
    }
    
}
