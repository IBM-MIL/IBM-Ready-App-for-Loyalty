/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import MapKit
import CoreLocation
import OpenWhisk

class StationsViewController: LoyaltyUIViewController {
    
    /**
    Defines state of collection view.
    
    - Hidden:  Collection view is hidden.
    - Compact: Collection view shows one cell - information for selected station.
    - Detail:  Collection view shows multiple, detailed cells for selected station including deals.
    */
    fileprivate enum CollectionViewState{
        case hidden, compact, detail
    }
    /// Phone number utility class
    let phoneUtil = NBPhoneNumberUtil.sharedInstance()
    /// Collection view for stations and their details
    @IBOutlet weak var stationsCollectionView: UICollectionView!
    /// Placeholder button for future searches
    @IBOutlet weak var searchButton: UIButton!
    /// Button that toggles between map and list view
    @IBOutlet weak var mapButton: UIButton!
    /// X button to animate from .Detail mode to .Compact mode
    @IBOutlet weak var cancelDetailButton: UIButton!
    /// Map that displays locations of gas stations
    @IBOutlet weak var mapView: MKMapView!
    /// Tableview to contain list of gasStations
    @IBOutlet weak var tableView: UITableView!
    /// Overlay over the mapView when in .Detail mode to dismiss detail and send to .Compact when tapped
    @IBOutlet weak var mapOverlayButton: UIButton!
    /// Autolayout constraint for collectionView to animate height changes
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    /// Autolayout constraint for tableView to animate showing and hiding
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    /// Autolayout constraint for mapView to change size
    @IBOutlet weak var verticalSpaceBelowMap: NSLayoutConstraint!
    
    /// View to show on map when no results from filters
    @IBOutlet weak var noResultsView: UIView!
    
    /// Array of gas stations
    var stationDataArray: [GasStation] = []
    /// GasStation the user has selected currently
    var currentStation: GasStation!
    /// Label at the top of the map view
    @IBOutlet weak var mapHeaderLabel: UILabel!
    /// StationsCollectionReusableView for the header of the collection view containing gas station details
    var reusableViewHeader: StationsCollectionReusableView!
    /// Array of deals shown in the UICollectionView
    var deals = [Deal]()
    /// User's current location
    var userLocation: CLLocationCoordinate2D!
    /// Animation time for collection view animating up and down
    
    fileprivate let kAnimationDuration: TimeInterval = 0.3
    
    @IBOutlet weak var searchViewControllerHolderViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchViewControllerHolderView: UIView!
    
    @IBOutlet weak var searchViewControllerContainerView: UIView!
    
    @IBOutlet weak var searchViewControllerContainerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchViewControllerContainerViewVerticalSpaceConstraint: NSLayoutConstraint!
    
    var searchViewController : SearchViewController!
    
    @IBOutlet weak var navigationBar: UIView!
    
    var searchBar : UISearchBar!
    
    var didSetUpSearchBar = false
    
    var initialSortByDistance = false
    
    var internetWasNotAvailableOnFirstViewDidLoad = false
    
    
    var isSortingRefresh = false
    
    let logger : OCLogger = OCLogger.getInstanceWithPackage("Loyalty");
    
    /// Defines state of collection view and takes care of animations on setting
    fileprivate var _currentCollectionViewState: CollectionViewState = .hidden
    fileprivate var currentCollectionViewState: CollectionViewState{
        get {
            return self._currentCollectionViewState
        }
        set {
            self._currentCollectionViewState = newValue
            self.resetCollectionViewHeight()
        }
    }
    
    /// Currently selected MapPin
    fileprivate var selectedPin: MapPin?
    /// Height of StationTableViewCells
    fileprivate let kStationCellHeight: CGFloat = 100.0
    /// Height of amenities
    fileprivate let kAmenitiesCellHeight: CGFloat = 80.0
    /// Height of extra details
    fileprivate let kExtraDetailCellHeight: CGFloat = 150.0
    /// Height of deals
    fileprivate let kDealsCellHeight: CGFloat = 100.0
    /// Initial height of map view
    var kInitialMapHeight: CGFloat!
    
    var stationByLatLongDictionary : [String : GasStation]!
    var didSetUp = false
    
    //priya
    
    var geotifications: [Geotification] = []
    
    
    // Change to your whisk app key and secret.
    let WhiskAppKey = "15a25a42-ba66-4388-a210-716b2a7fba10"
    let WhiskAppSecret = "PsMODRjgtgQ2nIHu8XA2lwPFIn8bDIAWbMy58Q8sPCcRgroIXU6tSsr7kq4NbO13"

    
    // the URL for Whisk backend
    let baseUrl: String? = "https://openwhisk.ng.bluemix.net"
    
    // The action to invoke.
    // Choice: specify components
    //let MyNamespace: String = "whisk.system"
    let MyPackage: String? = "com.ibm.mil.readyapps"
    let MyWhiskAction: String = "sendDeals"
    
    var MyActionParameters: [String:AnyObject]? = nil
    let HasResult: Bool = true // true if the action returns a result
    var session: URLSession!
    
    var locationManager = CLLocationManager()
    var currentLocation: [CLLocation]?

    
    
    
    //priya
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //geofencing
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        // Setup accessibility labels for testing
        self.tableView.accessibilityLabel = NSLocalizedString("tableview", comment: "")
        self.stationsCollectionView.accessibilityLabel = NSLocalizedString("listview", comment: "")
        self.mapView.accessibilityLabel = NSLocalizedString("mapview", comment: "")
        self.mapButton.accessibilityLabel = NSLocalizedString("togglebutton", comment: "")
        
