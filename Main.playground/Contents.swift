import Cocoa
import TreeDraw
import TreeSettings
import PlaygroundSupport

//Create View Rect
let rect = NSRect(origin: .zero, size: CGSize(width: 640, height: 480))

//Create View
let dv = TreeDrawView(frame: rect)

//create locations object
var locations:[CGPoint] = [];

//Add Tree Origin Position
locations.append(CGPoint(x: dv.bounds.midX, y: (dv.bounds.midY - CGFloat(Settings.initialLength*3/2))))

//Call View update
dv.updatePositions(positions: locations)

//Set View to current liveview
PlaygroundPage.current.liveView = dv

