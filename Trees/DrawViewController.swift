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
    
    var settingsController:SettingsWindowController?

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
        
        let initialTree = Tree(CGPoint(x: drawView.bounds.midX, y: (drawView.bounds.midY - CGFloat(Settings.initialLength*3/2))))
        trees.append(initialTree)
        drawView.updatePositions(trees: trees)
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
    
    var trees:[Tree] = []
    
    var locations:[CGPoint] = []
    
    func selectTreeAtIndex(index:Int?){
        for tree in trees{
            tree.selected = false
        }
        
        guard let index = index else {
            return
        }
        
        trees[index].selected = true
        if let available = settingsController?.window?.screen{
            setTreeForSettings()
        }
        
        drawView.updatePositions(trees: trees)
    }

    override func rightMouseDown(with event: NSEvent) {
    
            selectTreeAtIndex(index: nil)
            drawView.updatePositions(trees: trees)
        
    }
    
    override func mouseDown(with event: NSEvent) {

        
        let point = self.drawView.convert(event.locationInWindow, to: nil)
        var hit = false
        for (index,tree) in trees.enumerated(){
            if((tree.box?.contains(point))!){
                hit = true
                
                selectTreeAtIndex(index:index);
                break;
            }
            
        }
        
        if(!hit){
            let tree = Tree(point)
            trees.append(tree)
            drawView.updatePositions(trees: trees)
        }

        
        

        
        
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
        guard let settingsController = settingsController else {
            print("no window to close")
            return false
        }
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
    
    func getSelectedTree()->Tree?{
        for tree in trees{
            if tree.selected{
                return tree
            }
        }
        return nil
    }
    
    @objc func displaySettingsPanel(_ sender: Any?) {
            settingsController = SettingsWindowController(windowNibName: "Panel")
        guard let settingsController = self.settingsController else{
            print("no window")
            return
        }
            let vc = settingsController.window?.contentViewController as! SettingsViewController
            setTreeForSettings()
            vc.delegate = self
            updateAdvancedSettingsPanelPosition()

    }
    
    func setTreeForSettings(){
        guard let settingsController = settingsController else {
            print("no settings window")
            return
        }
        let vc = settingsController.window?.contentViewController as! SettingsViewController
        print(vc)
        vc.tree = getSelectedTree()
    }
    
    //set position of advanced settigns window to the right of the main window
    func updateAdvancedSettingsPanelPosition(){
        guard let settingsController = settingsController else {
            print("no settings window")
            return
        }
        var point = NSPoint(x: (self.view.window?.frame.maxX)!, y: (self.view.window?.frame.minY)!)
        point.y = point.y - ((settingsController.window!.frame.height - self.view.window!.frame.height) / 2)
        settingsController.window?.setFrameOrigin(point)
    }
  
}

extension DrawViewController : TreeProtocol {

    func treeUpdated() {
        drawView.updatePositions(trees: trees)
    }
    
}