        // Initialize view heights and sizing
        self.tableViewHeight.constant = 0.0
        let noStationsView = NoStationsView.instanceFromNib()
        noStationsView.delegate = self
        self.tableView.backgroundView = noStationsView
        self.mapOverlayButton.isHidden = true
        
        // Load initial gas station data
        self.stationDataArray = UserDataManager.sharedInstance.currentUser.gasStations
        self.setUpStationByLatLongDictionary()
        userLocation = UserDataManager.sharedInstance.currentUser.coordinate
        self.toggleNoResultsView()
        
        self.kInitialMapHeight = self.mapView.frame.height
        self.searchViewControllerContainerViewVerticalSpaceConstraint.constant = UIScreen.main.bounds.height
        self.collectionViewHeight.constant = 0.0
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Setup delegates and observers
        SearchManager.sharedInstance.delegates.append(self)
        NotificationCenter.default.addObserver(self, selector: #selector(StationsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StationsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        

        
        
 
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //checkInternetConnection()
        // Load initial gas station data
        self.setUpStationDataArrayAndLatLongDictionary()
        
        self.checkInternetConnection()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // change 2 to desired number of seconds
            // Your code with delay
            self.setupMap(self.userLocation, latDelta: 0.02, longDelta: 0.02)
            self.enableGeoFencing()
        }
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.mapView.delegate = self
        self.tableView.isHidden = false
        tableView.layoutMargins = UIEdgeInsets.zero
        
        //self.setUpSearchViewController()
        setUpSearchBar()
        
        
        
        //sort gas station by distance by default
        //self.sortGasStationsByDistanceOnFirstLoad()
        
