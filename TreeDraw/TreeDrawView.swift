//
//  DrawView.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa
import TreeSettings

public class TreeDrawView: NSView {

    private var drawcount = 0
    
    var distance:CGFloat = CGFloat(Settings.initialLength)
    var limit:Int = Settings.recursionLimit
    var angleAdjust:CGFloat = CGFloat(Settings.initialAngle)
    var rightAdjust:CGFloat?
    var colorScheme = Settings.forest
    
    var trees:[Tree]!
    
//    override func makeBackingLayer() -> CALayer {
//        print("will return layer")
//        return CALayer()
//    }
    
    
    public func updateColors(index:Int){
        //colorScheme[ColorSchemeIndex(rawValue: index)!] = NSColorPanel.shared.color.cgColor
        print(colorScheme)
        self.setNeedsDisplay(self.frame)
    }
    
    public func updatePositions(trees:[Tree]){
        self.trees = trees
        self.setNeedsDisplay(self.frame)
    }
    
    public func updateSettings(settings:UpdatedSettings?){
       
        if let settings = settings{
            angleAdjust = CGFloat(settings.angle)
            distance = CGFloat(settings.length)
        }

        self.setNeedsDisplay(self.frame)
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillDraw() {
        drawcount = 0
    }
    
    
    public override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)

        // Drawing code here.
        let context = NSGraphicsContext.current?.cgContext
        context?.fill(dirtyRect)
        context?.beginPath()
        context?.setStrokeColor(NSColor.white.cgColor)
        context?.setLineWidth(5.0)
        context?.setLineCap(.round)
 

        
        for tree in trees{
            colorScheme = tree.getColorScheme()
            
            angleAdjust = CGFloat(tree.getAngle())
            
            if let rightAngle = tree.getRightAngleIfAny(){
                rightAdjust = CGFloat(rightAngle)
            } else {
                rightAdjust = angleAdjust
            }
            //let fixpoint = CGPoint(x: CGFloat(i) * self.frame.midX, y: self.frame.midY-CGFloat(Settings.initialLength)*1.5)
            let position = tree.getPosition()
            context?.move(to: position)
            var boundingBox = CGRect(origin: position, size: CGSize(width: 0, height: 0))
            recursiveDraw(box:&boundingBox,tree:tree,position:position, angle: 90,distance: tree.getLength(), iteration: limit)
            
            tree.setBoundingBox(boundingBox:boundingBox)
            if(tree.selected){
                context?.setLineJoin(.round)
                context?.setLineWidth(1.0)
                context?.setStrokeColor(NSColor.red.cgColor)
                context?.stroke(boundingBox)
            }


        }
        
    }
    
    func recursiveDraw(box:inout CGRect,tree:Tree,position:CGPoint,angle:CGFloat,distance:CGFloat,iteration:Int){
        
        //this is a recursive function so execution needs to be tracked carefully
        
        if(iteration==0){
            return
        }
        
        //setup new iteration
        let newiteration = iteration - 1
        
        //track drawcount
        drawcount+=1
        
        let context = NSGraphicsContext.current?.cgContext
        //magic happens here
        
        //calculate radians angle to new point
        let rads = degToRad(deg: angle)
        
        //calculate new point with distance, angle and trigonometry functions
        let newposition = CGPoint(x: position.x + distance * cos(rads),
                                  y: position.y + distance * sin(rads))
        
        //create new, mutable path to new point
        let path = CGMutablePath()
        
        //move to start point, the passed poistion
        path.move(to: position)
        
        //set adjusted line width for path
         // reduce the line thickness as we get further up the tree
        
        //line to new position
        path.addLine(to: newposition)
        
        var width = distance / 10 / 3 * 2
        
        let segementsSet = tree.getSegementWidths()
        
        //deduce colorscheme color for path
        switch iteration {
        case let trunk where (trunk == limit || trunk == limit-1):
            //bottom of tree, allmost all iterations left
            context?.setStrokeColor(colorScheme[.trunk] ?? Settings.white)
            if let segments = segementsSet {
                width = segments[.trunk] ?? width
            }
        case 1:
            //tips of the tree, only one recursions left, will exit on next call
            context?.setStrokeColor(colorScheme[.tips] ?? Settings.white)
            if let segments = segementsSet {
                width = segments[.tips] ?? width
            }
        default:
            //set all other draws to middle color
            context?.setStrokeColor(colorScheme[.branches] ?? Settings.white)
            if let segments = segementsSet {
                width = segments[.branches] ?? width
            }
        }
        
        
        
        context?.setLineWidth(width)
        
        
        
        //draw
        context?.beginPath()
        box = box.union(path.boundingBox)
        context?.addPath(path)
        context?.strokePath()
        
        //setup variables for next draw call, shorten new distance
        let newDistance = distance / 4 * 3
        
        //2 calls to same recursive function, adjusted angle creates mirrored divergence from originally passed position
        recursiveDraw(box:&box, tree: tree,position: newposition, angle: angle-angleAdjust, distance: newDistance, iteration: newiteration)
        recursiveDraw(box:&box, tree: tree,position: newposition, angle: angle+rightAdjust!, distance: newDistance, iteration: newiteration)
        
    }
    
}
