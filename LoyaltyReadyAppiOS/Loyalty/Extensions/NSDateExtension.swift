/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

enum DateFormat {
    case iso8601, dotNet, rss, altRSS
    case custom(String)
}

extension Date {
    
    // MARK: Intervals In Seconds
    fileprivate static func miliToSecondsMultiplier() -> Double { return 0.001 }
    fileprivate static func minuteInSeconds() -> Double { return 60 }
    fileprivate static func hourInSeconds() -> Double { return 3600 }
    fileprivate static func dayInSeconds() -> Double { return 86400 }
    fileprivate static func weekInSeconds() -> Double { return 604800 }
    fileprivate static func yearInSeconds() -> Double { return 31556926 }
    
    // MARK: Components
    fileprivate static func componentFlags() -> NSCalendar.Unit { return NSCalendar.Unit.year.union(.month).union(.day).union(.weekOfYear).union(.hour).union(.minute).union(.second).union(.weekday).union(.weekdayOrdinal) }
    
    fileprivate static func components(fromDate: Date) -> DateComponents! {
        return (Calendar.current as NSCalendar).components(Date.componentFlags(), from: fromDate)
    }
    
    fileprivate func components() -> DateComponents  {
        return Date.components(fromDate: self)!
    }
    
    // MARK: Date From String
    
    init(fromString string: String, format:DateFormat)
    {
        if string.isEmpty {
          //  (self as Date).type(of: init)()
            self.init()
            return
        }
        
        let string = string as NSString
        
        switch format {
            
        case .dotNet:
            
            // Expects "/Date(1268123281843)/"
            let startIndex = string.range(of: "(").location + 1
            let endIndex = string.range(of: ")").location
            let range = NSRange(location: startIndex, length: endIndex-startIndex)
            let milliseconds = (string.substring(with: range) as NSString).longLongValue
            let interval = TimeInterval(milliseconds / 1000)
          //  (self as Date).type(of: init)(timeIntervalSince1970: interval)
            self.init(timeIntervalSince1970: interval)
            
        case .iso8601:
            
            var s = string
            if string.hasSuffix(" 00:00") {
                s = s.substring(to: s.length-6) + "GMT" as NSString
            } else if string.hasSuffix("Z") {
                s = s.substring(to: s.length-1) + "GMT" as NSString
            }
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
            if let date = formatter.date(from: string as String) {
               // (self as Date).type(of: init)(timeInterval:0, since:date)
                self.init(timeInterval:0, since:date)
            } else {
                //(self as Date).type(of: init)()
                self.init()
                
            }
            
        case .rss:
            
            var s  = string
            if string.hasSuffix("Z") {
                s = s.substring(to: s.length-1) + "GMT" as NSString
            }
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
            if let date = formatter.date(from: string as String) {
               // (self as Date).type(of: init)(timeInterval:0, since:date)
                self.init(timeInterval:0, since:date)
            } else {
                self.init()
            }
            
        case .altRSS:
            
            var s  = string
            if string.hasSuffix("Z") {
                s = s.substring(to: s.length-1) + "GMT" as NSString
            }
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "d MMM yyyy HH:mm:ss ZZZ"
            if let date = formatter.date(from: string as String) {
                self.init(timeInterval:0, since:date)
            } else {
                self.init()
            }
            
        case .custom(let dateFormat):
            
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = dateFormat
            if let date = formatter.date(from: string as String) {
                self.init(timeInterval:0, since:date)
            } else {
                self.init()
            }
        }
    }
    
    
    
    // MARK: Comparing Dates
    
    func isEqualToDateIgnoringTime(_ date: Date) -> Bool
    {
        let comp1 = Date.components(fromDate: self)
        let comp2 = Date.components(fromDate: date)
        return ((comp1!.year == comp2!.year) && (comp1!.month == comp2!.month) && (comp1!.day == comp2!.day))
    }
    
    func isToday() -> Bool
    {
        return isEqualToDateIgnoringTime(Date())
    }
    
    func isTomorrow() -> Bool
    {
        return isEqualToDateIgnoringTime(Date().dateByAddingDays(1))
    }
    
    func isYesterday() -> Bool
    {
        return isEqualToDateIgnoringTime(Date().dateBySubtractingDays(1))
    }
    
    func isSameWeekAsDate(_ date: Date) -> Bool
    {
        let comp1 = Date.components(fromDate: self)
        let comp2 = Date.components(fromDate: date)
        // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
        if comp1?.weekOfYear != comp2?.weekOfYear {
            return false
        }
        // Must have a time interval under 1 week
        return abs(timeIntervalSince(date)) < Date.weekInSeconds()
    }
    

        func localizedStringTime()->String {
            return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
        }

    
    func isThisWeek() -> Bool
    {
        return isSameWeekAsDate(Date())
    }
    
    func isNextWeek() -> Bool
    {
        let interval: TimeInterval = Date().timeIntervalSinceReferenceDate + Date.weekInSeconds()
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return isSameYearAsDate(date)
    }
    
