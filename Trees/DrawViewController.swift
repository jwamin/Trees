//
//  DrawViewController.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import AppKit
import TreeDraw
import TreeSettings

class DrawViewController: NSViewController,NSWindowDelegate{
    
    lazy var settingsController:SettingsWindowController = SettingsWindowController(windowNibName: "Panel")

    var delegate:AppDelegate!
    
    var drawView:TreeDrawView!
    
    var rect:NSRect!
    
    convenience init(rect:NSRect){
        self.init(nibName: nil, bundle: nil)
        self.rect = rect
    }
    
    // MARK: View Load methods
    
    override func loadView() {
        self.view = NSView(frame: rect)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //get delegate
        delegate = NSApp.delegate as? AppDelegate

        // Do view setup here.
        drawView = TreeDrawView(frame: NSRect(origin: .zero, size: rect.size))
        drawView.bounds.origin = .zero
        drawView.autoresizingMask = [.width,.height]
        view.addSubview(drawView)
    
        createToolbar()
        
        locations.append(CGPoint(x: drawView.bounds.midX, y: (drawView.bounds.midY - CGFloat(Settings.initialLength*3/2))))
        drawView.updatePositions(positions: locations)
        updateTrackingArea()
    }
   
    //View Printing
    @objc @IBAction func printDocument(_ sender: AnyObject) {
        
        
            //Set basic print settings (fit to single page)
            NSPrintInfo.shared.isVerticallyCentered = true
            NSPrintInfo.shared.isHorizontallyCentered = true
            NSPrintInfo.shared.verticalPagination = .fit
            NSPrintInfo.shared.horizontalPagination = .fit
            
       DispatchQueue.main.async {
            //Run print operation
            let po = NSPrintOperation.init(view: self.drawView)
            po.run()
        }
        
    }

    
    func updateTrackingArea(){
        
        self.drawView.addTrackingRect(drawView.frame, owner: self, userData: nil, assumeInside: false)
        
    }
    
    var locations:[CGPoint] = []
    
    override func mouseDown(with event: NSEvent) {
       let point = self.drawView.convert(event.locationInWindow, to: nil)
        locations.append(point)
        drawView.updatePositions(positions: self.locations)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        NSCursor.crosshair.set()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        NSCursor.arrow.set()
    }
    
    //Deinit methods
    deinit {

        delegate = nil
        self.resignFirstResponder()
        
    }
    
    //Juddery
    func windowWillMove(_ notification: Notification) {
        updateAdvancedSettingsPanelPosition()
    }
    
    func windowDidMove(_ notification: Notification) {
        updateAdvancedSettingsPanelPosition()
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        
        print("window closing")
        delegate.windowIsOpen = false
        settingsController.close()
        return true
        
    }
    
}

// Toolbar

extension DrawViewController : NSToolbarDelegate{
    
    func createToolbar(){
        
        let toolbar = NSToolbar(identifier: "windowToolbar")
        toolbar.displayMode = .iconAndLabel
        toolbar.allowsUserCustomization = true
        toolbar.allowsExtensionItems = true
        toolbar.delegate = self
        delegate.windowController.window?.toolbar = toolbar
        
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier.flexibleSpace,NSToolbarItem.Identifier.print,settings]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
       return []
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier.flexibleSpace,NSToolbarItem.Identifier.print,settings]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        switch itemIdentifier {
        case NSToolbarItem.Identifier.print:
            let print = NSToolbarItem(itemIdentifier: itemIdentifier)
            print.isEnabled = true
            return print
        case settings:
            let settings = NSToolbarItem(itemIdentifier: itemIdentifier)
            settings.label = "Advanced"
            settings.isEnabled = true
            settings.toolTip = "Adjust advanced settings"
            settings.target = self
            settings.action = #selector(displaySettingsPanel(_:))
            settings.image = NSImage(named: NSImage.Name("NSAdvanced"))
            return settings
        default:
            return nil
        }
        
    }
    
    
    @objc func displaySettingsPanel(_ sender: Any?) {
        
            let vc = settingsController.window?.contentViewController as! SettingsViewController
            print(vc)
            vc.delegate = self
            updateAdvancedSettingsPanelPosition()

    }
    
    //set position of advanced settigns window to the right of the main window
    func updateAdvancedSettingsPanelPosition(){
        var point = NSPoint(x: (self.view.window?.frame.maxX)!, y: (self.view.window?.frame.minY)!)
        point.y = point.y - ((settingsController.window!.frame.height - self.view.window!.frame.height) / 2)
        settingsController.window?.setFrameOrigin(point)
    }
  
}

extension DrawViewController : TreeProtocol {
    
    func gotNewTree(tree: Tree) {
        drawView.updateTree(newTree:tree)
    }
    
}
