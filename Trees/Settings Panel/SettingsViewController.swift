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
    
    var leftAngle:CGFloat = 20.0 {
        didSet{
            setAngleString()
        }
    }
    
    var rightAngle:CGFloat?{
        didSet{
            setAngleString()
        }
    }
    
    @objc dynamic var currentAngle:CGFloat = 90.0{
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
    
    @objc dynamic var currentWidth:CGFloat = 90.0{
        didSet{
            //currentAngleUpdated
            if let _ = segmentWidths{
            switch(widthSegment.selectedSegment){
            case 0:
                segmentWidths![.trunk] = currentWidth
            case 1:
                segmentWidths![.branches] = currentWidth
            case 2:
                segmentWidths![.trunk] = currentWidth
            default:
                print("waaa")
            }
            } else {
                print("no segment widths")
                updateWidth()
            }
        }
    }
    
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
    
    @objc dynamic var length:CGFloat = 0.0{
        didSet{
            setLengthString()
        }
    }
    
    
    //Label Stringss
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
    
    
    @IBOutlet weak var trunkColorWell: NSColorWell!
    @IBOutlet weak var branchColorWell: NSColorWell!
    @IBOutlet weak var tipColorWell: NSColorWell!
    
    @IBAction func trunkColor(_ sender: Any) {
        
    }
    
    @IBAction func branchColor(_ sender: Any) {
        
    }
    
    @IBAction func tipColor(_ sender: Any) {
        
    }
    
    //Actions
    @IBAction func angleSegmentChanged(_ sender: Any) {
        
        updateAngle()
        
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
    
    func teardownSegements(){
        segmentWidths = nil
    }
    
 
    

    
    @IBAction func widthSegmentChanged(_ sender: Any) {
        print("width segment changed to:\(widthSegment.selectedSegment)")
        
        updateWidth()
        
    }
    
    override func awakeFromNib() {
        print("hello from settings panel vc")
        
        //setup angle controls
        angleSegment.setSelected(true, forSegment: 0)
        updateAngle()
        setAngleString()
        
        //setup length controls
        widthSegment.setSelected(true, forSegment: widthSegment.segmentCount-1)
        
        trunkColorWell.color = NSColor(cgColor:Settings.forest[.trunk]!) ?? NSColor.white
        branchColorWell.color = NSColor(cgColor:Settings.forest[.branches]!) ?? NSColor.white
        tipColorWell.color = NSColor(cgColor:Settings.forest[.tips]!) ?? NSColor.white
        
    }
    
    func setWidthString(){
        widthString = String(Int(currentWidth.rounded()))+"pt"
    }
    
    func setAngleString(){

        angleString = String(Int(currentAngle.rounded()))+"°"
        
    }
    
    func setLengthString(){
        lengthString = String(Int(length.rounded()))+"pt"
    }
    
    
    @IBAction func generateTree(_ sender:Any){
        let tree = Tree(nil)
        tree.setAll(length: length, segments: segmentWidths, leftAngle: leftAngle, rightAngle: rightAngle)
        print(tree)
    }
    
    
}
