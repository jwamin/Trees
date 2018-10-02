//
//  Settings.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

public enum ColorSchemeIndex:Int{
    case trunk = 0
    case branches
    case tips
}

//Tree model
public class Tree {
    
    var name:String?
    
    //position of tree origin (base of trunk)
    var position: CGPoint?
    
    var trunkLength = Settings.initialLength
    var trunkWidth = Settings.initialWidth
    
    var leftAngle = Settings.initialAngle
    var rightAngle:Int?
    
    var branches = Settings.recursionLimit
    
    private var colorScheme:[ColorSchemeIndex:CGColor] = Settings.forest
    
    private var segmentWidths:[ColorSchemeIndex:CGFloat]?
    
    public init(_ placeAtPoint:CGPoint?) {
        position = placeAtPoint
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
            self.rightAngle = Int(rightAngle)
        }
        
        if let segments = segments{
            segmentWidths = segments
        }
    
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

enum Errors:Error{
    case fail
}

//refactor all of this into a Tree object with all the relevant data

public class Settings{
    
    public static let initialAngle = 25.0
    public static let maxAngle = 100.0
    public static let minAngle = 20.0
    public static let initialLength = 100.0
    public static let recursionLimit = 10
    
    public static let initialWidth = 7
    
    public static let numberOfTrees = 2
    
    public static let white = NSColor.white.cgColor
    
    public static let space:[ColorSchemeIndex:CGColor] = [
        .trunk:NSColor.gray.cgColor,
        .branches:NSColor.blue.cgColor,
        .tips:NSColor.red.cgColor
    ]
    
    public static let forest:[ColorSchemeIndex:CGColor] = [
        .trunk:NSColor.brown.cgColor,
        .branches:NSColor.brown.cgColor,
        .tips:NSColor.green.cgColor
    ]
    
    
    // do init
    
}

public struct UpdatedSettings {
   public let angle:Float
   public let length:Float
   public init (angle:Float,length:Float){
        self.angle = angle
        self.length = length
    }
}

