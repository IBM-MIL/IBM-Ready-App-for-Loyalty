/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Useful methods specifically for localization
*/
class LocalizationUtils: NSObject {
    
    /**
    Takes a double value and returns a string representing the value using the user's locale
    
    - parameter amount: A Double amount for a currency
    
    - returns: The value using the user's locale
    */
    class func localizeCurrency(amount: Double) -> String {
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.locale = NSLocale.currentLocale()
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.alwaysShowsDecimalSeparator = true
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        return currencyFormatter.stringFromNumber(amount)!
        
    }
    
    /**
    Takes a GasStation and returns a string representing the distance from location like ".78 mi" or km based on locale
    
    - parameter station: GasStation to find distance away
    
    - returns: A string representing distance away from station in mi or km
    */
    class func localizeDistance(distance: CLLocationDistance) -> String {
        let locale = NSLocale.currentLocale()
        let isMetric: Bool = locale.objectForKey(NSLocaleUsesMetricSystem)!.boolValue
        
        if (isMetric) {
            let d = distance / 1000 //km
            return String.localizedStringWithFormat(NSLocalizedString("%.2f km", comment: ""), d)
        } else {
            let d = distance * 0.000621371 //mi
            return String.localizedStringWithFormat(NSLocalizedString("%.2f mi", comment: ""), d)
        }
    }
    
    /**
    Takes an NSDate for time and converts it to a localized string (either 12 or 24 hour format)
    
    - parameter time: time to convert to localized string
    
    - returns: A string representing the localized time
    */
    class func localizeTime(time: NSDate) -> String {
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: locale)!
        
        if dateFormat.rangeOfString("a") != nil { //12 hour time
            return time.localizedStringTime()
        } else { //24 hour time
            return time.localizedStringTime()
        }
    }
    
}