        self.checkIfUserHasSelectedClosestOrCheapestFromRewardsTab()
        isSortingRefresh = true
        self.searchViewController.applySortingAndFilters()
        
    }
    
    /**
    Method to check if user has internet connection
    */
    func checkInternetConnection(){
        if !Utils.checkInternetConnection(){
            self.internetWasNotAvailableOnFirstViewDidLoad = true
            MILLoadViewManager.sharedInstance.hide()
            MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), view: self.view, underView: self.navigationBar, callback: checkInternetConnection)
            self.searchButton.isUserInteractionEnabled = false
        } else {
            if (internetWasNotAvailableOnFirstViewDidLoad) {
                if (self.stationDataArray.isEmpty) {
                    // Load initial gas station data
                    self.stationDataArray = UserDataManager.sharedInstance.currentUser.gasStations
                    self.searchViewController.resetSearchViewController()
                    self.setUpStationByLatLongDictionary()
                    self.setUpStationDataArrayAndLatLongDictionary()
                }
                MILAlertViewManager.sharedInstance.hide() //hide alert if shown
                self.toggleNoResultsView()
                self.searchButton.isUserInteractionEnabled = true
                userLocation = UserDataManager.sharedInstance.currentUser.coordinate
                //userLocation = CLLocationCoordinate2D(latitude: 30.391813, longitude: -97.721223)
                self.populateMap(true)
                self.internetWasNotAvailableOnFirstViewDidLoad = false
                self.searchViewController.applySortingAndFilters()
            }
        }
    }
    
    
    /**
    This method replaces the stationDataArray with new and correct instances of the gas stations. After, it updates the stationByLatLongDictionary with these new stations. This method is mostly in place as a work around to fix a bug we were running into where the gas station instances were changing randomly, thus causing their deal instances to change thus causing a bug where we couldn't save deals.
    */
    func setUpStationDataArrayAndLatLongDictionary(){
        
        var tempArray = UserDataManager.sharedInstance.currentUser.gasStations
        for station in UserDataManager.sharedInstance.currentUser.gasStations {
            var contains = false
            for gs in stationDataArray{
                contains = contains || gs == station
            }
            if !contains {
                for (index, s) in tempArray.enumerated() {
                    if s == station {
                        tempArray.remove(at: index)
                    }
                }
            }
        }
        
        self.stationDataArray = tempArray
        self.setUpStationByLatLongDictionary()
    }
    
    
    /**
    This method checks to see if the user has selected a closest or cheapest station from the rewards view controller. If a user has selected a station from the rewards view controller, then this method will hide the list view, hide the search view controller and search bar, it will reset the searchViewController (including the SearchManager). Next it will set up the stationDataArray and latLongDictionary, populate the map with this new data, and then resort the stations by distance. Next it will select the correct pin that corresponds to the station the user pressed, thus causing the station detail modal to pop up.
    */
    func checkIfUserHasSelectedClosestOrCheapestFromRewardsTab(){
        
        // Check if user did in fact select the closest or cheapest station from the rewards tab
        if UserDataManager.sharedInstance.selectedStation != nil{
            self.hideListView()
            self.hideSearchViewControllerAndSearchBar()
            
            //Reset the search view controller and the current sorting and filters back to default
            self.searchViewController.resetSearchViewController()
            self.setUpStationDataArrayAndLatLongDictionary()
            self.populateMap(true)
            self.searchViewController.applySortingAndFilters()
 
            //Search through each annotation on the pin and check if any of these annotations have the same annotation as the selected station. If it does, then select that pin innotation
            currentStation = UserDataManager.sharedInstance.selectedStation
            let annotations = mapView.annotations
                for annotation in annotations {
                    if UserDataManager.sharedInstance.selectedStation != nil{
                        if annotation.coordinate.latitude == UserDataManager.sharedInstance.selectedStation.coordinate.latitude && annotation.coordinate.longitude == UserDataManager.sharedInstance.selectedStation.coordinate.longitude {
                            self.stationsCollectionView.reloadData()
                            mapView.selectAnnotation(annotation, animated: true)
                            UserDataManager.sharedInstance.selectedStation = nil
                        }
                    }
                }
            
        }
        
        //Refresh Station detail modal view
        self.stationsCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSearch") {
            let rbStoryboardLink = segue.destination as! RBStoryboardLink
            
            self.searchViewController = rbStoryboardLink.scene as! SearchViewController
            self.searchViewController.delegate = self
        }
    }
    
    
    /**
    This method sets up a dictionary where the key is a concatenation between a stations lat and long coordinates and the value is the gas station. This method is needed to determine which gas station pin was pressed on the map to have the station detail view display the correct information for the selected gas station.
    */
    func setUpStationByLatLongDictionary(){
        
        self.stationByLatLongDictionary = [String : GasStation]()
        
        for station in self.stationDataArray {
            let latLongString : String = "\(station.coordinate.latitude)\(station.coordinate.longitude)"
            self.stationByLatLongDictionary[latLongString] = station
        }
    }
    
    /**
    Sets up mapView and centers it at the user's location (currently faked). Determines radius around user.
    */
    func setupMap(_ coordinates: CLLocationCoordinate2D, latDelta: CLLocationDegrees, longDelta: CLLocationDegrees){
        
        var region = MKCoordinateRegion()
        var span = MKCoordinateSpan()
        
        span.latitudeDelta = latDelta
        span.longitudeDelta = longDelta
        
        region.span = span
        region.center = coordinates
        
        mapView.setRegion(region, animated: true)
    }
    
    
    /**
    Removes all existing pins (optionally) and Populates map with pins centered on the coordinates of the gas stations.
    
    - parameter removeExisting: boolean of whether or not to first remove existing pins before repopulating map with pins
    */
    func populateMap(_ removeExisting: Bool){
        
        //remove pins?
        if (removeExisting == true) {
            mapView.removeAnnotations(mapView.annotations)
            
            
        }
        
        
        //now show gas station pins
        for (_, station) in stationDataArray.enumerated(){
            
            let latLongString : String = "\(station.coordinate.latitude)\(station.coordinate.longitude)"
            
            let pin = MapPin(coordinate: station.coordinate,
                title: station.name,
                subtitle: station.address,
                tag: latLongString,
                station: station)
            if (self.selectedPin != nil) { //if selectedpin exists, add pin only if it isn't the same as selectedpin
                if (pin != self.selectedPin!) {
                    self.mapView.addAnnotation(pin)
                }
            } else { //add pin if selectedpin doesn't exist
                self.mapView.addAnnotation(pin)
            }
            
        }
    }
    
    
    /**
    Method called when X dismiss button is pressed on station detail view
    
    - parameter sender: object sending the message
    */
    @IBAction func dismissDetailPressed(_ sender: AnyObject) {
        self.currentCollectionViewState = .compact
    }
    
    /**
    Toggles between displaying the gas station list and map with animation.
    
    - parameter sender:
    */
    @IBAction func mapButtonPressed(_ sender: AnyObject) {
        self.currentCollectionViewState = .hidden //hide everything currently shown
        if self.tableViewHeight.constant == self.mapView.frame.height { //if full screen, hide
            hideListView()
        } else { // if hidden, bring to full screen
            showListView()
        }
    }
    
    /**
    Method to animate showing the list of filtered gas stations
    */
    func showListView() {
        self.mapButton.setImage(UIImage(named: "map"), for: UIControlState())
        UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
            self.tableViewHeight.constant = self.mapView.frame.height
            self.tableView.layoutIfNeeded()
            }, completion:{
                (value: Bool) in
                self.tableView.reloadData()
        })
    }
    
    /**
    Method to animate hiding the list of filtered gas stations
    */
    func hideListView() {
        self.mapButton.setImage(UIImage(named: "list"), for: UIControlState())
        UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
            self.tableViewHeight.constant = 0.0
            self.tableView.layoutIfNeeded()
            }, completion:{
                (value: Bool) in
                self.tableView.reloadData()
        })
    }
    
    /**
    Method called when user taps directions button in station detail to open Maps application
    
    - parameter sender: object sending message
    */
    @IBAction func tappedDirections(_ sender: AnyObject) {
        //open station in Maps App
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: self.mapView.region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: self.mapView.region.span)
        ]
        let placemark = MKPlacemark(coordinate: self.currentStation.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(self.currentStation.name)"
        mapItem.openInMaps(launchOptions: options)
    }
    
    /**
    Method called when user taps call phone number in station detail to open Phone application
    
    - parameter sender: object sending message
    */
    @IBAction func tappedCall(_ sender: AnyObject) {
        if let url = URL(string: "tel://\(self.currentStation.phoneNumber)") {
            UIApplication.shared.openURL(url)
        }
    }
    
    /**
    Method called when user taps website in station detail to open Safari application
    
    - parameter sender: object sending message
    */
    @IBAction func tappedWebsite(_ sender: AnyObject) {
        if self.currentStation.website.range(of: "http://") != nil { //if url contains http:// already, open it
            UIApplication.shared.openURL(URL(string: "\(self.currentStation.website)")!)
        } else { //otherwise, append http://
            UIApplication.shared.openURL(URL(string: "http://\(self.currentStation.website)")!)
        }
    }
    
    /**
    Method called when user taps map while in .Detail view to transition to .Compact
    
    - parameter sender: object sending message
    */
    @IBAction func tappedMapOverlay(_ sender: AnyObject) {
        self.currentCollectionViewState = .compact
    }
    
    /**
    Method called to shrink/expand station detail when station banner is tapped
    
    - parameter sender: object sending message
    */
    @IBAction func tappedStationBanner(_ sender: AnyObject) {
        if (self.currentCollectionViewState == .compact) {
            self.currentCollectionViewState = .detail
        } else {
            self.currentCollectionViewState = .compact
        }
    }
    /**
    Sets and animates constraint change of collection view on state change.
    */
    func resetCollectionViewHeight(){
        
        switch currentCollectionViewState{
        case .hidden:
            self.stationsCollectionView.reloadData() //reset colors and values
            if let _ = self.selectedPin?.coordinate {
                self.setupMap(self.mapView.region.center, latDelta: self.mapView.region.span.latitudeDelta, longDelta: self.mapView.region.span.longitudeDelta)
            }
            //deselect any selected annotations
            if (self.selectedPin != nil) {
                self.mapView.deselectAnnotation(self.selectedPin, animated: false)
            }
            UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
                self.mapHeaderLabel.text = NSLocalizedString("STATIONS", comment: "")
                self.mapButton.isHidden = false
                self.searchButton.isHidden = false
                self.cancelDetailButton.isHidden = true
                self.mapOverlayButton.isHidden = true
                self.collectionViewHeight.constant = 0
                self.stationsCollectionView.setContentOffset(CGPoint.zero, animated: false)
                self.stationsCollectionView.layoutIfNeeded()
                self.verticalSpaceBelowMap.constant = 0
                
                self.mapView.layoutIfNeeded()
                }, completion:{
                    (value: Bool) in
            })
            
        case .compact:
            self.stationsCollectionView.reloadData() //ensure colors and values are reset
            self.stationsCollectionView.isScrollEnabled = false
            UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
                self.mapHeaderLabel.text = NSLocalizedString("STATIONS", comment: "")
                self.mapButton.isHidden = false
                self.searchButton.isHidden = false
                self.cancelDetailButton.isHidden = true
                self.mapOverlayButton.isHidden = true
                self.collectionViewHeight.constant = self.kStationCellHeight
                self.stationsCollectionView.setContentOffset(CGPoint.zero, animated: false) //reset scrollview to top
                self.stationsCollectionView.layoutIfNeeded()
                self.verticalSpaceBelowMap.constant = 0
                self.mapView.layoutIfNeeded()
                }, completion:{
                    (value: Bool) in
                    self.populateMap(false)  //re-add missing pins without removing first
                    if (self.selectedPin != nil) {
                        self.setupMap(self.selectedPin!.coordinate, latDelta: self.mapView.region.span.latitudeDelta, longDelta: self.mapView.region.span.longitudeDelta)
                    }
            })
            
        case .detail:
            self.stationsCollectionView.reloadData() //ensure colors and values are set
            self.stationsCollectionView.isScrollEnabled = true
            for ann in self.mapView.annotations { //hide any pins that are deselected to prevent jumping during animation
                if let annView = ann as? MapPin {
                    if (annView != self.selectedPin) {
                        self.mapView.removeAnnotation(annView)
                    }
                } else {
                    let userLocView = ann 
                    self.mapView.removeAnnotation(userLocView)
                }
            }
            UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
                self.mapHeaderLabel.text = NSLocalizedString("DETAILS", comment: "")
                self.mapButton.isHidden = true
                self.searchButton.isHidden = true
                self.cancelDetailButton.isHidden = false
                self.mapOverlayButton.isHidden = false
                self.collectionViewHeight.constant =  self.kStationCellHeight + self.kAmenitiesCellHeight + self.kExtraDetailCellHeight + self.kDealsCellHeight
                self.stationsCollectionView.layoutIfNeeded()
                self.verticalSpaceBelowMap.constant = self.collectionViewHeight.constant
                self.mapView.layoutIfNeeded()
                }, completion:{
                    (value: Bool) in
                    if (self.selectedPin != nil) {
                        self.setupMap(self.selectedPin!.coordinate, latDelta: self.mapView.region.span.latitudeDelta, longDelta: self.mapView.region.span.longitudeDelta)
                    }
            })
        }
        
        
    }
    
    /**
    Method to setup collection view Views to contain relevant station information
    
    - parameter station:      GasStation to display
    - parameter reusableView: reusableView header to customize with station's information
    */
    func setupViews(_ station: GasStation, reusableView: StationsCollectionReusableView){
        //initially set estimated time and distance label to blank
        reusableView.distanceLabel.text = ""
        reusableView.timeLabel.text = ""
        
        //top part
        reusableView.priceLabel.text = LocalizationUtils.localizeCurrency(station.gasPrice)
        reusableView.addressLabel.text = station.address
        
        //change highlight color of buttons to gray
        reusableView.websiteButton.setBackgroundColorForState(UIColor.grayLoyalty(), forState: .highlighted)
        reusableView.directionsButton.setBackgroundColorForState(UIColor.grayLoyalty(), forState: .highlighted)
        reusableView.phoneNumberButton.setBackgroundColorForState(UIColor.grayLoyalty(), forState: .highlighted)
        
        //distance calculation
        LocationUtils.sharedInstance.calcDistanceAndTimeFromUsersLocation(station, callback: { (distance: CLLocationDistance?, time: TimeInterval?, success) -> () in
            if (success) {
                MILAlertViewManager.sharedInstance.hide() //hide alert if shown
                reusableView.distanceLabel.text = LocalizationUtils.localizeDistance(distance!)
                reusableView.timeLabel.text = String.localizedStringWithFormat(NSLocalizedString("%.0f min", comment: ""), time! / 60)
                self.searchButton.isUserInteractionEnabled = true
            } else {
                MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), view: self.view, underView: self.navigationBar, callback: {self.setupViews(station, reusableView: reusableView)})
                self.searchButton.isUserInteractionEnabled = false
            }
            
        })
        
        //amenities
        reusableView.amenitiesCollectionView.reloadData()
        
        //hours
        let openString = LocalizationUtils.localizeTime(station.hours.open)//dateFormatter.stringFromDate(station.hours.open)
        let closeString = LocalizationUtils.localizeTime(station.hours.close) //dateFormatter.stringFromDate(station.hours.close)
        if (openString == closeString) {
            reusableView.hoursLabel.text = NSLocalizedString("Open 24 Hours", comment: "")
        } else {
            reusableView.hoursLabel.text = String.localizedStringWithFormat(NSLocalizedString("Open from %@ - %@", comment: ""), openString, closeString)
        }
        //currently open or closed
        if station.isOpen {
            reusableView.openClosedLabel.text = NSLocalizedString("Open",  comment: "")
        } else {
            reusableView.openClosedLabel.text = NSLocalizedString("Closed",  comment: "")
        }
        
        //directions
        reusableView.directionsLabel.text = NSLocalizedString("Directions",  comment: "")
        
        //Format phone number string based on the user's current locale
        let locale = Locale.current
        let countryCode = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String
        let formatter = NBAsYouTypeFormatter(regionCode: countryCode)
        let formattedString = formatter?.inputString("\(station.phoneNumber)")
        do {
            let number:NBPhoneNumber = try phoneUtil!.parse("\(station.phoneNumber)", defaultRegion:countryCode)
            if (phoneUtil?.isValidNumber(forRegion: number, regionCode: countryCode))! { //if valid phone number, show this
                reusableView.phoneNumberLabel.text = NSLocalizedString("Call",  comment: "") + " \(formattedString)"
            } else { // if not valid, just show phone number text
                reusableView.phoneNumberLabel.text = NSLocalizedString("Call",  comment: "") + " \(station.phoneNumber)"
            }
        } catch _ as NSError {
        }
        
        //website
        reusableView.websiteLabel.text = station.website
    }
    
    
    /**
    Method to setup tableview cell for station
    
    - parameter stationData: GasStation to setup cell with
    */
    func setupCell(_ cell: StationTableViewCell, stationData: GasStation){
        
        //save which station this is
        cell.station = stationData
        
        cell.priceLabel.text = LocalizationUtils.localizeCurrency(stationData.gasPrice)
        cell.addressLabel.text = stationData.address
        
        //currently open or closed
        if cell.station.isOpen {
            cell.openLabel.text = NSLocalizedString("Open",  comment: "")
        } else {
            cell.openLabel.text = NSLocalizedString("Closed",  comment: "")
        }
        
        cell.distanceLabel.text = ""
        cell.estimatedTimeLabel.text = ""
        
        //distance & time calculation
        LocationUtils.sharedInstance.calcDistanceAndTimeFromUsersLocation(cell.station, callback: { (distance: CLLocationDistance?, time: TimeInterval?, success) -> () in
            if (success) {
                MILAlertViewManager.sharedInstance.hide() //hide alert if shown
                cell.distanceLabel.text = LocalizationUtils.localizeDistance(distance!)
                cell.estimatedTimeLabel.text = String.localizedStringWithFormat(NSLocalizedString("%.0f min", comment: ""), time! / 60)
                self.searchButton.isUserInteractionEnabled = true
            } else {
                MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), view: self.view, underView: self.navigationBar, callback: {self.setupCell(cell, stationData: stationData)})
                self.searchButton.isUserInteractionEnabled = false
            }
            
        })
    }
    
    /**
    This method hides or shows the SearchViewController depended on what it's current state is
    */
    func hideOrShowSearchViewController(){
        self.currentCollectionViewState = .hidden //hide everything currently shown
        self.view.bringSubview(toFront: searchViewControllerContainerView)
        self.searchViewControllerContainerViewHeightConstraint.constant = self.mapView.frame.height
        
        self.currentCollectionViewState = .hidden //hide everything currently shown
        if self.searchViewControllerContainerViewVerticalSpaceConstraint.constant == 0.0 { //if full screen, hide
           self.hideSearchViewControllerAndSearchBar()
        } else { // if hidden, bring to full screen
            self.showSearchViewControllerAndSearchBar()
        }
    }
    
    
    /**
    This method hides the SearchViewController And Search Bar
    */
    func hideSearchViewControllerAndSearchBar(){
        self.hideSearchBar()
        self.searchBar.resignFirstResponder()
        
        UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
            self.searchViewControllerContainerViewVerticalSpaceConstraint.constant = UIScreen.main.bounds.height
            self.view.layoutIfNeeded()
            }, completion:{
                (value: Bool) in
        })
    }
    
    /**
    This method shows the SearchViewController And Search Bar
    */
    func showSearchViewControllerAndSearchBar(){
        self.showSearchBar()
        UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
            self.searchViewControllerContainerViewVerticalSpaceConstraint.constant = 0.0
            self.view.layoutIfNeeded()
            }, completion:{
                (value: Bool) in
        })
    }
    
    /**
    This method is called when the search button is pressed
    
    - parameter sender:
    */
    @IBAction func searchButtonAction(_ sender: AnyObject) {
        self.hideOrShowSearchViewController()
        
    }
    
    
    /**
    This method sets up the search bar and adds it to the navigationBar
    */
    func setUpSearchBar(){
        
        if(didSetUpSearchBar == false){
            
            let centerX = self.navigationBar.center.x
            let centerY = self.navigationBar.center.y + 30
            let width = self.navigationBar.frame.size.width - 20
            let height = self.navigationBar.frame.size.height - 20
            
            self.searchBar = UISearchBar(frame:
                CGRect(x: 0, y: 0, width: width, height: height))
            self.searchBar.center.x = centerX
            self.searchBar.center.y = centerY
            self.searchBar.alpha = 0.0
            self.navigationBar.addSubview(self.searchBar)
            
            self.searchBar.tintColor = UIColor.tealLoyalty()
            self.searchBar.searchBarStyle = UISearchBarStyle.minimal;
            self.searchBar.placeholder = NSLocalizedString("Search", comment: "")
            
            self.didSetUpSearchBar = true
            
            self.searchBar.delegate = self
        }
        
    }
    
    
    /**
    This method shows the search bar in the navigation bar when the search view controller is visible
    */
    func showSearchBar(){
        
        UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
            
            self.mapButton.alpha = 0.0
            self.mapHeaderLabel.alpha = 0.0
            self.searchButton.alpha = 0.0
            self.searchBar.alpha = 1.0
            
            self.view.layoutIfNeeded()
            }, completion:{
                (value: Bool) in
        })
    }
    
    /**
    This method hides the search bar that was shown in the navigation bar when the search view controller is visible
    */
    func hideSearchBar(){
        
        UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
            
            self.mapButton.alpha = 1.0
            self.mapHeaderLabel.alpha = 1.0
            self.searchButton.alpha = 1.0
            self.searchBar.alpha = 0.0
            
            self.view.layoutIfNeeded()
            }, completion:{
                (value: Bool) in
        })
        
    }
    
    
    /**
    This method is called when the keyboard is shown. It sets the searchViewControllerContainerViewHeightConstraint to be its original height - the keyboard height + the tabBarHeight. This was done so the apply and cancel buttons could still be accessed while the keyboard is shown.
    
    - parameter sender:
    */
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = sender.userInfo {
           let keyboardHeight =  (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
           if (keyboardHeight > 0) {
                
                let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
                
                UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
                    
                    self.searchViewControllerContainerViewHeightConstraint.constant = self.searchViewControllerContainerViewHeightConstraint.constant - keyboardHeight + tabBarHeight
                    
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    /**
    This method is called when the keyboard hides. It resets the searchViewControllerContainerViewHeightConstraint back to its full size before the keyboard was shown
    
    - parameter sender:
    */
    func keyboardWillHide(_ sender: Notification) {
        if let userInfo = sender.userInfo {
            let height = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
            if (height > 0){
                
                UIView.animate(withDuration: self.kAnimationDuration, animations: { () -> Void in
                    
                    self.searchViewControllerContainerViewHeightConstraint.constant = self.mapView.frame.size.height
                    
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    /**
    This method for the first time the view shows up, will sort the gas stations by distance
    */
    func sortGasStationsByDistanceOnFirstLoad(){
        if(self.initialSortByDistance == false){
            self.searchViewController.applySortingAndFilters()
            self.initialSortByDistance = true
        }
    }
    
    //geofencing methods
    
    func enableGeoFencing() {
        
        for station in self.stationDataArray {
            
            
            let coordinate =  CLLocationCoordinate2D(latitude: station.coordinate.latitude, longitude: station.coordinate.longitude)
            let radius = 100.0
            let identifier = NSUUID().uuidString
            let note = "Nearing gas station, deals awaiting"
            let eventType: EventType = .onEntry
            let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
            let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)
            geotifications.append(geotification)
            mapView.addAnnotation(geotification)
            addRadiusOverlay(forGeotification: geotification)
            startMonitoring(geotification: geotification)
            
        }
        
    }
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoring(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = self.region(withGeotification: geotification)
        // 4
        locationManager.startMonitoring(for: region)
    }
    func addRadiusOverlay(forGeotification geotification: Geotification) {
        mapView?.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
    
    
    
    
}

// MARK: - Extension to handle showing and hiding no results views and logic

extension StationsViewController: NoStationsActionDelegate {
    
    func refineSearchAction() {
        self.hideOrShowSearchViewController()
    }
    
    /**
    Method to show or hide "No Results" views based on if there are stations to view
    */
    func toggleNoResultsView() {
        
        if self.stationDataArray.count <= 0 {
            self.noResultsView.isHidden = false
            self.tableView.backgroundView?.isHidden = false
        } else {
            self.noResultsView.isHidden = true
            self.tableView.backgroundView?.isHidden = true
        }
        
    }
    
}

extension StationsViewController: UITableViewDataSource, UITableViewDelegate{
    
    /**
    Table view delegate method that creates and returns a UITableViewCell for specified index path.
    
    - parameter tableView:
    - parameter indexPath:
    
    - returns: UITableViewCell for specified index path.
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var stationCell = self.tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as? StationTableViewCell
        
        if stationCell == nil {
            stationCell = StationTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "stationCell")
        }
        
        setupCell(stationCell!, stationData: stationDataArray[indexPath.row])
        stationCell!.layoutMargins = UIEdgeInsets.zero
        return stationCell!
        
    }
    
    
    /**
    Table view delegate method that returns the number of rows in a section.
    
    - parameter tableView:
    - parameter section:
    
    - returns: Rows in section.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationDataArray.count
    }
    
    /**
    Table view delegate method that returns cell height for an index path.
    
    - parameter tableView:
    - parameter indexPath:
    
    - returns: Cell height for index path.
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.kStationCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stationCell = self.tableView.cellForRow(at: indexPath) as! StationTableViewCell
        let annotations = self.mapView.annotations
        for ann in annotations { //cycle through annotations and if annotation is a MapPin with equal GasStation to the cell, select it
            if let curr = ann as? MapPin {
                if (curr.station == stationCell.station) {
                    //self.currentCollectionViewState = .Detail
                    self.mapView.selectAnnotation(curr, animated: false)
                    hideListView()
                }
            }
        }
    }
    
}

extension StationsViewController: MKMapViewDelegate{
    
    
    //geofencing
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    //geofencing
    
    /**
    Map view delegate method called when an annotation is selected
    
    - parameter mapView:
    - parameter pin:
    */
    func mapView(_ mapView: MKMapView, didSelect pin: MKAnnotationView) {
        
        let mapPin: AnyObject = mapView.selectedAnnotations[0]
        if (mapPin is MapPin){
            pin.image = UIImage(named: "map pin_selected")
            
            pin.animateIncreaseWithBounce(10, animationDuration: 0.4, bottomMoves: false)
            
            self.selectedPin = mapPin as? MapPin
            
            
            self.currentStation = self.stationByLatLongDictionary[self.selectedPin!.tag]
            
            self.deals = self.currentStation.deals
  
            self.currentCollectionViewState = .compact
        } else {
            self.currentCollectionViewState = .hidden
        }
        
        //when selecting gas station, set deals = gasstation.deals and reload collection view
    }
    
    /**
    Map view delegate method called when an annotation is deselected. Current functionality is to change the collection view into a hidden state.
    
    - parameter mapView:
    - parameter pin:
    */
    func mapView(_ mapView: MKMapView, didDeselect pin: MKAnnotationView) {
        
        if selectedPin == (pin.annotation as? MapPin) {
            
            if (pin.image != UIImage(named: "current-location")){
                pin.image = UIImage(named: "map pin_unselected")
            }
            
            self.currentCollectionViewState = .hidden
         
            self.selectedPin = nil
        }
    }
    
    /**
    Map view delegate method that is called when an annotation is created and determines the MKAnnotationView.
    
    - parameter mapView:
    - parameter annotation:
    
    - returns: MKAnnotationView
    */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //var annotationView = MKAnnotationView()
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.showsUserLocation = true
        }
        
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationID")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotationID")
        }
        
        let identifier = "myGeotification"
        if annotation is Geotification {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let removeButton = UIButton(type: .custom)
                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                removeButton.setImage(UIImage(named: "DeleteGeotification"), for: .normal)
                annotationView?.leftCalloutAccessoryView = removeButton
            } else {
                annotationView?.annotation = annotation
            }
        }
        
        else if (annotation.isKind(of: MapPin.self)) {
            annotationView!.image = UIImage(named: "map pin_unselected")
            annotationView!.canShowCallout = false
            annotationView!.centerOffset = CGPoint(x: 0,y: -annotationView!.frame.size.height*0.5)
            
            
            //account for pin offset due to custom image
        } else {
            annotationView!.image = UIImage(named: "current-location")
            annotationView!.canShowCallout = false
            annotationView!.centerOffset = CGPoint(x: 0,y: -annotationView!.frame.size.height*0.5) //account for pin offset due to custom image
            
        }
        
        
        
        return annotationView
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        if (self.selectedPin == nil) {
            self.populateMap(true)
        }
    }
    
    
    /**
    This method sets up the searchView controller
    */
    func setUpSearchViewController(){
        
        let searchViewController = Utils.vcWithNameFromStoryboardWithName("SearchViewController", storyboardName: "Search") as! SearchViewController
        
        self.addChildViewController(searchViewController)
        
        searchViewController.didMove(toParentViewController: self)
        
        searchViewController.view.frame = CGRect(x: 0,y: 0, width: self.searchViewControllerHolderView.frame.size.width, height: self.searchViewControllerHolderView.frame.size.height)
        
        self.searchViewControllerHolderView.addSubview(searchViewController.view)
        
    }
    
}

extension StationsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView.tag == 0) { //dealsCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DealCollectionViewCell
            let deal = deals[indexPath.row]
            Utils.setCellBasedOnDeal(cell, deal: deal, showSaved: true)
            return cell
        } else { //amenitiesCollectionView (tag = 1)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "amenitiesCollectionViewCell", for: indexPath) as! AmenitiesCollectionViewCell
            cell.imageView.image = UIImage(named: self.currentStation.amenities[indexPath.row])
            // amenity strings: "alcohol","pay phone","restrooms","car wash”,"atm","fresh fruit”,”coffee”,”diesel",”restaurant","24hours"
            switch self.currentStation.amenities[indexPath.row] {
            case "alcohol":
                cell.imageView.image = UIImage(named: "wine-beer")
            case "pay phone":
                cell.imageView.image = UIImage(named: "phone")
            case "restrooms":
                cell.imageView.image = UIImage(named: "bathrooms")
            case "car wash":
                cell.imageView.image = UIImage(named: "car-wash")
            case "atm":
                cell.imageView.image = UIImage(named: "atm")
            case "fresh fruit":
                cell.imageView.image = UIImage(named: "fresh fruit")
            case "coffee":
                cell.imageView.image = UIImage(named: "coffee")
            case "diesel":
                cell.imageView.image = UIImage(named: "diesel")
            case "restaurant":
                cell.imageView.image = UIImage(named: "restaurant")
            case "24hours":
                cell.imageView.image = UIImage(named: "24-hours")
            default:
                logger.logInfoWithMessages(message: NSLocalizedString("Amenity not found!", comment: ""))
            }
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView.tag == 0) { //dealsCollectionView
            return deals.count
        } else { //amenitiesCollectionView (tag = 1)
            return self.currentStation.amenities.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (collectionView.tag == 0) { //dealsCollectionView
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! StationsCollectionReusableView
            self.reusableViewHeader = header
            //customize header outlets here with stuff like header.phoneNumber = currentStation.phoneNumber
            if (self.currentCollectionViewState == .compact || self.currentCollectionViewState == .hidden) {
                header.stationView.backgroundColor = UIColor.white
                header.priceLabel.textColor = UIColor.purpleLoyalty()
                header.addressLabel.textColor = UIColor.grayLoyalty()
                header.openClosedLabel.textColor = UIColor.grayLoyalty()
                header.timeLabel.textColor = UIColor.blackLoyalty()
                header.distanceLabel.textColor = UIColor.blackLoyalty()
                self.stationsCollectionView.layoutIfNeeded()
            } else { //Detail
                header.stationView.backgroundColor = UIColor.tealLoyalty()
                header.priceLabel.textColor = UIColor.white
                header.addressLabel.textColor = UIColor.white
                header.openClosedLabel.textColor = UIColor.white
                header.timeLabel.textColor = UIColor.white
                header.distanceLabel.textColor = UIColor.white
                self.stationsCollectionView.layoutIfNeeded()
            }
            
            self.setupViews(self.currentStation, reusableView: header)
            
            return header
        } else { //amenitiesCollectionView (no header)
            let header = UICollectionReusableView()
            return header
        }
    }
    
    
}

