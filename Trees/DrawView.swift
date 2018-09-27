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
    let colorScheme = Settings.forest
    
    override func makeBackingLayer() -> CALayer {
        print("will return layer")
        return CALayer()
    }
    
    public func updateSettings(settings:UpdatedSettings){
        angleAdjust = CGFloat(settings.angle)
        distance = CGFloat(settings.length)
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
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        drawcount = 0
        // Drawing code here.
        let context = NSGraphicsContext.current?.cgContext
        context?.fill(dirtyRect)
        context?.beginPath()
        context?.setStrokeColor(NSColor.white.cgColor)
        context?.setLineWidth(5.0)
        context?.setLineCap(.round)
 
        let fromPoint = CGPoint(x: self.frame.midX, y: self.frame.midY-(distance * CGFloat(limit)))
//        context?.move(to: fromPoint)
        let topoint = CGPoint(x: self.frame.midX, y: self.frame.midY-distance*1.5)
        let fixpoint = CGPoint(x: self.frame.midX, y: self.frame.midY-CGFloat(Settings.initialLength)*1.5)
//        context?.addLine(to: topoint)
        context?.move(to: fixpoint)
        recursiveDraw(position:fixpoint, angle: 90,distance: distance, iteration: limit)

        //context?.strokePath()
        
        //print("\(drawcount) calls to draw")
    }
    
    func recursiveDraw(position:CGPoint,angle:CGFloat,distance:CGFloat,iteration:Int){
        if(iteration==0){
            return
        }
        
        drawcount+=1
        
        let context = NSGraphicsContext.current?.cgContext
        //magic happens here
        
        let rads = degToRad(deg: angle)
        
        let newposition = CGPoint(x: position.x + distance * cos(rads),
                                  y: position.y + distance * sin(rads))
        context?.beginPath()
        let path = CGMutablePath()
        path.move(to: position)
        context?.setLineWidth(distance/10/3*2) // reduce the line thickness as we get further up the tree
        path.addLine(to: newposition)
        switch iteration {
        case let trunk where (trunk == limit || trunk == limit-1):
            context?.setStrokeColor(colorScheme[.trunk] ?? Settings.white)
        case 1:
            context?.setStrokeColor(colorScheme[.tips] ?? Settings.white)
        default:
            context?.setStrokeColor(colorScheme[.branches] ?? Settings.white)
        }
        context?.addPath(path)
        context?.strokePath()
        //setup variables for next draw call
        let newiteration = iteration - 1
        let newDistance = distance / 4 * 3
        
        //2 calls to same recursive function
        recursiveDraw(position: newposition, angle: angle-angleAdjust, distance: newDistance, iteration: newiteration)
        recursiveDraw(position: newposition, angle: angle+angleAdjust, distance: newDistance, iteration: newiteration)
        
    }
    
}


func degToRad(deg:CGFloat)->CGFloat{
    return deg * (.pi / 180)
}
