//
//  Settings.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

//Color Scheme model

public enum ColorSchemeIndex:Int{
    case trunk = 0
    case branches
    case tips
}


public struct UpdatedSettings {
   public let angle:Float
   public let length:Float
   public init (angle:Float,length:Float){
        self.angle = angle
        self.length = length
    }
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
    
}

//Shared Protocols and Enums

public protocol TreeProtocol {
    func treeUpdated()
}

enum Errors:Error{
    case fail
}