extension StationsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.tag == 0) { //dealsCollectionView
            if let dealsDetailViewController = Utils.vcWithNameFromStoryboardWithName("DealsDetailViewController", storyboardName: "Deals") as? DealsDetailViewController {
                dealsDetailViewController.deal = deals[indexPath.row]
                navigationController?.pushViewController(dealsDetailViewController, animated: true)
            }
        }
        
    }
}

extension StationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if (collectionView.tag == 0) { //dealsCollectionView
            let collectionWidth = collectionView.width
            return CGSize(width: collectionWidth, height: 400)
        } else {
            return CGSize.zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView.tag == 0) { //dealsCollectionView
            return Utils.sizeOfCellForCollectionView(collectionView)
        } else {
            return CGSize(width: 22, height: 22)
        }
    }
    
}

extension StationsViewController: SearchManagerDelegate {
    
    /**
    This method is a SearchManagerDelegate method and is called when the SearchManager has new search results after sorting and filtering gasstations
    
    - parameter result: the sorted and filtered gas station array
    */
    func newSearchResults(_ result : [GasStation]){
        self.stationDataArray = result
        self.tableView.reloadData()
       
        if(isSortingRefresh == false){
        self.populateMap(true)
        }
        else{
            isSortingRefresh = false
        }
       
        self.toggleNoResultsView()
    }
    
}

