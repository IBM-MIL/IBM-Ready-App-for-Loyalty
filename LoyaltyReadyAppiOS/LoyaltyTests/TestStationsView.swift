/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/
import MapKit

class TestStationsView: KIFTestCase {
    
    override func beforeAll() {
        tester().clearPopupsNoAccount(true)
        tester().openStationsTab()
    }
    
    func testListView() {
        tester().checkListView()
    }
    func testMapView() {
        tester().checkMapView()
    }
    
    func testSameNumberOfStationsInBothViews() {
        let cellCount = tester().getListViewVisibleCells()
        print("cellCount: \(cellCount)")
        let pinCount = tester().getMapPinCount(true)
        print("pinCount: \(pinCount)")
        XCTAssertEqual(cellCount, pinCount, "Should always display the same number of statsions in both the list '\(cellCount)' and map  \(pinCount)' views.")
    }
    
    func testCanSeeStationDetailsMapView() {
        let annotations = tester().getMapPins()
        for anno in annotations {
                tester().printSubViews(anno.subviews)
        }
    }
    
    func testCanSeeStationDeatilsListView() {
        
    }
}

private extension KIFUITestActor {
    
    /**  test helper methods **/
    func checkListView() {
        loadListView()
        let view : UITableView =  validateViewExists(Stations.table.rawValue) as! UITableView
        XCTAssertNotNil(view, "UI list view  should not be nil")
        XCTAssertNotEqual(getListViewVisibleCells(), 0, "Should have more than a single goal.")
    }
    
    func getListViewVisibleCells() -> Int {
        loadListView()
        let view : UITableView =  validateViewExists(Stations.table.rawValue) as! UITableView
        let visibleCells : Int = view.visibleCells.count
        return visibleCells
    }
    
    func getUserLocation() -> MKPointAnnotation? {
        loadMapView()
        let mapView : MKMapView = validateViewExists(Stations.map.rawValue) as! MKMapView
        let annotations = mapView.annotations
        var userLocation : MKPointAnnotation?
        for view in annotations {
            //if  _stdlib_getDemangledTypeName(view) == "MKPointAnnotation" {
            if  String(reflecting: view.dynamicType) == "MKPointAnnotation" {
                userLocation = view as? MKPointAnnotation
            }
        }
        return userLocation
    }
    
    func getMapPins() -> [AnyObject] {
        loadMapView()
        waitForViewToLoad(10)
        let mapView : MKMapView = validateViewExists(Stations.map.rawValue) as! MKMapView
        var pins = [AnyObject]()
        
        for view in mapView.annotations {
            //if  _stdlib_getDemangledTypeName(view) == "Loyalty.MapPin" {
            if  String(reflecting: view.dynamicType) == "Loyalty.MapPin" {
                pins.append(view)
            }
        }
        return pins
    }
    
    func getMapPinCount(shouldToggle : Bool) -> Int {
        let annotations = getMapPins()
        let annotationsCount : Int = annotations.count
        return annotationsCount
    }
    
    func checkMapView() {
        loadMapView()
        let view : MKMapView = validateViewExists(Stations.map.rawValue) as! MKMapView
        XCTAssertNotNil(view, "map view should not be nil")
        XCTAssertNotEqual(view.annotations.count, 0, "Should have more than one pin loaded.")
    }
    
    func loadMapView() {
        let toggleButton = validateViewExists(Stations.toggle.rawValue) as! UIButton
        let mapButtonImageSize = CGSize(width: 16.0, height: 19.0)
        if toggleButton.currentImage?.size == mapButtonImageSize {
            tester().tapViewWithAccessibilityLabel(Stations.toggle.rawValue)
        }
        waitForMapViewWithAccessibilityLabelToLoad(Stations.map.rawValue, print: false)
    }
    
    func loadListView() {
        let toggleButton = validateViewExists(Stations.toggle.rawValue) as! UIButton
        let listButtonImageSize = CGSize(width: 21.0, height: 13.0)
        if toggleButton.currentImage?.size == listButtonImageSize {
            tester().tapViewWithAccessibilityLabel(Stations.toggle.rawValue)
        }
        tester().waitForViewToLoad(2)
    }
}
