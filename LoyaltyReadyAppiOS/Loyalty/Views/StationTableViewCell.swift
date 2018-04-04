/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/// TableViewCell representing a GasStation
class StationTableViewCell: UITableViewCell{
    /// Label for price of gas
    @IBOutlet weak var priceLabel: UILabel!
    /// Label for address of station
    @IBOutlet weak var addressLabel: UILabel!
    /// Label representing station is open or closed
    @IBOutlet weak var openLabel: UILabel!
    /// Label for distance to the station from current location
    @IBOutlet weak var distanceLabel: UILabel!
    /// Label for estimated time to station from current location
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    /// station in question
    var station: GasStation!
}
