//
//  Window.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Cocoa

final class Window: NSWindow {
    
    private lazy var titlebarAccessoryView: NSTitlebarAccessoryViewController = {
        let accessory = NSTitlebarAccessoryViewController()
        accessory.view = NSView()
        accessory.view.frame.size.height = 20
        return accessory
    }()
    
    private var buttons: [NSButton] = []
    private var originalLeadingOffsets: [CGFloat] = []
    
    override init(contentRect: NSRect,
                  styleMask style: NSWindow.StyleMask,
                  backing backingStoreType: NSWindow.BackingStoreType,
                  defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        addTitlebarAccessoryViewController(titlebarAccessoryView)
        buttons = [.zoomButton, .closeButton, .miniaturizeButton].compactMap { standardWindowButton($0) }
    }
    
    override func update() {
        super.update()
        
        forceButtonsFrameAllocation()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        if originalLeadingOffsets.isEmpty {
            let firstButtonOffset = buttons.first?.frame.origin.x ?? 0
            originalLeadingOffsets = buttons.map { $0.frame.origin.x - firstButtonOffset }
        }
        
        if inLiveResize {
            forceButtonsFrameAllocation()
        }
    }
    
    override func toggleFullScreen(_ sender: Any?) {
        super.toggleFullScreen(sender)
        titlebarAccessoryView.isHidden = !titlebarAccessoryView.isHidden
        forceButtonsFrameAllocation()
    }
    
    private func forceButtonsFrameAllocation() {
        guard !originalLeadingOffsets.isEmpty, !self.titlebarAccessoryView.isHidden  else { return }
        buttons.enumerated().forEach {
            $0.element.frame.origin = CGPoint(x: originalLeadingOffsets[$0.offset] + 60,
                                              y: self.titlebarAccessoryView.view.frame.height * 0.5)
        }
    }
    
}
