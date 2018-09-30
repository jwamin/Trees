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
    
    //position of tree origin (base of trunk)
    var position: CGPoint?
    
    var trunkLength = Settings.initialLength
    var trunkWidth = Settings.initialWidth
    
    var leftAngle = Settings.initialAngle
    var rightAngle:Int?
    
    var branches = Settings.recursionLimit
    
    private var colorScheme:[ColorSchemeIndex:CGColor] = Settings.forest
    
    public init(_ placeAtPoint:CGPoint?) {
        position = placeAtPoint
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
            return
        }
        
        
//        if color is NSColor{
//            print("color is NSColor")
//            let castColor = color as! NSColor
//            colorScheme[index] = castColor.cgColor
//        } else if CFGetTypeID(color as! CGColor) == CGColor.typeID{
//            colorScheme[index] = (color as! CGColor)
//        } else {
//            print("pretty sure this ain't a color")
//        }

    }

}

enum Errors:Error{
    case fail
}

//refactor all of this into a Tree object with all the relevant data

class Settings{
    
    static let initialAngle = 25.0
    static let maxAngle = 100.0
    static let minAngle = 20.0
    static let initialLength = 100.0
    static let recursionLimit = 10
    
    static let initialWidth = 7
    
    static let numberOfTrees = 2
    
    static let white = NSColor.white.cgColor
    
    static let space:[ColorSchemeIndex:CGColor] = [
        .trunk:NSColor.gray.cgColor,
        .branches:NSColor.blue.cgColor,
        .tips:NSColor.red.cgColor
    ]
    
    static let forest:[ColorSchemeIndex:CGColor] = [
        .trunk:NSColor.brown.cgColor,
        .branches:NSColor.brown.cgColor,
        .tips:NSColor.green.cgColor
    ]
    
    
    // do init
    
}

struct UpdatedSettings {
    let angle:Float
    let length:Float
}

//Toolbar custom items
let myItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "myItem")
let branchesItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "branchesItem")
let trunkItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "trunkItem")
let settings:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "settings")
