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

    @IBOutlet var window: NSWindow!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
       
        let rect = NSRect(x: 0, y: 0, width: 800, height: 600)
        let vc = DrawViewController(rect:rect)
        
        window = NSWindow(contentViewController: vc)
        window.title = "Trees"
        //window.contentView = vc.view
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

