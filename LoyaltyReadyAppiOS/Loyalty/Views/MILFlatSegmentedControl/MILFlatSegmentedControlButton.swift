/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class MILFlatSegmentedControlButton: UIButton {

    
    var selectedColor : UIColor!
    var selectedTextColor : UIColor!
    var unselectedColor : UIColor!
    var unselectedTextColor : UIColor!
    var buttonText : String!
    var index : Int!
    
    
    /**
    This method will set up the MILFlatSegmentedControlButton.
    
    - parameter index:               the index the button will be assigned
    - parameter buttonText:          the text the button will have
    - parameter selectedColor:       the color the button will be when it is selected
    - parameter selectedTextColor:   the color the button text will be when the button is selected
    - parameter unselectedColor:     the color the button will be when it is unselected
    - parameter unselectedTextColor: the color the button text will be when the button is unselected
    - parameter font:                the font the button text will be
    */
    func setUp(_ index : Int, buttonText : String, selectedColor : UIColor, selectedTextColor : UIColor, unselectedColor : UIColor, unselectedTextColor : UIColor, font: UIFont){
        
        self.index = index
        self.buttonText = buttonText
        self.selectedColor = selectedColor
        self.selectedTextColor = selectedTextColor
        self.unselectedColor = unselectedColor
        self.unselectedTextColor = unselectedTextColor
        
        self.setTitle(self.buttonText, for: UIControlState())
        self.setTitle(self.buttonText, for: UIControlState.selected)
        self.setTitleColor(self.unselectedTextColor, for: UIControlState())
        self.setTitleColor(self.selectedTextColor, for: UIControlState.selected)
        self.titleLabel!.font = font
    
    }
     
    /**
    This method is called by the MILFlatSegmentedControl when the button is selected
    */
    func select(){
        self.backgroundColor = self.selectedColor
        self.isSelected = true
    }
    
    /**
    This method is called by the MILFlatSegmentedControl when a different button is selected
    */
    func deSelect(){
        self.backgroundColor = self.unselectedColor
        self.isSelected = false
    }
    
}
