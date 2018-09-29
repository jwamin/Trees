//
//  DrawViewController.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import AppKit

class DrawViewController: NSViewController,NSToolbarDelegate,NSWindowDelegate{
    
    var settingsController:SettingsWindowController?

    var delegate:AppDelegate!
    
    var drawView:DrawView!
    
    var rect:NSRect!
    var angleSlider:NSSlider!
    var lengthSlider:NSSlider!
    var label:NSTextView!
    
    var colorIndex = 0
    
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

        
        // Do view setup here.
        drawView = DrawView(frame: NSRect(origin: .zero, size: rect.size))
        drawView.bounds.origin = .zero
        drawView.autoresizingMask = [.width,.height]
        
        view.addSubview(drawView)
        print(drawView,view.subviews)
        setupSliders()
        createToolbar()
    
        update(self)
        view.setNeedsDisplay(self.view.frame)
        drawView.setNeedsDisplay(self.view.frame)
    }
    
    func setupSliders(){
        
        //create angleSlider
        angleSlider = NSSlider(value: Settings.initialAngle, minValue: Settings.minAngle, maxValue: Settings.maxAngle, target: self, action: #selector(update(_:)))
        angleSlider.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        angleSlider.sliderType = .circular
        angleSlider.layer?.backgroundColor = NSColor.red.cgColor
        angleSlider.addObserver(self, forKeyPath: "floatValue", options: .new, context: &DrawViewController.sliderobservercontext)
        
        view.addSubview(angleSlider)
        
        label = createTextLabel(rect: angleSlider.frame, str: "90°")
        label.textColor = NSColor.white
        label.alignment = .natural
        label.autoresizingMask = [.maxYMargin,.maxXMargin]
        label.frame.origin.x = label.frame.width
        view.addSubview(label)
        
        //Create Lengthslider
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
    
    
    //KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(context == &DrawViewController.sliderobservercontext){
            update(nil)
        } else if (context == &DrawViewController.linearsliderobservercontext){
            print("value updated!!")
        }
    }
    
    
    @objc func update(_ sender:Any?){
        print("update called")
        label.string = String(Int(angleSlider.floatValue.rounded()))+"°"
        let updatedSettings = UpdatedSettings(angle:angleSlider.floatValue,length:lengthSlider.floatValue)
        drawView.updateSettings(settings: updatedSettings)
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
                angleSlider.floatValue += 0
            }
        }
    }
    
    //Deinit methods
    deinit {

        delegate = nil
        angleSlider.removeObserver(self, forKeyPath: "floatValue")
        lengthSlider.removeObserver(self, forKeyPath: "floatValue")
        self.resignFirstResponder()
        
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        print("window closing")
        delegate.windowIsOpen = false
        return true
    }
    
}

extension DrawViewController{
    
    func createToolbar(){
        
        let toolbar = NSToolbar(identifier: "windowToolbar")
        toolbar.displayMode = .iconAndLabel
        toolbar.allowsUserCustomization = true
        toolbar.allowsExtensionItems = true
        toolbar.delegate = self
        delegate.windowController.window?.toolbar = toolbar
        
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [myItem,branchesItem,trunkItem,NSToolbarItem.Identifier.flexibleSpace,settings]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
       return [myItem,branchesItem,trunkItem]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [myItem,branchesItem,trunkItem,NSToolbarItem.Identifier.flexibleSpace,settings]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        func returnColorPicker(label:String) -> NSToolbarItem{
            let colorPickerImageName = NSImage.Name("NSColorPanel")
            let image = NSImage(named: colorPickerImageName)
            let colorPicker = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.showColors)
            colorPicker.label = "\(label.capitalized) color"
            colorPicker.paletteLabel = colorPicker.label
            colorPicker.toolTip = "Set the \(label) color"
            colorPicker.isEnabled = true
            colorPicker.image = image
            colorPicker.action = #selector(presentPicker(_:))
            return colorPicker
        }
        
        switch itemIdentifier {
        case myItem:
            let colors = returnColorPicker(label: "tip")
            colors.tag = Scheme.tips.rawValue
            return colors
        case branchesItem:
            let colors = returnColorPicker(label: "branch")
            colors.tag = Scheme.branches.rawValue
            return colors
        case trunkItem:
            let colors = returnColorPicker(label: "trunk")
            colors.tag = Scheme.trunk.rawValue
            return colors
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
    
    
    @objc func presentPicker(_ sender: NSToolbarItem) {
        colorIndex = sender.tag
        print(colorIndex)
        NSColorPanel.shared.orderFront(nil)
    }
    
    @objc func changeColor(_ sender: NSColorPanel?) {
        drawView.updateColors(index: colorIndex)
    }
    
    @objc func displaySettingsPanel(_ sender: Any?) {
        
        
        if let settingsController = settingsController{

            settingsController.window?.makeKeyAndOrderFront(self)
            
        } else {

            settingsController = SettingsWindowController()
            settingsController?.loadWindow()
            settingsController!.window?.makeKeyAndOrderFront(self)
            
        }

        
    }
    

  
}
