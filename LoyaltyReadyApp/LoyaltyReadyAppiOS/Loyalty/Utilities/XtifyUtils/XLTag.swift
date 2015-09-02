/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation
/**
 * This class represents an Xtify Tag
 **/
public class XLTag {
    private var tagName : String;
    private var isSet : Bool;
    
    init(tagName : String, isSet : Bool) {
        self.tagName = tagName;
        self.isSet = isSet;
    }
    
    public func getTagName() -> String {
        return tagName;
    }
    
    public func setTagName(tagName : String) {
        self.tagName = tagName;
    }
    
    public func getIsSet() -> Bool {
        return isSet;
    }
    
    public func setIsSet(isSet : Bool) {
        self.isSet = isSet;
    }
}