extension StationsViewController: SearchViewControllerDelegate {
    
    /**
    This method is called when the apply button on the SearchViewController is pressed
    */
    func applyButtonPressed() {
        
        self.hideOrShowSearchViewController()
    }
    
    
    
    
    /**
    This method is called when the cancel button on the SearchViewController is pressed
    */
    func cancelButtonPressed() {
        self.hideOrShowSearchViewController()
    }
    
    /**
    This method is called when the SearchViewController wants to get the text that has been entered in self.searchBar
    
    - returns: the text that was entered in self.searchBar
    */
    func getSearchBarText() -> String {
        return self.searchBar.text!
    }
    
    /**
    This method is called when the SearchViewController wants to reset the search bar text that has been entered in self.searchBar
    */
    func resetSearchBarText(){
        self.searchBar.text = ""
    }
}

extension StationsViewController: UISearchBarDelegate {
    
    /**
    This method is called when the search button is pressed on the keyboard when self.searchBar is first responder.
    
    - parameter searchBar: the searchBar that is first responder when the search button on the keyboard is pressed
    */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchViewController.applySortingAndFilters()
        self.applyButtonPressed()
    }
    
    //geofencing methods
    
    
}

// MARK: - Location Manager Delegate
extension StationsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = status == .authorizedAlways
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier) \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
}

