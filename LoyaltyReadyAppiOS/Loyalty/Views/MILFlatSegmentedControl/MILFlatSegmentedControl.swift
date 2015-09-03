/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

@objc protocol MILFlatSegmentedControlDelegate {
    func colorPickerSelectedIndexChanged(selectedIndex : Int) -> Void
}

class MILFlatSegmentedControl: UIView {

    var buttonArray : [MILFlatSegmentedControlButton] = []
    var delegates : [MILFlatSegmentedControlDelegate] = []
    var buttonTitles : [String] = []
    var buttonSelectedColor : UIColor!
    var buttonUnSelectedColor : UIColor!
    var buttonTextSelectedColor : UIColor!
    var buttonTextUnSelectedColor : UIColor!
    var font : UIFont!
    var selectedIndex = 0
    var isFixed : Bool!
    
    /**
    This method sets up the MILFlatSegmentedControl. It also is assuming that the frame has already been set prior to this method being called.
    
    - parameter buttonTitles:              the titles of the buttons. The number of titles included determines the number of buttons created
    - parameter buttonSelectedColor:       the color of the button when it is selected
    - parameter buttonTextSelectedColor:   the color of the button text when the button is selected
    - parameter buttonUnSelectedColor:     the color of the button when it is unselected
    - parameter buttonTextUnSelectedColor: the color of the button text when the button is unselected
    - parameter font:                      the font of the button text
    - parameter selectedIndex:             the selected index that is selected by default
    - parameter isFixed:                   whether the selected button should be fixed forever
    */
    func setUp(buttonTitles : [String],buttonSelectedColor : UIColor, buttonTextSelectedColor : UIColor, buttonUnSelectedColor : UIColor, buttonTextUnSelectedColor : UIColor, font : UIFont, selectedIndex : Int, isFixed : Bool){
        
        self.buttonTitles = buttonTitles
        self.buttonSelectedColor = buttonSelectedColor
        self.buttonTextSelectedColor = buttonTextSelectedColor
        self.buttonUnSelectedColor = buttonUnSelectedColor
        self.buttonTextUnSelectedColor = buttonTextUnSelectedColor
        self.font = font
        self.selectedIndex = selectedIndex
        self.isFixed = isFixed
        
        self.backgroundColor = UIColor.clearColor()
        
        let numberOfButtons : CGFloat = CGFloat(buttonTitles.count)
        
        let buttonWidth = self.frame.size.width / numberOfButtons
        
        var currentX : CGFloat = 0
        let offset = buttonWidth
        
        for (index, _) in buttonTitles.enumerate() {
            
            let button = MILFlatSegmentedControlButton(frame:  CGRectMake(currentX, 0,  buttonWidth, self.frame.size.height))
            
            let buttonText = self.buttonTitles[index]
            
            button.setUp(index, buttonText: buttonText, selectedColor: self.buttonSelectedColor, selectedTextColor: self.buttonTextSelectedColor, unselectedColor: self.buttonUnSelectedColor, unselectedTextColor: self.buttonTextUnSelectedColor, font: self.font)
            
            button.addTarget(self, action: "buttonSelected:", forControlEvents: .TouchUpInside)
            
            if(index == selectedIndex){
                button.select()
            }
            
            self.addSubview(button)
            self.buttonArray.append(button)
            
            currentX = currentX + offset
        }
    }
    
    
    /**
    This method is called when a button is selected. It also calls the selectedIndexChanged method
    
    - parameter sender: the button that was selected
    */
    func buttonSelected(sender : MILFlatSegmentedControlButton){
        if(isFixed == false){
            
            self.buttonArray[self.selectedIndex].deSelect()
        
            sender.select()
        
            selectedIndex = sender.index
        
            self.tellDelegatesSelectedIndexChanged()
        }
    }
    
    
    /**
    This method will inform the delegates that the selected index of has changed
    */
    func tellDelegatesSelectedIndexChanged(){
        for delegate in self.delegates {
            delegate.colorPickerSelectedIndexChanged(self.selectedIndex)
        }
    }
    
    
    /**
    This method return the MILFlatSegmentedControlButton at the parameter index
    
    - parameter index: the index of the button that will be returned
    
    - returns: the returned button that was at the parameter index
    */
    func getButtonAtIndex(index : Int) -> MILFlatSegmentedControlButton {
        return self.buttonArray[index]
    }
    
    
    /**
    This method selects the button at the index parameter given
    
    - parameter index: the index of the button that should be selected
    
    */
    func selectButtonAtIndex(index : Int){
        let button = self.getButtonAtIndex(index)
        self.buttonSelected(button)
    }
    
    
    /**
    This method will add a thin line at the top the segmented control with the color from the line Color parameter
    
    - parameter lineColor: the color to make the separator line
    */
    func addTopSeparatorLine(lineColor : UIColor){
        let separatorView = UIView(frame: CGRectMake(0,0,self.frame.size.width, 1))
        separatorView.backgroundColor = lineColor
        self.addSubview(separatorView)
        self.bringSubviewToFront(separatorView)
    }


}
