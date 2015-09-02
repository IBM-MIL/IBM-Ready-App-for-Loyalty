/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class SearchFilterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var filterNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(imageString : String, amenityNameText : String){
        
        self.iconImageView.image = UIImage(named: imageString)
        self.iconImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.filterNameLabel.text = amenityNameText
        self.tintColor = UIColor.purpleLoyalty()
        self.accessoryType = UITableViewCellAccessoryType.None
        self.selectionStyle = UITableViewCellSelectionStyle.None;
    
    }

}
