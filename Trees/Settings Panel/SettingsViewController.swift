//
//  SettingsViewController.swift
//  Trees
//
//  Created by Joss Manger on 10/2/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa
import TreeSettings

class SettingsViewController : NSViewController{
    
    var delegate:TreeProtocol?
    
    var scheme:[ColorSchemeIndex:CGColor] = Settings.forest {
        didSet{
            generateTree(self)
        }
    }
    
    var leftAngle:CGFloat = CGFloat(Settings.initialAngle) {
        didSet{
            setAngleString()
        }
    }
    
    var rightAngle:CGFloat?{
        didSet{
            setAngleString()
        }
    }
    
    @objc dynamic var length:CGFloat = CGFloat(Settings.initialLength) {
        didSet{
            setLengthString()
        }
    }
    
    
    @objc dynamic var currentAngle:CGFloat = CGFloat(Settings.initialAngle){
        didSet{
            //currentAngleUpdated
            
            switch(angleSegment.selectedSegment){
            case 0:
                leftAngle = currentAngle
                rightAngle = currentAngle
            case 1:
                leftAngle = currentAngle
            case 2:
                rightAngle = currentAngle
            default:
                print("waaa")
            }
            
        }
    }
    
    var segmentWidths:[ColorSchemeIndex:CGFloat]? {
        didSet{
            setWidthString()
        }
    }
    
    @objc dynamic var currentWidth:CGFloat = CGFloat(Settings.initialWidth){
        didSet{
            //currentAngleUpdated
            if let _ = segmentWidths{
            switch(widthSegment.selectedSegment){
            case 0:
                segmentWidths![.trunk] = currentWidth
            case 1:
                segmentWidths![.branches] = currentWidth
            case 2:
                segmentWidths![.tips] = currentWidth
            default:
                print("waaa")
            }
            } else {
                print("no segment widths")
                updateWidth()
            }
        }
    }
    
    
    //Interface Builder
    
    //Label Strings = Bindings
    @objc dynamic var angleString:String = "90°"
    @objc dynamic var lengthString:String = "90pt"
    @objc dynamic var widthString:String = "10pt"
    
    //Angle Controls
    @IBOutlet weak var angleSlider: NSSlider!
    @IBOutlet weak var angleSegment: NSSegmentedControl!
    @IBOutlet weak var angleLabel: NSTextField!
    
    //Length Controls
    @IBOutlet weak var lengthSlider: NSSlider!
    @IBOutlet weak var lengthLabel: NSTextField!
    
    //Width Controls
    @IBOutlet weak var widthSegment: NSSegmentedControl!
    @IBOutlet weak var widthSlider: NSSlider!
    @IBOutlet weak var widthLabel: NSTextField!
    
    //Color Wells
    @IBOutlet weak var trunkColorWell: NSColorWell!
    @IBOutlet weak var branchColorWell: NSColorWell!
    @IBOutlet weak var tipColorWell: NSColorWell!
    
    //Actions
    //(Using Actions instead of bindings)
    
    @IBAction func trunkColor(_ sender: Any) {
        scheme[.trunk] = trunkColorWell.color.cgColor
    }
    
    @IBAction func branchColor(_ sender: Any) {
        scheme[.branches] = branchColorWell.color.cgColor
    }
    
    @IBAction func tipColor(_ sender: Any) {
        scheme[.tips] = tipColorWell.color.cgColor
    }
    
    
    @IBAction func angleSegmentChanged(_ sender: Any) {
        updateAngle()
    }
    
    @IBAction func widthSegmentChanged(_ sender: Any) {
        
        print("width segment changed to:\(widthSegment.selectedSegment)")
        if(widthSegment.selectedSegment == 3){
            print("setting disabled")
            widthSlider.isEnabled = false
        } else {
            widthSlider.isEnabled = true
        }
        updateWidth()
        
    }
    
    @IBAction func generateTree(_ sender:Any){
        print("updating",segmentWidths as Any)
        let tree = Tree(nil)
        tree.setAll(length: length, segments: segmentWidths, leftAngle: leftAngle, rightAngle: rightAngle)
        tree.setColorScheme(newScheme: scheme)
        delegate?.gotNewTree(tree: tree)
    }

    
    //Setup functions
    
    func setupInitialSegments(){
        
        if (segmentWidths == nil){
            print("will setup widths")
            segmentWidths = [
                .branches: CGFloat(widthSlider!.floatValue),
                .trunk: CGFloat(widthSlider!.floatValue),
                .tips: CGFloat(widthSlider!.floatValue)
            ]
        }
        
    }
    
    func setWidthString(){
        widthString = String(Int(currentWidth.rounded()))+"pt"
        generateTree(self)
    }
    
    func setAngleString(){
        
        angleString = String(Int(currentAngle.rounded()))+"°"
        generateTree(self)
    }
    
    func setLengthString(){
        lengthString = String(Int(length.rounded()))+"pt"
        generateTree(self)
    }
    
    //Update Functions
    
    func updateWidth(){
        switch(widthSegment.selectedSegment){
        case 0:
            setupInitialSegments()
            if let _ = segmentWidths{
                currentWidth = segmentWidths![.trunk]!
            }
        case 1:
            setupInitialSegments()
            if let _ = segmentWidths{
                currentWidth = segmentWidths![.branches]!
            }
        case 2:
            setupInitialSegments()
            if let _ = segmentWidths{
                currentWidth = segmentWidths![.tips]!
            }
        default:
            teardownSegements()
        }
        setWidthString()
    }
    
    func updateAngle(){
        switch(angleSegment.selectedSegment){
        case 0:
            currentAngle = leftAngle
        case 1:
            currentAngle = leftAngle
        case 2:
            if (rightAngle == nil){
                rightAngle = leftAngle
            }
            if let rightangle = rightAngle{
                currentAngle = rightangle
            }
        default:
            print("waaa")
        }
    }
    
    
    
    //Reset Functions
    
    func teardownSegements(){
        segmentWidths = nil
    }

    
    //Lifecycle
    
    override func awakeFromNib() {
        print("hello from settings panel vc")
        self.view.window?.windowController?.contentViewController = self
        //setup angle controls
        angleSegment.setSelected(true, forSegment: 0)
        updateAngle()
        setAngleString()
        
        //setup length controls
        widthSegment.setSelected(true, forSegment: widthSegment.segmentCount-1)
        widthSlider.isEnabled = false
        
        trunkColorWell.color = NSColor(cgColor:scheme[.trunk]!)!
        branchColorWell.color = NSColor(cgColor:scheme[.branches]!)!
        tipColorWell.color = NSColor(cgColor:scheme[.tips]!)!
        
    }
    
    
}


