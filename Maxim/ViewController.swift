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
    
    let play = Play(url: "https://polly.us-west-2.amazonaws.com/v1/speech?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAYK7H22UMYFGI5UZN%2F20190525%2Fus-west-2%2Fpolly%2Faws4_request&X-Amz-Date=20190525T185736Z&X-Amz-Expires=215999&X-Amz-SignedHeaders=host&Text=%D0%AD%D1%82%D0%BE%20%D0%BD%D0%B5%20%D1%81%D0%BC%D0%B5%D1%88%D0%BD%D0%BE&VoiceId=Maxim&OutputFormat=mp3&X-Amz-Security-Token=AgoGb3JpZ2luED8aCXVzLXdlc3QtMiKAApZHJt%2BI%2B6Iycv%2FPseXaCfD9OuvohORNQ2MUfnXzOejVi4p%2Bn%2BaWBHjfDQVmzF7CZZD6aapYdENCeqLcPiwaRfWFtsDxrKX3dAGCl%2BTpOxj67C%2B2rmyt1%2FgotZ2B8mt6K5fsMnPT0HGeQtuCyPhSiKYArpfA01Vh3JNXga5ZBDijz%2F1koj3aRzEk3rWOX7wAGGxEn%2B9Fml3BdsHumy4s4dJw%2Fj7GzRbpnLaJS3IbGJq%2FZrgGpEWGWOackWVNodrY1ffu3JU1RvODIAw17iYTqMTT9PTR4f%2Fuk8awmkA6%2FwHBphVOaHPZV6LcG6arf2R1wkNKn9WmKq2jkw%2B%2FSEdSAZcqtQYI9P%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgw1NzMzMjc0NjM3MDUiDDorxeLPDqNpM%2Bw%2FZiqJBof1KLJ89CyokRHQUajoFmKwlzV6f8U3TQJbhRwJlDDgzvgqbPHPGFqpHnH%2FxgSi3xUPPvDAmtLzrWk6Rk2nQhzFklxnY4%2FuKYCJDfdE4CB23UCaNyoKTHM1anLFG7ykurBzO0bCaZNIj8mGmAuay%2BzOIX%2Bu1vqD%2FscMMWurEgBEpDq8yYF%2F%2Fc5g2l%2Bi%2F8Yo4W2ATy4%2B0hrBPvFGqPFfDk5GmO87rqzPPkerXPPrbtnDQbOXTLXXmVdZcSyENFhC5IyvsttH6qo1WEct8EDwDEcTjiSFkt5jFBxoah1gluHzObbiR989VyleY%2BVBMJowHoRYienBYsC9oCZ30vyM8fAKXBlUdFWcf5Tyd0TGTFCqn3NCohBorV%2BQwrkuQ37tNTt8IjruaQWIPl5N5XocAkJFM6f%2FCBHn8lf6jiEl0qABRScH8Art%2FmfOnDVZLDKIpmoNDSVE9LY9mjzdjxS5TDuyjSCxJSH5lDTwPBo%2Fo%2B8rynp8UhdmoDrpQ9KvfNBjTTdzOt0dgu%2FOB0Dslr90VYeDYK1q0avFOjk8PkGpuc3dj7WTcZ1HOG7nvgcGESUffDC8M%2Fe7FY7xRq0KLKwPT5q5rn5H2%2Be9DG2u37OMrd0iy0obtbnw1Uv6BmNKpbvv6Vg%2FPtIRLgHgOWcijWKHDQkORJMqyidp5NsCbULwyvqIugteXnSAkxzA6g0Hr9hZQrBm6bZx7iElO%2FSoF9Oy%2FSO3R34NYaMISKHVu%2Bsu8QvsIJOY8UWQYfGu2PyYtEdwAReptr9Du0cHDnxlciXiUUs1vnntrw%2FRS0HvzvDp6%2FRZkx%2FrlEA8JO8oWWCSFAJUw3BEXnFA%2BvSyU59%2BZiKUP8%2FX0syMrd6hvP%2F0hRIgx3WtUAlYeTiPr%2FNIWCuAJrakPpZJywoj2%2FidC3AyjqKe4QQ6q1Yb%2FH%2B8%2BASpZ6eTmO77VEuDMScoWN4OVpVZ%2BkX9ScWs%2F6In5INs12RXEXhIqsEP%2FepeAMANUcFXadVjVLiDU9lgX7vsCz0DoUPaAzm%2Br4KXLcNqz7sPIjCaoKbnBQ%3D%3D&X-Amz-Signature=05216fc6b90c1bd501f63dbaed9d257065f9f0144d9c9cd83e7da96961ad2569"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        play.start()
    }
    
}



final class Play {
    
    private lazy var process: Process = {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = ["ssh",
                             "root@192.168.0.114",
                             "-t",
                             "play",
                             "--magic",
        ]
        return process
    }()
    
    private let url: String
    private let volume: Float
    
    init(url: String, volume: Float = 0.7) {
        self.url = url
        self.volume = volume
    }
    
    func start() {
        process.arguments! += ["-v", "\(volume)", "\"\(url)\""]
        process.launch()
    }
}
