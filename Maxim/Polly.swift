//
//  Polly.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/7/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

enum Language: String {
    case arb
    case cmn_CN
    case cy_GB
    case da_DK
    case de_DE
    case en_AU
    case en_GB
    case en_GB_WLS
    case en_IN
    case en_US
    case es_ES
    case es_MX
    case es_US
    case fr_CA
    case fr_FR
    case is_IS
    case it_IT
    case ja_JP
    case hi_IN
    case ko_KR
    case nb_NO
    case nl_NL
    case pl_PL
    case pt_BR
    case pt_PT
    case ro_RO
    case ru_RU
    case sv_SE
    case tr_TR
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
    
    case Spell
    
    var parameters: [String: String] {
        return [
            "LanguageCode": "\(Language.ru_RU)",
            "OutputFormat": "\(Output.mp3)",
            "Text": "Привет кожанные ублюдки, это Максимка.",
            "VoiceId": "\(Voice.Maxim)"
        ]
    }
    
    var AWSPath: String {
        return "/v1/speech"
    }
    
    var AWSRegion: String {
        return "us-east-2"
    }
    
    var AWSEndPoint: String {
        return "https://polly.us-east-2.amazonaws.com"
    }
    
    var AWSService: String {
        return "polly"
    }
    
    var AWSAccessKeyId: String {
        return "AKIAJK6LKHPN4AJBARAA"
    }
    
    var AWSSecretKey: String {
        return "XYHCB02GSklwFQbLq61Q2FUnipFn"
    }
    
}
