/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  UICollectionViewCell used in the DealsViewController's UICollectionView
*/
class DealCollectionViewCell: UICollectionViewCell{
    
    /// UILabel showing the name of the deal
    @IBOutlet weak var nameLabel: UILabel!
    /// UILabel showing the expiration date of the deal
    @IBOutlet weak var expiresOnLabel: UILabel!
    /// UIImageView that shows if the deal is saved or not
    @IBOutlet weak var savedImageView: UIImageView!
    /// UIView that shows if the deal is saved or not
    @IBOutlet weak var dimView: UIView!
    /// UIImageView that shows the deal image
    @IBOutlet weak var dealImageView: UIImageView!
    
}
