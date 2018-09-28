//
//  DrawView.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

class DrawView: NSView {

    private var drawcount = 0
    
    var distance:CGFloat = CGFloat(Settings.initialLength)
    var limit:Int = Settings.recursionLimit
    var angleAdjust:CGFloat = CGFloat(Settings.initialAngle)
    var colorScheme = Settings.forest
    
    override func makeBackingLayer() -> CALayer {
        print("will return layer")
        return CALayer()
    }
    
    public func updateColors(index:Int){
        colorScheme[Scheme(rawValue: index)!] = NSColorPanel.shared.color.cgColor
        print(colorScheme)
        self.setNeedsDisplay(self.frame)
    }
    
    public func updateSettings(settings:UpdatedSettings?){
       
        if let settings = settings{
            angleAdjust = CGFloat(settings.angle)
            distance = CGFloat(settings.length)
        }

        self.setNeedsDisplay(self.frame)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        //self.wantsLayer = true
    }
    
    override var wantsUpdateLayer: Bool{
        return true
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDraw() {
        drawcount = 0
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        // Drawing code here.
        let context = NSGraphicsContext.current?.cgContext
        context?.fill(dirtyRect)
        context?.beginPath()
        context?.setStrokeColor(NSColor.white.cgColor)
        context?.setLineWidth(5.0)
        context?.setLineCap(.round)
 
        for i in 0...Settings.numberOfTrees{
            let fixpoint = CGPoint(x: CGFloat(i) * self.frame.midX, y: self.frame.midY-CGFloat(Settings.initialLength)*1.5)
            context?.move(to: fixpoint)
            recursiveDraw(position:fixpoint, angle: 90,distance: distance, iteration: limit)
        }
        
    }
    
    func recursiveDraw(position:CGPoint,angle:CGFloat,distance:CGFloat,iteration:Int){
        
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
        context?.setLineWidth(distance/10/3*2) // reduce the line thickness as we get further up the tree
        
        //line to new position
        path.addLine(to: newposition)
        
        //deduce colorscheme color for path
        switch iteration {
        case let trunk where (trunk == limit || trunk == limit-1):
            //bottom of tree, allmost all iterations left
            context?.setStrokeColor(colorScheme[.trunk] ?? Settings.white)
        case 1:
            //tips of the tree, only one recursions left, will exit on next call
            context?.setStrokeColor(colorScheme[.tips] ?? Settings.white)
        default:
            //set all other draws to middle color
            context?.setStrokeColor(colorScheme[.branches] ?? Settings.white)
        }
        
        //draw
        context?.beginPath()
        context?.addPath(path)
        context?.strokePath()
        
        //setup variables for next draw call, shorten new distance
        let newDistance = distance / 4 * 3
        
        //2 calls to same recursive function, adjusted angle creates mirrored divergence from originally passed position
        recursiveDraw(position: newposition, angle: angle-angleAdjust, distance: newDistance, iteration: newiteration)
        recursiveDraw(position: newposition, angle: angle+angleAdjust, distance: newDistance, iteration: newiteration)
        
    }
    
}
