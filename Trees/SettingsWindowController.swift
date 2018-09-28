//
//  SettingsWindowController.swift
//  Trees
//
//  Created by Joss Manger on 9/28/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController,NSWindowDelegate {

    override func loadWindow() {
        super.loadWindow()
        let panel = SettingsPanel()
        self.window = panel
        self.window?.delegate = self
        print("end of load window")
    }
    
    override func windowDidLoad() {
        
        print("window loaded")
        self.window?.makeKeyAndOrderFront(self)
        self.window!.title = "Advanced Options"
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    
    
    
    func createControls(){
        
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

class SettingsPanel : NSPanel {
    
    convenience init() {
        print("initialising settings panel")
        let rect = NSRect(x: 200, y: 200, width: 257.0, height: 379.0)
        self.init(contentRect: rect, styleMask: [.utilityWindow,.closable,.resizable,.titled], backing: .buffered, defer: true)
        self.isReleasedWhenClosed = true
        self.title = "Advanced Options"
        self.contentViewController = SettingsViewController(rect: rect)
    }
    
    deinit {
        print("panel closed and deinitialised")
    }
    
}

class SettingsViewController : NSViewController{
    
    var rect:NSRect!
    
    convenience init(rect:NSRect) {
        print("initialising settings with convenience method")
        self.init(nibName: nil, bundle: nil)
        self.rect = rect
    }
    
    override func loadView() {
        self.view = NSView(frame: rect)
        self.view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        print("hello view")
        //initialise the rest of the view here
        
        createControls()
        
    }
    
    func createControls(){
     
        print("create controls")
        
        //create first label
        let rect = NSRect(x: 20, y: 342, width: 87, height: 17)
        let label = createTextLabel(rect: rect, str: "Adjust Angle")
        self.view.addSubview(label)
        
    }
    
}
