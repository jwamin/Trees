//
//  DrawViewController.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

class DrawViewController: NSViewController,NSToolbarDelegate,NSWindowDelegate{
    

    var delegate:AppDelegate!
    
    var drawView:DrawView!
    
    var rect:NSRect!
    var angleSlider:NSSlider!
    var lengthSlider:NSSlider!
    
    private static var sliderobservercontext = 0
    private static var linearsliderobservercontext = 1
    
    convenience init(rect:NSRect){
        self.init(nibName: nil, bundle: nil)
        self.rect = rect
    }
    
    override func keyDown(with event: NSEvent) {
        print("hkeydown")
    }
    
    // MARK: View Load methods
    
    override func loadView() {
        self.view = NSView(frame: rect)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = NSApp.delegate as? AppDelegate

        drawView = DrawView(frame: NSRect(origin: .zero, size: rect.size))
        //drawView.bounds.origin = .zero
        //drawView.wantsLayer = true
        drawView.autoresizingMask = [.width,.height]
        view.addSubview(drawView)
        
        setupSliders()
        createToolbar()
        
        print(delegate.window)
        // Do view setup here.
        print(self.becomeFirstResponder())
    }
    
    func createToolbar(){
        
        let toolbar = NSToolbar(identifier: "windowToolbar")
        toolbar.displayMode = .iconAndLabel
        toolbar.allowsUserCustomization = true
        toolbar.delegate = self
        delegate.window.toolbar = toolbar
        
    }
    
    func setupSliders(){
        
        angleSlider = NSSlider(value: Settings.initialAngle, minValue: Settings.minAngle, maxValue: Settings.maxAngle, target: self, action: #selector(update(_:)))
        angleSlider.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        angleSlider.sliderType = .circular
        angleSlider.layer?.backgroundColor = NSColor.red.cgColor
        angleSlider.addObserver(self, forKeyPath: "floatValue", options: .new, context: &DrawViewController.sliderobservercontext)
        
        view.addSubview(angleSlider)
        
        
        lengthSlider = NSSlider(frame: NSRect(x: 0.0, y: rect.midY-30, width: rect.width, height: 30.0))
        lengthSlider.minValue = 1.0
        lengthSlider.maxValue = 200.0
        lengthSlider.layer?.backgroundColor = NSColor.red.cgColor
        lengthSlider.doubleValue = Settings.initialLength
        lengthSlider.sliderType = .linear
        lengthSlider.addObserver(self, forKeyPath: "floatValue", options: [.new], context: &DrawViewController.linearsliderobservercontext)
        lengthSlider.action = #selector(update(_:))
        lengthSlider.autoresizingMask = [.width,.minYMargin]
        print(lengthSlider.frame)
        view.addSubview(lengthSlider)
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(context == &DrawViewController.sliderobservercontext){
            update(nil)
        } else if (context == &DrawViewController.linearsliderobservercontext){
            print("value updated!!")
        }
    }
    

    
    // MARK: Scroll wheel
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        if(angleSlider.hitTest(event.locationInWindow) != nil){
            switch event.deltaY{
            case let dy where dy > 0:
                print("up")
                angleSlider.floatValue += 1.0
            case let dy where dy < 0:
                print("down")
                angleSlider.floatValue -= 1.0
            default:
                print("whaaaa?")
        }
        }
    }
    
    @objc func update(_ sender:Any?){
        let updatedSettings = UpdatedSettings(angle:angleSlider.floatValue,length:lengthSlider.floatValue)
       drawView.updateSettings(settings: updatedSettings)
    }
    
    deinit {
        print(self)
        angleSlider.removeObserver(self, forKeyPath: "floatValue")
    }
    
}

//let myItem:NSToolbarItem.Identifier = NSToolbarItemIde

extension DrawViewController{
    
    func toolbarWillAddItem(_ notification: Notification) {
        
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
        
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier.showColors]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
       return []
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier.showColors]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case NSToolbarItem.Identifier.showColors:
            let colors = NSToolbarItem(itemIdentifier: itemIdentifier)
            colors.label = "Tip color"
            colors.toolTip = "Set the tree tip color"
            NSColorPanel.shared.setAction(#selector(changeColor(_:)))
            return colors
        default:
            return nil
        }
    }
    
    
    @objc func changeColor(_ sender: NSColorPanel?) {
        drawView.updateSettings(settings: nil)
    }
    
  
}
