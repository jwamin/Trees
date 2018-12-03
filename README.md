#  Trees

## `CoreGraphics` fractal trees for macOS with Swift.

![Alt text](/screenshots/shot.png?raw=true "Screenshot")

### Features

*  Draw Fractal trees
* Trees selectable with left mouse button, hierarchy denotes which trees selected
* Customizable drawing parameters including:
    *  Initial trunk length
    * Trunk, branches and tip segment widths.
    *  Left and right branch angle
    * Trunk, branches and tips color
* Click to draw tree at point
* Basic printing using standard settings
* Framework encapsualted models with Playground support
* Basic playground

### TODO

* Fix UI inconsistencies
    * Advanced doesn't close if closing main window
    * normalise initial settings w/ interface builder - partial
* Persistent storage of trees with `CoreData` / `NSDocumentController`
* Customizable backgrounds
* Present settings as popover or modal
* Settings to follow main window on move - partial, 
* Scene Graph / List with delete option, bindings to advanced detail panel

### BUGS

* Introduced a bug that instantiates 'advanced' panel when window is moved or resized.

#### Frameworks Used

`Cocoa` `CoreGraphics`
