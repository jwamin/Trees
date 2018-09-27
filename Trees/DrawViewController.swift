//
//  DrawViewController.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

class DrawViewController: NSViewController,NSToolbarDelegate {

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
        drawView = DrawView(frame: rect)
        //drawView.wantsLayer = true
        view = drawView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = NSApp.delegate as? AppDelegate
        
        createToolbar()
        setupSliders()
        print(delegate.window)
        // Do view setup here.
        print(self.becomeFirstResponder())
    }
    
    func createToolbar(){
        
        let toolbar = NSToolbar(identifier: "windowToolbar")
        toolbar.displayMode = .default
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
        
        
        lengthSlider = NSSlider(frame: NSRect(x: 0.0, y: self.view.frame.maxY-30, width: self.view.frame.width, height: 30.0))
        lengthSlider.minValue = 1.0
        lengthSlider.maxValue = 200.0
        lengthSlider.doubleValue = Settings.initialLength
        lengthSlider.sliderType = .linear
        lengthSlider.addObserver(self, forKeyPath: "floatValue", options: [.new], context: &DrawViewController.linearsliderobservercontext)
        lengthSlider.action = #selector(update(_:))
        lengthSlider.autoresizingMask = [.width,.minYMargin]
        view.addSubview(lengthSlider)
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(context == &DrawViewController.sliderobservercontext){
            print(change![.newKey])
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

extension DrawViewController{
    
    func toolbarWillAddItem(_ notification: Notification) {
        
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
        
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
       return []
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        return nil
    }
    
}
