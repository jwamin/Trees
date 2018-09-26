//
//  DrawViewController.swift
//  Trees
//
//  Created by Joss Manger on 9/26/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

class DrawViewController: NSViewController {

    var drawView:DrawView!
    var rect:NSRect!
    var angleSlider:NSSlider!
    
    private static var sliderobservercontext = 0
    
    convenience init(rect:NSRect){
        self.init(nibName: nil, bundle: nil)
        self.rect = rect
    }
    
    // MARK: View Load methods
    
    override func loadView() {
        view = DrawView(frame: rect)
        print(rect)
        drawView = (view as! DrawView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        angleSlider = NSSlider(value: 90, minValue: 25, maxValue: 100, target: self, action: #selector(update(_:)))
        angleSlider.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        angleSlider.sliderType = .circular
        angleSlider.layer?.backgroundColor = NSColor.red.cgColor
        
        angleSlider.addObserver(self, forKeyPath: "floatValue", options: .new, context: &DrawViewController.sliderobservercontext)
        
        view.addSubview(angleSlider)
        
        // Do view setup here.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(context == &DrawViewController.sliderobservercontext){
            print(change![.newKey])
            update(nil)
        }
    }
    
    
    // MARK: Scroll wheel
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        if(angleSlider.hitTest(event.locationInWindow) != nil){
            switch event.deltaY{
            case let dy where dy > 0:
                print("up")
                angleSlider.floatValue += 1.0
            case let dy where dy < 0:
                print("down")
                angleSlider.floatValue -= 1.0
            default:
                print("whaaaa?")
        }
        }
    }
    
    @objc func update(_ sender:Any?){
        print(angleSlider.floatValue)
        drawView.updateAngle(angleFloat:angleSlider.floatValue)
    }
    
    
    deinit {
        print(self)
        angleSlider.removeObserver(self, forKeyPath: "floatValue")
    }
    
}
