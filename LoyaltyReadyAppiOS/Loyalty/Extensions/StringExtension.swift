/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

extension String{
    var length:Int {return self.characters.count}
    
    func containsString(_ s:String) -> Bool
    {
        if(range(of: s) != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func containsString(_ s:String, compareOption: NSString.CompareOptions) -> Bool
    {
        if((range(of: s, options: compareOption)) != nil)
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
        let range = self.range(of: "@")
        if range != nil {
            let startRange: Range<String.Index> = (startIndex ..< range!.lowerBound)
            let id = substring(with: startRange)
            return id
        } else {
            return nil
        }
    }
    
    func lowercaseFirstLetterString() ->String{
        return replacingCharacters(in: startIndex..<startIndex, with: String(self[startIndex]).lowercased())
    }

}
