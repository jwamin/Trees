//
//  Settings.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

enum Scheme:Int{
    case trunk = 0
    case branches
    case tips
}

class Settings{
    
    static let initialAngle = 25.0
    static let maxAngle = 100.0
    static let minAngle = 20.0
    static let initialLength = 100.0
    static let recursionLimit = 10
    
    static let initialWidth = 7
    
    static let numberOfTrees = 2
    
    static let white = NSColor.white.cgColor
    
    static let space:[Scheme:CGColor] = [
        .trunk:NSColor.gray.cgColor,
        .branches:NSColor.blue.cgColor,
            .tips:NSColor.red.cgColor
    ]
    
    static let forest:[Scheme:CGColor] = [
        .trunk:NSColor.brown.cgColor,
        .branches:NSColor.brown.cgColor,
        .tips:NSColor.green.cgColor
    ]
    
}

struct UpdatedSettings {
    let angle:Float
    let length:Float
}


let myItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "myItem")
let branchesItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "branchesItem")
let trunkItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "trunkItem")
let settings:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "settings")
