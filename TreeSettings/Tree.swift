//
//  Tree.swift
//  TreeSettings
//
//  Created by Joss Manger on 12/3/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

//Tree model
public class Tree {
    
    var name:String?
    
    //position of tree origin (base of trunk)
    var position: CGPoint?
    
    var trunkLength = Settings.initialLength
    var trunkWidth = Settings.initialWidth
    
    var leftAngle = Settings.initialAngle
    var rightAngle:Double?
    
    public private(set) var branches = Settings.recursionLimit
    
    public var selected = false
    
    public private(set) var box:CGRect? // genius!
    
    private var colorScheme:[ColorSchemeIndex:CGColor] = Settings.forest
    
    private var segmentWidths:[ColorSchemeIndex:CGFloat]?
    
    public init(_ placeAtPoint:CGPoint?) {
        position = placeAtPoint
    }
    
    public func setBoundingBox(boundingBox:CGRect){
        box = boundingBox
    }
    
    public func getPosition()->CGPoint{
        return position!
    }
    
    public func setPosition(point:CGPoint){
        position = point
    }
    
    public func printColor(){
        print(self.colorScheme)
    }
    
    public func setAll(length:CGFloat?,segments:[ColorSchemeIndex:CGFloat]?,leftAngle:CGFloat,rightAngle:CGFloat?){
        
        if let length = length {
            trunkLength = Double(length)
        }
        
        self.leftAngle = Double(leftAngle)
        
        if let rightAngle = rightAngle{
            self.rightAngle = Double(rightAngle)
        }
        
        if let segments = segments{
            segmentWidths = segments
        }
        
    }
    
    public func getAngle()->Double{
        return leftAngle
    }
    
    public func getRightAngleIfAny()->Double?{
        return rightAngle
    }
    
    public func getColorScheme()->[ColorSchemeIndex:CGColor]{
        return colorScheme
    }
    
    public func getSegementWidths()->[ColorSchemeIndex:CGFloat]?{
        
        return segmentWidths
        
    }
    
    public func getLength()->CGFloat{
        return CGFloat(trunkLength)
    }
    
    //tweak colorscheme
    public func setColorScheme(newScheme:[ColorSchemeIndex:CGColor]){
        colorScheme = newScheme
    }
    
    public func setSchemeColor(index:ColorSchemeIndex,color: Any) throws{
        
        switch color {
        case _ where (color is NSColor):
            colorScheme[index] = (color as! NSColor).cgColor
        case _ where (CFGetTypeID(color as! CGColor) == CGColor.typeID):
            colorScheme[index] = (color as! CGColor)
        default:
            print("guess it's not a color")
            throw Errors.fail
        }
        
    }
    
}

