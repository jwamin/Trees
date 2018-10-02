//
//  SettingsWindowController.swift
//  Trees
//
//  Created by Joss Manger on 9/28/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController, NSWindowDelegate {


    
    override func windowDidLoad() {
        super.windowDidLoad()
        print("window loaded")
        self.window?.makeKeyAndOrderFront(self)
        self.window?.title = "Advanced Options"
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        print("whaaa?")
        return true
    }
    
    override func awakeFromNib() {
        print("get woke")
    }
    
    override func close() {
        print("close")
    }
    
    deinit {
        print("immediately deinitialised")
    }
    
}
