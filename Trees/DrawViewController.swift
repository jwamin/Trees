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
    
    convenience init(rect:NSRect){
        self.init(nibName: nil, bundle: nil)
        self.rect = rect
    }
    
    
    override func loadView() {
        view = DrawView(frame: rect)
        print(rect)
        drawView = (view as! DrawView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(drawView,"hello")

        // Do view setup here.
    }
    
    override func mouseDown(with event: NSEvent) {
        print("hello!")
    }
    
    deinit {
        print(self)
    }
    
}
