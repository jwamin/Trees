//
//  AppDelegate.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,NSMenuDelegate {

    var windowController:NSWindowController!
    @objc dynamic var windowIsOpen:Bool = false{
        didSet{
            print("windowIsOpen set \(windowIsOpen)")
        }
    }
    var new:NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSApplication.shared.menu?.delegate = self
        new = NSApplication.shared.menu?.items[1].submenu?.items[0]
        new.action = #selector(reopenWindow)
        reopenWindow()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    @objc func reopenWindow(){
            
        let rect = NSRect(x:400 , y: 300, width: 800, height: 600)
        
        let window = NSWindow(contentRect: rect, styleMask: [.titled,.closable,.resizable], backing: .buffered, defer: false)
        
        windowController = NSWindowController(window: window)
        
        windowIsOpen = true
        let vc = DrawViewController(rect:rect)
        print("initialised view controller")
            window.contentViewController = vc
            new.isEnabled = false
            print(new.isEnabled)
            window.delegate = vc
            window.title = "Trees"
            window.makeKeyAndOrderFront(self)
            vc.becomeFirstResponder()
            
        
    }
    
    
    @IBAction func doSomething(_ sender: Any) {
        print("ok, doing something")
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        print("got terminate", sender)
        return NSApplication.TerminateReply.terminateNow
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("teardown")
    }

}

