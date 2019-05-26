//
//  Roborock.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

final class Roborock {
    
    private let user: String
    private let ip: String
    
    init(user: String, ip: String) {
        self.user = user
        self.ip = ip
    }
    
    func play(url: URL, volume: Float = 0.001) {
        
        let copy: Process = {
            let process = Process()
            process.launchPath = "/usr/bin/env"
            process.environment = ProcessInfo.processInfo.environment
            process.arguments = [
                "scp", url.path, "\(user)@\(ip):~/"
            ]
            return process
        }()
        
        let play: Process = {
            let process = Process()
            process.launchPath = "/usr/bin/env"
            process.environment = ProcessInfo.processInfo.environment
            process.arguments = [
                "ssh", "\(user)@\(ip)",
                "-t",
                "play",
                "-t",
                "mp3",
                "-v \(volume)",
                "~/\u{0022}\(url.lastPathComponent)\u{0022}"
            ]
            return process
        }()
        
        let delete: Process = {
            let process = Process()
            process.launchPath = "/usr/bin/env"
            process.environment = ProcessInfo.processInfo.environment
            process.arguments = [
                "ssh", "\(user)@\(ip)",
                "-t",
                "rm -rf",
                "~/\u{0022}\(url.lastPathComponent)\u{0022}"
            ]
            return process
        }()
        
        copy.launch()
        copy.waitUntilExit()

        play.launch()
        play.waitUntilExit()

        delete.launch()
        delete.waitUntilExit()
    }
}
