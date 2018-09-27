//
//  AppDelegate.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let rect = NSRect(x:400 , y: 300, width: 800, height: 600)
        window = NSWindow(contentRect: rect, styleMask: [.titled,.closable,.resizable], backing: .buffered, defer: false)
        
        let vc = DrawViewController(rect:rect)
        print("initialised view controller")
        window.contentViewController = vc
        
        window.title = "Trees"
        window.makeKeyAndOrderFront(self)
        vc.becomeFirstResponder()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("teardown")
    }


}

