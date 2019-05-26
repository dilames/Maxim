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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let task = Polly.Synthesize.spell(text: "Тесты криптографии и синтезации речи завершены!", voice: .Maxim, format: .mp3)
        
        guard let url = URL(string: "\(Polly.base)\(task.path)") else { return }
        
        Alamofire.SessionManager.default.adapter = Signer()
        
        Alamofire
            .request(
                url,
                method: .post,
                parameters: task.parameters,
                encoding: JSONEncoding.default)
            .responseData {
                
                let directory = try! FileManager.default.directory(.applicationSupportDirectory, in: .allDomainsMask, withPath: "Roborock")
                let file = directory.appendingPathComponent("Polly")
                
                guard FileManager.default.createFile(
                    atPath: file.path,
                    contents: $0.data,
                    attributes: nil
                    ) else { fatalError("Could not create a file") }
                DispatchQueue.global().async {
                    let roborock = Roborock(user: "root", ip: "192.168.0.114")
                    roborock.play(url: file, volume: 0.1)
                }
        }
    }
    
    @IBAction func spell(_ sender: Any) {
        
        
    }
    
}
