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
 
        self.showWindow(self)
               print(window)
        self.window?.makeKeyAndOrderFront(self)
        self.window?.title = "Advanced Options"
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    override func windowTitle(forDocumentDisplayName displayName: String) -> String {
        return "Advanced Options"
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        print("whaaa?")
        return true
    }
    
    override func close() {
        print("close")
    }
    
    deinit {
        print("immediately deinitialised")
    }
    
}
