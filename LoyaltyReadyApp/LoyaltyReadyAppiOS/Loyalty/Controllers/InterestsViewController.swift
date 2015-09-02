/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class InterestsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollViewContentView: UIView!
    
    @IBOutlet weak var scrollViewContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewContentViewBottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var user : User!
    
    var interestsArray = [NSLocalizedString("Coffee", comment: "n/a"), NSLocalizedString("Soft Drinks", comment: "n/a"), NSLocalizedString("Energy Drinks", comment: "n/a"), NSLocalizedString("Water", comment: "n/a"), NSLocalizedString("Snacks", comment: "n/a"), NSLocalizedString("Fresh Fruit", comment: "n/a"), NSLocalizedString("Hot Food", comment: "n/a"), NSLocalizedString("Beer", comment: "n/a"), NSLocalizedString("Wine", comment: "n/a"), NSLocalizedString("Car Wash", comment: "n/a"), NSLocalizedString("Souveniers", comment: "n/a"), NSLocalizedString("Candy", comment: "n/a"), NSLocalizedString("Diesel", comment: "n/a"), NSLocalizedString("Electronics", comment: "n/a"), NSLocalizedString("Premium Fuel", comment: "n/a"), NSLocalizedString("Power Bars", comment: "n/a"), NSLocalizedString("Cosmetics", comment: "n/a"), NSLocalizedString("Toiletries", comment: "n/a"),NSLocalizedString("Healthy Food", comment: "n/a"), NSLocalizedString("First Aid", comment: "n/a"), NSLocalizedString("Maps", comment: "n/a")]
    
    var kMinimumSpacing : CGFloat = 10.0
    var kMinimumRowSpacing: CGFloat = 14.0
    var kSectionInsetHorizontalTotal: CGFloat = 4.0
    
    weak var editProfileVCReference: EditProfileViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = UserDataManager.sharedInstance.currentUser
        
        self.setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        self.updateSizesAndConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    This method sets up various properties of the collection view such as it's datasource, delegate, and allowsMultipleSelection
    */
    func setUpCollectionView(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.allowsMultipleSelection = true
    }
    
    
    /**
    This method updates the sizes and constraints of the scrollViewContentView and the collectionView to dynamically grow depending on how big the collectionView contentSize height is.
    */
    func updateSizesAndConstraints(){
        
        let oldCollectionViewHeight = self.collectionViewHeightConstraint.constant
        let newCollectionViewHeight = self.collectionView.contentSize.height
        
        self.collectionViewHeightConstraint.constant  = newCollectionViewHeight
        
        let difference = newCollectionViewHeight - oldCollectionViewHeight
        
        self.scrollViewContentViewHeightConstraint.constant = self.scrollViewContentViewHeightConstraint.constant + difference
        
        self.collectionView.reloadData()
    }
    
    
    /**
    This method returns an array of the selected interests in the collectionView
    
    - returns: an array of selected interests in the collectionView
    */
    func getSelectedInterests() -> [String]{
        
       let selectedIndexPaths =  self.collectionView.indexPathsForSelectedItems()
       var selectedInterests = [String]()
        
        for indexPath in selectedIndexPaths! {
            
            let row = indexPath.row
         
            let interest = self.interestsArray[row]
            
            selectedInterests.append(interest)
        }
        
        return selectedInterests
    }
    
    /**
    This method defines the action that is taken when the nextButton is pressed
    
    - parameter sender:
    */
    @IBAction func nextButtonAction(sender: AnyObject) {
        self.editProfileVCReference.navigateToIndex(1, fromIndex: 0, animated: true)
    }

}

extension InterestsViewController: UICollectionViewDataSource {

    /**
    This method returns the cell for the item at index path, in this case it returns an InterestCollectionViewCell
    
    - parameter collectionView:
    - parameter indexPath:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InterestCollectionViewCell", forIndexPath: indexPath) as! InterestCollectionViewCell
        
        cell.interestLabel.numberOfLines = 0
        cell.interestLabel.text = self.interestsArray[indexPath.row]
        
        // Update collectionView with interests previously selected
        // Manually call selectItemAtIndexPath or cell won't get deslected properly
        if user.interests.contains(self.interestsArray[indexPath.row]) {
            cell.setSelected()
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
        } else {
            cell.setDeselected()
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        }
        
        Utils.addShadowToView(cell)
        
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    /**
    This method returns the number of items in a section
    
    - parameter collectionView:
    - parameter section:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.interestsArray.count
    }
    
    
    /**
    This method returns the number of sections in the collectionView
    
    - parameter collectionView:
    
    - returns:
    */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
    This method defines the size for item at index path. In this case, it figures out what size an item needs to be in order for there to be 3 items in a row.
    
    - parameter collectionView:
    - parameter collectionViewLayout:
    - parameter indexPath:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let numberOfItemsInARow : CGFloat = 3
        
        let numberOfIterItemSpacesInARow : CGFloat = 2
        
        let width : CGFloat = self.collectionView.frame.size.width
        
        let totalInsetWidths : CGFloat = (numberOfIterItemSpacesInARow * kMinimumSpacing) + (numberOfItemsInARow * kSectionInsetHorizontalTotal)
        
        let cellWidth = (width - totalInsetWidths)/numberOfItemsInARow
        
        return CGSizeMake(cellWidth,cellWidth)
    }
    
    
    /**
    This method defines the size of the space between collectionViewCells
    
    - parameter collectionView:
    - parameter collectionViewLayout:
    - parameter section:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return kMinimumSpacing
    }
    
    
    /**
    This method defines the space between rows of collectionView cells
    
    - parameter collectionView:
    - parameter collectionViewLayout:
    - parameter section:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return kMinimumRowSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 2, 0, 2)
    }
    
}




extension InterestsViewController: UICollectionViewDelegate {

    /**
    This method defines the action that is taken when a cell is selected. In this case it highlights the cell by changing its background color and setting that cell to selected, in the process, doing a quick enlargement animation
    
    - parameter collectionView:
    - parameter indexPath:
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let selectedCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! InterestCollectionViewCell
        selectedCell.setSelected()
        selectedCell.addInterest()
        
        selectedCell.backgroundCellView.animateIncreaseWithBounce(4, animationDuration: 0.4, bottomMoves: true)
                
    }
    
    
    /**
    This method defines the action that is taken when a cell is deselected. In this case it unhighlights the cell by changing its background color back to default and setting the cell to unselected
    
    - parameter collectionView:
    - parameter indexPath:
    */
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! InterestCollectionViewCell
        
        selectedCell.setDeselected()
        selectedCell.removeInterest()
    }
}
    