    func isLastWeek() -> Bool
    {
        let interval: TimeInterval = Date().timeIntervalSinceReferenceDate - Date.weekInSeconds()
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return isSameYearAsDate(date)
    }
    
    func isSameYearAsDate(_ date: Date) -> Bool
    {
        let comp1 = Date.components(fromDate: self)
        let comp2 = Date.components(fromDate: date)
        return (comp1!.year == comp2!.year)
    }
    
    func isThisYear() -> Bool
    {
        return isSameYearAsDate(Date())
    }
    
    func isNextYear() -> Bool
    {
        let comp1 = Date.components(fromDate: self)
        let comp2 = Date.components(fromDate: Date())
        return (comp1!.year! == comp2!.year! + 1)
    }
    
    func isLastYear() -> Bool
    {
        let comp1 = Date.components(fromDate: self)
        let comp2 = Date.components(fromDate: Date())
        return (comp1!.year! == comp2!.year! - 1)
    }
    
    func isEarlierThanDate(_ date: Date) -> Bool
    {
       // return earlierDate(date) == self
        return self.compare(date) == .orderedAscending
    }
    
    func isLaterThanDate(_ date: Date) -> Bool
    {
       // return daysAfterDate(date) == self
        return self.compare(date) == .orderedDescending
    }
    
    
    // MARK: Adjusting Dates
    
    func dateByAddingDays(_ days: Int) -> Date
    {
        let interval: TimeInterval = timeIntervalSinceReferenceDate + Date.dayInSeconds() * Double(days)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingDays(_ days: Int) -> Date
    {
        let interval: TimeInterval = timeIntervalSinceReferenceDate - Date.dayInSeconds() * Double(days)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateByAddingHours(_ hours: Int) -> Date
    {
        let interval: TimeInterval = timeIntervalSinceReferenceDate + Date.hourInSeconds() * Double(hours)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingHours(_ hours: Int) -> Date
    {
        let interval: TimeInterval = timeIntervalSinceReferenceDate - Date.hourInSeconds() * Double(hours)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateByAddingMinutes(_ minutes: Int) -> Date
    {
        let interval: TimeInterval = timeIntervalSinceReferenceDate + Date.minuteInSeconds() * Double(minutes)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateByAddingMiliSeconds(_ miliSeconds: Int) -> Date
    {
        let interval: TimeInterval = timeIntervalSinceReferenceDate + Date.miliToSecondsMultiplier() * Double(miliSeconds)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingMinutes(_ minutes: Int) -> Date
    {
        let interval: TimeInterval = timeIntervalSinceReferenceDate - Date.minuteInSeconds() * Double(minutes)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateAtStartOfDay() -> Date
    {
        var comps = components()
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        return Calendar.current.date(from: comps)!
    }
    
    func dateAtEndOfDay() -> Date
    {
        var comps = components()
        comps.hour = 23
        comps.minute = 59
        comps.second = 59
        return Calendar.current.date(from: comps)!
    }
    
    func dateAtStartOfWeek() -> Date
    {
        let flags :NSCalendar.Unit = [.year, .month, .weekOfYear, .weekday]
        var components = (Calendar.current as NSCalendar).components(flags, from: self)
        components.weekday = 1 // Sunday
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components)!
    }
    
    func dateAtEndOfWeek() -> Date
    {
        let flags :NSCalendar.Unit = [.year, .month, .weekOfYear, .weekday]
        var components = (Calendar.current as NSCalendar).components(flags, from: self)
        components.weekday = 7 // Sunday
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components)!
    }
    
    
    // MARK: Retrieving Intervals
    
    func minutesAfterDate(_ date: Date) -> Int
    {
        let interval = timeIntervalSince(date)
        return Int(interval / Date.minuteInSeconds())
    }
    
    func minutesBeforeDate(_ date: Date) -> Int
    {
        let interval = date.timeIntervalSince(self)
        return Int(interval / Date.minuteInSeconds())
    }
    
    func hoursAfterDate(_ date: Date) -> Int
    {
        let interval = timeIntervalSince(date)
        return Int(interval / Date.hourInSeconds())
    }
    
    func hoursBeforeDate(_ date: Date) -> Int
    {
        let interval = date.timeIntervalSince(self)
        return Int(interval / Date.hourInSeconds())
    }
    
    func daysAfterDate(_ date: Date) -> Int
    {
        let interval = timeIntervalSince(date)
        return Int(interval / Date.dayInSeconds())
    }
    
    func daysBeforeDate(_ date: Date) -> Int
    {
        let interval = date.timeIntervalSince(self)
        return Int(interval / Date.dayInSeconds())
    }
    
    
    // MARK: Decomposing Dates
    
    func nearestHour () -> Int {
        let halfHour = Date.minuteInSeconds() * 30
        var interval = timeIntervalSinceReferenceDate
        if  seconds() < 30 {
            interval -= halfHour
        } else {
            interval += halfHour
        }
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return date.hour()
    }
    
    func year () -> Int { return components().year!  }
    func month () -> Int { return components().month! }
    func week () -> Int { return components().weekOfYear! }
    func day () -> Int { return components().day! }
    func hour () -> Int { return components().hour! }
    func minute () -> Int { return components().minute! }
    func seconds () -> Int { return components().second! }
    func weekday () -> Int { return components().weekday! }
    func nthWeekday () -> Int { return components().weekdayOrdinal! } //// e.g. 2nd Tuesday of the month is 2
    func monthDays () -> Int { return (Calendar.current as NSCalendar).range(of: .day, in: .month, for: self).length }
    func firstDayOfWeek () -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds() * Double(components().weekday! - 1)
        let interval: TimeInterval = timeIntervalSinceReferenceDate - distanceToStartOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).day()
    }
    func lastDayOfWeek () -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds() * Double(components().weekday! - 1)
        let distanceToEndOfWeek = Date.dayInSeconds() * Double(7)
        let interval: TimeInterval = timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).day()
    }
    func isWeekday() -> Bool {
        return !isWeekend()
    }
    func isWeekend() -> Bool {
        let range = (Calendar.current as NSCalendar).maximumRange(of: NSCalendar.Unit.weekday)
        return (weekday() == range.location || weekday() == range.length)
    }
    
    
    // MARK: To String
    
    func toString() -> String {
        return toString(dateStyle: .short, timeStyle: .short, doesRelativeDateFormatting: false)
    }
    
    func toString(format: DateFormat) -> String
    {
        let dateFormat: String
        switch format {
        case .dotNet:
            let offset = NSTimeZone.default.secondsFromGMT() / 3600
            let nowMillis = 1000 * timeIntervalSince1970
            return  "/Date(\(nowMillis)\(offset))/"
        case .iso8601:
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        case .rss:
            dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
        case .altRSS:
            dateFormat = "d MMM yyyy HH:mm:ss ZZZ"
        case .custom(let string):
            dateFormat = string
        }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
    
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool = false) -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        return formatter.string(from: self)
    }
    
