/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation
/**
 * This class represents an Xtify Tag
 **/
open class XLTag {
    fileprivate var tagName : String;
    fileprivate var isSet : Bool;
    
    init(tagName : String, isSet : Bool) {
        self.tagName = tagName;
        self.isSet = isSet;
    }
    
    open func getTagName() -> String {
        return tagName;
    }
    
    open func setTagName(_ tagName : String) {
        self.tagName = tagName;
    }
    
    open func getIsSet() -> Bool {
        return isSet;
    }
    
    open func setIsSet(_ isSet : Bool) {
        self.isSet = isSet;
    }
}
