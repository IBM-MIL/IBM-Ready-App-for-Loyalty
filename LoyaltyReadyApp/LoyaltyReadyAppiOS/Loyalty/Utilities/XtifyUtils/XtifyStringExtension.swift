/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

/**
 *  String extension manipulate strings
 */
extension String {

    /**
    Method simply strips out any html within a string, note, this method needs to be called on the main thread
    
    - parameter html: string with html formatting
    
    - returns: string with no html
    */
    func htmlToText() -> String {

        let data = self.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)
        let attrStr = try? NSAttributedString(data: data!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType ], documentAttributes: nil)
        
        return attrStr!.string
    }
}