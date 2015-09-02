/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class Amenities: NSObject {
    
    override init() {
        super.init()
        self.setUpAmenities()
    }
    
    var amenitiesArray = [String]()
    var amenityStringByTableViewCellTitle = [String : String]()
    var amenityIconImageNameByTableViewCellTitle = [String : String]()
    
    func setUpAmenities(){
        
        let openNowString = NSLocalizedString("Open Now", comment: "n/a")
        let atmString = NSLocalizedString("ATM", comment: "n/a")
        let bathroomString = NSLocalizedString("Bathrooms", comment: "n/a")
        let alcoholString = NSLocalizedString("Beer & Wine", comment: "n/a")
        let carWashString = NSLocalizedString("Car Wash", comment: "n/a")
        let coffeeString = NSLocalizedString("Coffee", comment: "n/a")
        let dieselFuelString = NSLocalizedString("Diesel Fuel", comment: "n/a")
        let freshFruitString = NSLocalizedString("Fresh Fruit", comment: "n/a")
        let open24String = NSLocalizedString("Open 24 Hours", comment: "n/a")
        let payPhoneString = NSLocalizedString("Pay Phone", comment: "n/a")
        let restaurantString = NSLocalizedString("Restaurant", comment: "n/a")
        
        self.amenitiesArray = [openNowString, atmString, bathroomString, alcoholString, carWashString, coffeeString, dieselFuelString, freshFruitString, open24String, payPhoneString, restaurantString]
        
        self.amenityStringByTableViewCellTitle[amenitiesArray[0]] = "openNow"  //Open Now
        self.amenityStringByTableViewCellTitle[amenitiesArray[1]] = "atm"  //ATM
        self.amenityStringByTableViewCellTitle[amenitiesArray[2]] = "restrooms"  //Bathrooms
        self.amenityStringByTableViewCellTitle[amenitiesArray[3]] = "alcohol"  //Beer & Wine
        self.amenityStringByTableViewCellTitle[amenitiesArray[4]] = "car wash"  //Car Wash
        self.amenityStringByTableViewCellTitle[amenitiesArray[5]] = "coffee"  //Coffee
        self.amenityStringByTableViewCellTitle[amenitiesArray[6]] = "diesel"  //Diesel Fuel
        self.amenityStringByTableViewCellTitle[amenitiesArray[7]] = "fresh fruit"  //Fresh Fruit
        self.amenityStringByTableViewCellTitle[amenitiesArray[8]] = "24hours"  //Open 24 Hours
        self.amenityStringByTableViewCellTitle[amenitiesArray[9]] = "pay phone"  //Pay Phone
        self.amenityStringByTableViewCellTitle[amenitiesArray[10]] = "restaurant"  //Restaurant
        
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[0]] = "24-hours"  //Open Now
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[1]] = "atm"  //ATM
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[2]] = "bathrooms"  //Bathrooms
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[3]] = "wine-beer"  //Beer & Wine
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[4]] = "car-wash"  //Car Wash
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[5]] = "coffee"  //Coffee
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[6]] = "diesel"  //Diesel Fuel
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[7]] = "fresh fruit"  //Fresh Fruit
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[8]] = "24-hours"  //Open 24 Hours
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[9]] = "phone"  //Pay Phone
        self.amenityIconImageNameByTableViewCellTitle[amenitiesArray[10]] = "restaurant" //Restaurant
        
        
        
        
    }
    
}
