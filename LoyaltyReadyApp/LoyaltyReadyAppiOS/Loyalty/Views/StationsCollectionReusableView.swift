/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/// UICollectionReusableView used in the StationViewController's UICollectionView
class StationsCollectionReusableView: UICollectionReusableView {
 /// View containing basic station information
    @IBOutlet weak var stationView: UIView!
 /// View containing directions button and information
    @IBOutlet weak var directionsView: UIView!
 /// View containing website button and information
    @IBOutlet weak var websiteView: UIView!
 /// View containing phone number button and information
    @IBOutlet weak var phoneNumberView: UIView!
 /// View containing hours information
    @IBOutlet weak var hoursView: UIView!
 /// View containing amenities available
    @IBOutlet weak var amenitiesView: UIView!
 /// Label of gas price
    @IBOutlet weak var priceLabel: UILabel!
 /// Label of station address
    @IBOutlet weak var addressLabel: UILabel!
 /// Label saying if station is open or closed
    @IBOutlet weak var openClosedLabel: UILabel!
 /// Label for distance from station to current location
    @IBOutlet weak var distanceLabel: UILabel!
 /// Label for time open
    @IBOutlet weak var timeLabel: UILabel!
 /// Collection view for available amenities
    @IBOutlet weak var amenitiesCollectionView: UICollectionView!
 /// Label for hours information
    @IBOutlet weak var hoursLabel: UILabel!
 /// Label for directions information
    @IBOutlet weak var directionsLabel: UILabel!
 /// Label for phone number information
    @IBOutlet weak var phoneNumberLabel: UILabel!
 /// Label for website information
    @IBOutlet weak var websiteLabel: UILabel!
 /// Button for finding directions
    @IBOutlet weak var directionsButton: UIButton!
 /// Button for calling gas station
    @IBOutlet weak var phoneNumberButton: UIButton!
 /// Button for opening website of station
    @IBOutlet weak var websiteButton: UIButton!
    
}
