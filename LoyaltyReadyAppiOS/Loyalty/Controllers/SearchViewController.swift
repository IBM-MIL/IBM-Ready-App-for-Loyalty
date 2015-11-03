
/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit


@objc protocol SearchViewControllerDelegate {
    func applyButtonPressed() -> Void
    func cancelButtonPressed() -> Void
    func getSearchBarText() -> String
    func resetSearchBarText()
}

class SearchViewController: LoyaltyUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedControlHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomSegmentedControlHolderView: UIView!
    
    var sortBySegmentedControl : MILFlatSegmentedControl!
    var filterArray : [String] = []
    var kSEARCHSORTTABLEVIEWCELLHEIGHT : CGFloat = 50
    var KSEARCHFILTERTABLEVIEWCELLHEIGHT : CGFloat = 40
    var kHEIGHTFORSECTIONHEADER : CGFloat = 40
    
    var delegate : SearchViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpTableView()
        
        self.registerNibFiles()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setUpBottomSegmentedControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    This method sets up the tableview with various properties
    */
    func setUpTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.allowsMultipleSelection = true
    }
    
    /**
    This method registers various nib files need to populate the table view with tableviewcell nibs
    */
    func registerNibFiles(){
        tableView.registerNib(UINib(nibName: "SearchFilterTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchFilterTableViewCell")
        
        tableView.registerNib(UINib(nibName: "SearchSortTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchSortTableViewCell")
    }
    
    /**
    This method sets up the segmented control on the bottom of the SearchViewController
    */
    func setUpBottomSegmentedControl(){
        if(self.bottomSegmentedControlHolderView.subviews.count == 0){
        
            let frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, self.bottomSegmentedControlHolderView.frame.size.height)
        
            let flatSegmentedControl = MILFlatSegmentedControl(frame: frame)
        
            flatSegmentedControl.setUp([NSLocalizedString("CANCEL", comment: ""), NSLocalizedString("APPLY", comment: "")], buttonSelectedColor: UIColor.purpleLoyalty(), buttonTextSelectedColor: UIColor.whiteColor(), buttonUnSelectedColor: UIColor.whiteColor(), buttonTextUnSelectedColor: UIColor.purpleLoyalty(), font: UIFont.montserratRegular(13), selectedIndex: 1, isFixed: true)
        
            flatSegmentedControl.getButtonAtIndex(1).addTarget(self, action: "applyButtonAction", forControlEvents: .TouchUpInside)
            flatSegmentedControl.getButtonAtIndex(0).addTarget(self, action: "cancelButtonAction", forControlEvents: .TouchUpInside)
        
            flatSegmentedControl.addTopSeparatorLine(UIColor.grayLightLoyalty())
        
            self.bottomSegmentedControlHolderView.addSubview(flatSegmentedControl)
        }
    }
    
    /**
    This method returns of the number of section in the tableview. It is a tableView delegate method
    
    - parameter tableView:
    
    - returns:
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    /**
    This method returns the number of rows in the section. It is a tableview delegate mthod
    
    - parameter tableView:
    - parameter section:
    
    - returns:
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }
        else{
            return Amenities().amenitiesArray.count
        }
    }
    
    
    /**
    This method returns the height for the table view cell at the specific index path
    
    - parameter tableView:
    - parameter indexPath:
    
    - returns:
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return kSEARCHSORTTABLEVIEWCELLHEIGHT
        }
        else{
           return KSEARCHFILTERTABLEVIEWCELLHEIGHT
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        // Allows separator line to take up full width
        cell.separatorInset = UIEdgeInsetsZero
        
        cell.preservesSuperviewLayoutMargins = false
        
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    /**
    This method returns a view for the section head for the specific header
    
    - parameter tableView:
    - parameter section:
    
    - returns:
    */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 37))
        view.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(37, 0, view.frame.size.width-20, view.frame.size.height))
        
        label.font = UIFont.montserratRegular(13)
        
        label.textColor = UIColor.blackLoyalty()
        
        label.center = CGPointMake(view.center.x + 5, view.center.y + 3)
        
        let sectionZeroTitle = NSLocalizedString("SORT BY", comment: "n/a")
        let sectionOneTitle = NSLocalizedString("FILTER BY", comment: "n/a")
        
        if(section == 0){
            label.text = sectionZeroTitle
        }
        else if(section == 1){
            label.text = sectionOneTitle
        }
        
        view.addSubview(label)
        
        return view
    }
    
    
    /**
    This method returns the height for the header at the specific section
    
    - parameter tableView:
    - parameter section:
    
    - returns:
    */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHEIGHTFORSECTIONHEADER
    }
    
    
    /**
    This method returns the cell for the specific indexPath

    - parameter tableView:
    - parameter indexPath:
    
    - returns:
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            return self.setUpSearchSortTableViewCell(indexPath)
        }
        else{
            return self.setUpSearchFilterTableViewCell(indexPath)
        }
    }
    
    
    /**
    This method sets up the searchSortTableViewCell for the specific indexPath
    
    - parameter indexPath:
    
    - returns:
    */
    func setUpSearchSortTableViewCell(indexPath : NSIndexPath) -> SearchSortTableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("SearchSortTableViewCell", forIndexPath: indexPath) as! SearchSortTableViewCell
        
        let frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, kSEARCHSORTTABLEVIEWCELLHEIGHT)
        
        if(sortBySegmentedControl == nil){
        
            self.sortBySegmentedControl = MILFlatSegmentedControl(frame: frame)
        
            sortBySegmentedControl.setUp([NSLocalizedString("CLOSEST", comment: ""), NSLocalizedString("CHEAPEST", comment: "")], buttonSelectedColor: UIColor.tealLoyalty(), buttonTextSelectedColor: UIColor.whiteColor(), buttonUnSelectedColor: UIColor.whiteColor(), buttonTextUnSelectedColor: UIColor.blackLoyalty(), font: UIFont.montserratRegular(13), selectedIndex: 0, isFixed: false)
        }
        
        if(cell.contentView.subviews.count == 0){
            cell.contentView.addSubview(self.sortBySegmentedControl)
        }
    
        return cell
    }
    
    
    /**
    This method sets up the searchFilterTableViewCell for the specific indexPath
    
    - parameter indexPath: the indexPath to generate the searchFilterTableViewCell for
    
    - returns: the searchFilterTableViewCell created within this method
    */
    func setUpSearchFilterTableViewCell(indexPath : NSIndexPath) -> SearchFilterTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchFilterTableViewCell", forIndexPath: indexPath) as! SearchFilterTableViewCell
        
        let amenityString = Amenities().amenitiesArray[indexPath.row]
        
        let amenityIconImageString = Amenities().amenityIconImageNameByTableViewCellTitle[amenityString]!
        
        cell.setUp(amenityIconImageString, amenityNameText: amenityString)
        
        return cell
    }
    
    
    /**
    This method determines the action taken when a tableViewCell is selected
    
    - parameter tableView:
    - parameter indexPath:
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section == 0){
            
        }
        else if(indexPath.section == 1){
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! SearchFilterTableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        }
    }
    
    
    /**
    This method determines the action taken when a tableViewCell is deselected
    
    - parameter tableView:
    - parameter indexPath: 
    */
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0){

        }
        else if(indexPath.section == 1){
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! SearchFilterTableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    
    /**
    This method returns the selected cells in the table
    
    - returns: an array of NSIndexPath representing the idnex of selected rows in the table
    */
    func getSelectedAmenitiesIndexPaths() -> [NSIndexPath]{
        
        if let selectedIndexPaths = self.tableView.indexPathsForSelectedRows {
             return selectedIndexPaths
        }
        else{
            return []
        }
    }
    
    
    
    /**
    This method resets the UI of the search view controller. As well it resets all the search queries.
    */
    func resetSearchViewController(){
        
        let selectedAmenityIndexs = self.getSelectedAmenitiesIndexPaths()
        
        for index in selectedAmenityIndexs {
            let cell = self.tableView.cellForRowAtIndexPath(index) as! SearchFilterTableViewCell
            self.tableView.deselectRowAtIndexPath(index, animated: false)
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        self.sortBySegmentedControl.selectButtonAtIndex(0)
        
        self.resetSearchBarText()
        
        self.applySortingAndFilters()
    }
    
    
    /**
    This method returns the index of the selected segmente of the sort segementedControl
    
    - returns: the index of the selected segment of the sort segmentedControl
    */
    func getSelectedSortByIndex() -> Int {
        return self.sortBySegmentedControl.selectedIndex
    }
    
    /**
    This method si called when the apply button is pressed. It will trigger the sorting and filtering of gas stations as well as tell the SearchViewControllerDelegate that the apply button was pressed so it can refresh the UI accordingly
    */
    func applyButtonAction(){
        self.applySortingAndFilters()
        self.tellDelegateApplyButtonPressed()
    }
    
    
    /**
    This method si called when the cancel button is pressed. It will tell the SearchViewControllerDelegate that the cancel button was pressed so it can refresh the UI accordingly
    */
    func cancelButtonAction(){
        self.tellDelegateCancelButtonPressed()
    }
    
    
    /**
    This method will apply the sorting and filtering of the gas stations with respect to the choices the user has selected in the UI. It informs the SearchManager to begin sorting and filtering.
    */
    func applySortingAndFilters(){
        
        let sortSelectedSegmentIndex = self.getSelectedSortByIndex()
        let selectAmenitiesIndexPaths = self.getSelectedAmenitiesIndexPaths()
        let searchBoxText : String = self.getSearchBarText()
        
        SearchManager.sharedInstance.applySortingandFilters(searchBoxText, sortType: SortType(rawValue: sortSelectedSegmentIndex)!, amenityIndexPaths: selectAmenitiesIndexPaths)
    }
    
    
    /**
    This method tells the SearchViewControllerDelegate that the apply button was pressed
    */
    func tellDelegateApplyButtonPressed(){
        if delegate != nil {
            delegate.applyButtonPressed()
        }
    }
    
    /**
    This method tells the SearchViewControllerDelegate that the apply button was pressed
    */
    func tellDelegateCancelButtonPressed(){
        if delegate != nil {
            delegate.cancelButtonPressed()
        }
    }
    
    /**
    This method gets the searchBar text from the SearchViewControllerDelegate
    
    - returns: the search bar text
    */
    func getSearchBarText() -> String{
        if(self.delegate != nil){
            return self.delegate.getSearchBarText()
        }
        else{
           return ""
        }
    }
    
    /**
    This method resets the searchBar text from the SearchViewControllerDelegate
    
    - returns: the search bar text
    */
    func resetSearchBarText(){
        if(self.delegate != nil){
            self.delegate.resetSearchBarText()
        }
    }
}
