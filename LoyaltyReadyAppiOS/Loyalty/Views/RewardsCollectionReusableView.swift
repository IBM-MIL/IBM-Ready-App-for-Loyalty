/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  UICollectionReusableView used in the RewardsViewController's UICollectionView
*/
class RewardsCollectionReusableView: UICollectionReusableView {
    
    /// UIView displaying the closest station near by
    @IBOutlet weak var closestStationView: StationView!
    /// UIView displaying the cheapest station near by
    @IBOutlet weak var cheapestStationView: StationView!
    ///Imageview to rotate to simulate animation
    @IBOutlet weak var fuelGageTeal: UIImageView!
    /// UILabel showing how many points the user has
    @IBOutlet weak var pointsLabel: UILabel!
    /// UILabel showing a message about progress
    @IBOutlet weak var progressLabel: UILabel!
}