    func relativeTimeToString() -> String
    {
        let time = timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        
        let seconds = now - time
        let minutes = round(seconds/60)
        let hours = round(minutes/60)
        let days = round(hours/24)
        
        if seconds < 10 {
            return NSLocalizedString("just now", comment: "relative time")
        } else if seconds < 60 {
            return NSLocalizedString("\(Int(seconds)) seconds ago", comment: "relative time")
        }
        
        if minutes < 60 {
            if minutes == 1 {
                return NSLocalizedString("1 minute ago", comment: "relative time")
            } else {
                return NSLocalizedString("\(Int(minutes)) minutes ago", comment: "relative time")
            }
        }
        
        if hours < 24 {
            if hours == 1 {
                return NSLocalizedString("1 hour ago", comment: "relative time")
            } else {
                return NSLocalizedString("\(Int(hours)) hours ago", comment: "relative time")
            }
        }
        
        if days < 7 {
            if days == 1 {
                return NSLocalizedString("1 day ago", comment: "relative time")
            } else {
                return NSLocalizedString("\(Int(days)) days ago", comment: "relative time")
            }
        }
        
        return toString()
    }
    
    
    func weekdayToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.weekdaySymbols[weekday()-1] 
    }
    
    func shortWeekdayToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.shortWeekdaySymbols[weekday()-1] 
    }
    
    func veryShortWeekdayToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.veryShortWeekdaySymbols[weekday()-1] 
    }
    
    func monthToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.monthSymbols[month()-1] 
    }
    
    func shortMonthToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.shortMonthSymbols[month()-1] 
    }
    
    func veryShortMonthToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.veryShortMonthSymbols[month()-1] 
    }
    
    
    /**
    This adds a new method dateAt to NSDate.
    
    It returns a new date at the specified hours and minutes of the receiver
    
    - parameter hours:: The hours value
    - parameter minutes:: The new minutes
    
    - returns: a new NSDate with the same year/month/day as the receiver, but with the specified hours/minutes values
    */
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = (calendar as NSCalendar).components(
            [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for 8:00 AM today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}
//-------------------------------------------------------------
//Tell the system that NSDates can be compared with ==, >, >=, <, and <= operators
//extension Date: Comparable {}

//-------------------------------------------------------------
//Define the global operators for the
//Equatable and Comparable protocols for comparing NSDates

public func ==(lhs: Date, rhs: Date) -> Bool
{
    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}

public func <(lhs: Date, rhs: Date) -> Bool
{
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
public func >(lhs: Date, rhs: Date) -> Bool
{
    return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}
public func <=(lhs: Date, rhs: Date) -> Bool
{
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
public func >=(lhs: Date, rhs: Date) -> Bool
{
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970

//-------------------------------------------------------------
    
    
    
}
