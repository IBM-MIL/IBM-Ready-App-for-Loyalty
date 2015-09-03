/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

extension String{
    var length:Int {return self.characters.count}
    
    func containsString(s:String) -> Bool
    {
        if(rangeOfString(s) != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func containsString(s:String, compareOption: NSStringCompareOptions) -> Bool
    {
        if((rangeOfString(s, options: compareOption)) != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func reverse() -> String
    {
        var reverseString : String = ""
        for character in self.characters
        {
            reverseString = "\(character)\(reverseString)"
        }
        return reverseString
    }
    

    
    /**
    Returns the first part of an email address as a string (The part before the '@')
    
    - returns: Returns the user Id (sasaatho)
    */
    func getUserIdFromEmail() -> String? {
        let range = rangeOfString("@")
        if range != nil {
            let startRange: Range<String.Index> = Range<String.Index>(start: startIndex, end: range!.startIndex)
            let id = substringWithRange(startRange)
            return id
        } else {
            return nil
        }
    }
    
    func lowercaseFirstLetterString() ->String{
        return stringByReplacingCharactersInRange(startIndex...startIndex, withString: String(self[startIndex]).lowercaseString)
    }

}
