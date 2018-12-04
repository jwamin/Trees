//
//  SettingsPanel.swift
//  Trees
//
//  Created by Joss Manger on 10/2/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

class SettingsPanel : NSPanel {
    
    override func awakeFromNib() {
        print("hello from panel")
        self.windowController?.showWindow(self)
        self.makeKeyAndOrderFront(self)
    }
    
    deinit {
        print("panel closed and deinitialised")
    }
    
}
