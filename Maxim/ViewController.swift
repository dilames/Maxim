//
//  ViewController.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/7/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Cocoa
import Alamofire

class ViewController: NSViewController {
    
    @IBOutlet private var textView: NSTextView!
    
    @IBAction func spell(_ sender: Any) {
        let task = Polly.Synthesize.spell(text: textView.string)
        
        guard let url = URL(string: "https://polly.us-east-2.amazonaws.com\(task.path)") else { return }
        
        Alamofire.SessionManager.default.adapter = Signer()
        
        Alamofire
            .request(
                url,
                method: .post,
                parameters: task.parameters,
                encoding: JSONEncoding.default)
            .responseData {
                
                let directory = try! FileManager.default.directory(.applicationSupportDirectory, in: .allDomainsMask, withPath: "Roborock")
                let file = directory.appendingPathComponent("Audio.mp3")
                
                guard FileManager.default.createFile(
                    atPath: file.path,
                    contents: $0.data,
                    attributes: nil
                    ) else { fatalError("Could not create a file") }
                
                let roborock = Roborock(user: "root", ip: "192.168.0.114")
                roborock.play(url: file, volume: 0.3)
        }
    }
    
}

final class Roborock {
    
    private let user: String
    private let ip: String
    
    init(user: String, ip: String) {
        self.user = user
        self.ip = ip
    }
    
    func play(url: URL, volume: Float = 0.7) {
        
        let copy: Process = {
            let process = Process()
            process.launchPath = "/usr/bin/env"
            process.environment = ProcessInfo.processInfo.environment
            process.arguments = [
                "scp", url.path, "\(user)@\(ip):/"
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
                "-v",
                "\(volume)",
                "--magic",
                "/\(url.lastPathComponent)"
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
                "/\(url.lastPathComponent)"
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
