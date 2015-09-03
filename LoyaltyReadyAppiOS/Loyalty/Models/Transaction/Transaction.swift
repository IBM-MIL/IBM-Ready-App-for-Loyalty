/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  NSObject of a transaction
*/
class Transaction: NSObject {
    /// Transaction id
    var id: Int!
    /// Timestamp date of the transaction
    var timestamp: NSDate!
    /// Transaction type
    var type: String!
    /// Transaction method
    var method: String!
    /// Transaction provider
    var provider: String!
    /// Transaction total
    var total: Double!
    /// Array of TransactionItems
    var items = [TransactionItem]()
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]){
        self.init()
        id = json["id"] as! Int
        timestamp = NSDate(timeIntervalSinceReferenceDate: (json["timestamp"] as! Double) / 1000)
        type = json["type"] as! String
        method = json["method"] as! String
        provider = json["provider"] as! String
        total = json["total"] as! Double
        items = getTransactionItems(json["items"] as! [[String: AnyObject]])
        
    }
    
    /**
    Generates an array of objects based on json array
    
    - parameter jsonArray: Array of dictionaries
    
    - returns: Array of objects
    */
    private func getTransactionItems(jsonArray: [[String:AnyObject]]) -> [TransactionItem] {
        var returnTransactionItems = [TransactionItem]()
        for transactionItemJson in jsonArray{
            let transactionItem = TransactionItem(json: transactionItemJson)
            returnTransactionItems.append(transactionItem)
        }
        
        return returnTransactionItems
    }
}
