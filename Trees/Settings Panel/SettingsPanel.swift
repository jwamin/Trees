//
//  SettingsPanel.swift
//  Trees
//
//  Created by Joss Manger on 10/2/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

class SettingsPanel : NSPanel {
    
//    convenience init() {
//        print("initialising settings panel")
//        let rect = NSRect(x: 200, y: 200, width: 257.0, height: 379.0)
//        self.init(contentRect: rect, styleMask: [.utilityWindow,.closable,.resizable,.titled], backing: .buffered, defer: true)
//        self.isReleasedWhenClosed = true
//        self.title = "Advanced Options"
//        self.contentViewController = Settings
//    }
    
    override func awakeFromNib() {
        print("hello from panel")
    }
    
    deinit {
        print("panel closed and deinitialised")
    }
    
}
