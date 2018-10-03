//
//  Helpers.swift
//  Trees
//
//  Created by Joss Manger on 9/28/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

//UI Elements

func createTextLabel(rect:NSRect,str:String)->NSTextView{
    
    let label = NSTextView(frame: rect)
    label.string = str
    label.font = NSFont.systemFont(ofSize: 13.0, weight: NSFont.Weight.bold)
    label.layer?.borderWidth = 0.0
    label.alignment = .natural
    label.drawsBackground = false
    label.isSelectable = false
    label.isEditable = false
    
    label.autoresizingMask = [.minYMargin]
    
    return label
    
    
}

//Maths

//No need to include GLKit here...
func degToRad(deg:CGFloat)->CGFloat{
    return deg * (.pi / 180)
}

//Toolbar custom items
let myItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "myItem")
let branchesItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "branchesItem")
let trunkItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "trunkItem")
let settings:NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "settings")

let 😲 = "Leah"
