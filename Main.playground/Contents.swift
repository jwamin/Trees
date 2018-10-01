import Cocoa
import TreeSettings

//create tree object without a point of origin
let mySettings = Tree(nil)

//try setting non-color to colorscheme
do{
    try mySettings.setSchemeColor(index: .branches, color: "not a color")
    mySettings.printColor()
} catch {
    print(error)
}

//try setting NSColor to colorscheme
do{
    try mySettings.setSchemeColor(index: .branches, color: NSColor.red)
    mySettings.printColor()
} catch {
    print(error)
}

//try setting CGColor to colorscheme
do{
    try mySettings.setSchemeColor(index: .branches, color: NSColor.blue.cgColor)
    mySettings.printColor()
} catch {
    print(error)
}
