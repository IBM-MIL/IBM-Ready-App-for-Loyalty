/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

//Project specific font
extension UIFont {
    /**
    Returns the UIFont for Heuristica-Regular of a particular size
    - parameter size: The size of the font
    */
    class func heuristicaRegular(_ size: CGFloat) -> UIFont{return UIFont(name: "Heuristica-Regular", size: size)!}
    
    
    /**
    Returns the UIFont for Heuristica-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func heuristicaBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Heuristica-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Heuristica-Bold of a particular size
    - parameter size: The size of the font
    */
    class func heuristicaBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Heuristica-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Heuristica-Italic of a particular size
    - parameter size: The size of the font
    */
    class func heuristicaItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Heuristica-Italic", size: size)!}

    /**
    Returns the UIFont for Montserrat-Bold of a particular size
    - parameter size: The size of the font
    */
    class func montserratBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Montserrat-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Montserrat-Regular of a particular size
    - parameter size: The size of the font
    */
    class func montserratRegular(_ size: CGFloat) -> UIFont{return UIFont(name: "Montserrat-Regular", size: size)!}
    

}

extension UIFont {
    
    
    /**
    Prints all the font names for the app to the console. This is helpful to find out if the font you added is in the project and to find the string needed to initialize a font with.
    */
    
    class func printAllFontNames(){
        let logger : OCLogger = OCLogger.getInstanceWithPackage("Loyalty");
        for family in UIFont.familyNames{
            logger.logInfoWithMessages(message: "\(family)")
            for font in UIFont.fontNames(forFamilyName: (family )){
                logger.logInfoWithMessages(message: "\t\(font)")
            }
        }
    }
    
    /**
    Generates and prints all the code needed to make a function for each default font in XCode
    */
    class func printAllFontNameFunctions(){
        let logger : OCLogger = OCLogger.getInstanceWithPackage("Loyalty");
        for family in UIFont.familyNames{
            for font in (UIFont.fontNames(forFamilyName: (family )) ){
                var fontfunctionname = font.lowercaseFirstLetterString()
                fontfunctionname = fontfunctionname.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
                logger.logInfoWithMessages(message: "\t/**\n\tReturns the UIFont for \(font) of a particular size\n\t:param: size The size of the font\n\t*/\n\tclass func \(fontfunctionname)(size: CGFloat) -> UIFont{return UIFont(name: \"\(font)\", size: size)!}\n\n")
            }
        }
    }

    /**
    Returns the UIFont for Marion-Italic of a particular size
    - parameter size: The size of the font
    */
    class func marionItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Marion-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for Marion-Bold of a particular size
    - parameter size: The size of the font
    */
    class func marionBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Marion-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Marion-Regular of a particular size
    - parameter size: The size of the font
    */
    class func marionRegular(_ size: CGFloat) -> UIFont{return UIFont(name: "Marion-Regular", size: size)!}
    
    
    /**
    Returns the UIFont for Copperplate-Light of a particular size
    - parameter size: The size of the font
    */
    class func copperplateLight(_ size: CGFloat) -> UIFont{return UIFont(name: "Copperplate-Light", size: size)!}
    
    
    /**
    Returns the UIFont for Copperplate of a particular size
    - parameter size: The size of the font
    */
    class func copperplate(_ size: CGFloat) -> UIFont{return UIFont(name: "Copperplate", size: size)!}
    
    
    /**
    Returns the UIFont for Copperplate-Bold of a particular size
    - parameter size: The size of the font
    */
    class func copperplateBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Copperplate-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for STHeitiSC-Medium of a particular size
    - parameter size: The size of the font
    */
    class func sTHeitiSCMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "STHeitiSC-Medium", size: size)!}
    
    
    /**
    Returns the UIFont for STHeitiSC-Light of a particular size
    - parameter size: The size of the font
    */
    class func sTHeitiSCLight(_ size: CGFloat) -> UIFont{return UIFont(name: "STHeitiSC-Light", size: size)!}
    
    
    /**
    Returns the UIFont for IowanOldStyle-Italic of a particular size
    - parameter size: The size of the font
    */
    class func iowanOldStyleItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "IowanOldStyle-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for IowanOldStyle-Roman of a particular size
    - parameter size: The size of the font
    */
    class func iowanOldStyleRoman(_ size: CGFloat) -> UIFont{return UIFont(name: "IowanOldStyle-Roman", size: size)!}
    
    
    /**
    Returns the UIFont for IowanOldStyle-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func iowanOldStyleBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "IowanOldStyle-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for IowanOldStyle-Bold of a particular size
    - parameter size: The size of the font
    */
    class func iowanOldStyleBold(_ size: CGFloat) -> UIFont{return UIFont(name: "IowanOldStyle-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for CourierNewPS-BoldMT of a particular size
    - parameter size: The size of the font
    */
    class func courierNewPSBoldMT(_ size: CGFloat) -> UIFont{return UIFont(name: "CourierNewPS-BoldMT", size: size)!}
    
    
    /**
    Returns the UIFont for CourierNewPS-ItalicMT of a particular size
    - parameter size: The size of the font
    */
    class func courierNewPSItalicMT(_ size: CGFloat) -> UIFont{return UIFont(name: "CourierNewPS-ItalicMT", size: size)!}
    
    
    /**
    Returns the UIFont for CourierNewPSMT of a particular size
    - parameter size: The size of the font
    */
    class func courierNewPSMT(_ size: CGFloat) -> UIFont{return UIFont(name: "CourierNewPSMT", size: size)!}
    
    
    /**
    Returns the UIFont for CourierNewPS-BoldItalicMT of a particular size
    - parameter size: The size of the font
    */
    class func courierNewPSBoldItalicMT(_ size: CGFloat) -> UIFont{return UIFont(name: "CourierNewPS-BoldItalicMT", size: size)!}
    
    
    /**
    Returns the UIFont for AppleSDGothicNeo-Bold of a particular size
    - parameter size: The size of the font
    */
    class func appleSDGothicNeoBold(_ size: CGFloat) -> UIFont{return UIFont(name: "AppleSDGothicNeo-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for AppleSDGothicNeo-Thin of a particular size
    - parameter size: The size of the font
    */
    class func appleSDGothicNeoThin(_ size: CGFloat) -> UIFont{return UIFont(name: "AppleSDGothicNeo-Thin", size: size)!}
    
    
    /**
    Returns the UIFont for AppleSDGothicNeo-UltraLight of a particular size
    - parameter size: The size of the font
    */
    class func appleSDGothicNeoUltraLight(_ size: CGFloat) -> UIFont{return UIFont(name: "AppleSDGothicNeo-UltraLight", size: size)!}
    
    
    /**
    Returns the UIFont for AppleSDGothicNeo-Regular of a particular size
    - parameter size: The size of the font
    */
    class func appleSDGothicNeoRegular(_ size: CGFloat) -> UIFont{return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!}
    
    
    /**
    Returns the UIFont for AppleSDGothicNeo-Light of a particular size
    - parameter size: The size of the font
    */
    class func appleSDGothicNeoLight(_ size: CGFloat) -> UIFont{return UIFont(name: "AppleSDGothicNeo-Light", size: size)!}
    
    
    /**
    Returns the UIFont for AppleSDGothicNeo-Medium of a particular size
    - parameter size: The size of the font
    */
    class func appleSDGothicNeoMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "AppleSDGothicNeo-Medium", size: size)!}
    
    
    /**
    Returns the UIFont for AppleSDGothicNeo-SemiBold of a particular size
    - parameter size: The size of the font
    */
    class func appleSDGothicNeoSemiBold(_ size: CGFloat) -> UIFont{return UIFont(name: "AppleSDGothicNeo-SemiBold", size: size)!}
    
    
    /**
    Returns the UIFont for STHeitiTC-Medium of a particular size
    - parameter size: The size of the font
    */
    class func sTHeitiTCMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "STHeitiTC-Medium", size: size)!}
    
    
    /**
    Returns the UIFont for STHeitiTC-Light of a particular size
    - parameter size: The size of the font
    */
    class func sTHeitiTCLight(_ size: CGFloat) -> UIFont{return UIFont(name: "STHeitiTC-Light", size: size)!}
    
    
    /**
    Returns the UIFont for GillSans-Italic of a particular size
    - parameter size: The size of the font
    */
    class func gillSansItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "GillSans-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for GillSans-Bold of a particular size
    - parameter size: The size of the font
    */
    class func gillSansBold(_ size: CGFloat) -> UIFont{return UIFont(name: "GillSans-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for GillSans-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func gillSansBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "GillSans-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for GillSans-LightItalic of a particular size
    - parameter size: The size of the font
    */
    class func gillSansLightItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "GillSans-LightItalic", size: size)!}
    
    
    /**
    Returns the UIFont for GillSans of a particular size
    - parameter size: The size of the font
    */
    class func gillSans(_ size: CGFloat) -> UIFont{return UIFont(name: "GillSans", size: size)!}
    
    
    /**
    Returns the UIFont for GillSans-Light of a particular size
    - parameter size: The size of the font
    */
    class func gillSansLight(_ size: CGFloat) -> UIFont{return UIFont(name: "GillSans-Light", size: size)!}
    
    
    /**
    Returns the UIFont for MarkerFelt-Thin of a particular size
    - parameter size: The size of the font
    */
    class func markerFeltThin(_ size: CGFloat) -> UIFont{return UIFont(name: "MarkerFelt-Thin", size: size)!}
    
    
    /**
    Returns the UIFont for MarkerFelt-Wide of a particular size
    - parameter size: The size of the font
    */
    class func markerFeltWide(_ size: CGFloat) -> UIFont{return UIFont(name: "MarkerFelt-Wide", size: size)!}
    
    
    /**
    Returns the UIFont for Thonburi of a particular size
    - parameter size: The size of the font
    */
    class func thonburi(_ size: CGFloat) -> UIFont{return UIFont(name: "Thonburi", size: size)!}
    
    
    /**
    Returns the UIFont for Thonburi-Bold of a particular size
    - parameter size: The size of the font
    */
    class func thonburiBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Thonburi-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Thonburi-Light of a particular size
    - parameter size: The size of the font
    */
    class func thonburiLight(_ size: CGFloat) -> UIFont{return UIFont(name: "Thonburi-Light", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-Heavy of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedHeavy(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-Heavy", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-Medium of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-Medium", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-Regular of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedRegular(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-Regular", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-HeavyItalic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedHeavyItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-HeavyItalic", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-MediumItalic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedMediumItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-MediumItalic", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-Italic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-UltraLightItalic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedUltraLightItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-UltraLightItalic", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-UltraLight of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedUltraLight(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-UltraLight", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-DemiBold of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedDemiBold(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-DemiBold", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-Bold of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedBold(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNextCondensed-DemiBoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextCondensedDemiBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNextCondensed-DemiBoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for TamilSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func tamilSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "TamilSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for TamilSangamMN-Bold of a particular size
    - parameter size: The size of the font
    */
    class func tamilSangamMNBold(_ size: CGFloat) -> UIFont{return UIFont(name: "TamilSangamMN-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-Italic of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-Bold of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueBold(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-UltraLight of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueUltraLight(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-UltraLight", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-CondensedBlack of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueCondensedBlack(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-CondensedBlack", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-CondensedBold of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueCondensedBold(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-CondensedBold", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-Medium of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-Medium", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-Light of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueLight(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-Light", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-Thin of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueThin(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-Thin", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-ThinItalic of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueThinItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-ThinItalic", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-LightItalic of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueLightItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-LightItalic", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-UltraLightItalic of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueUltraLightItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-UltraLightItalic", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue-MediumItalic of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeueMediumItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue-MediumItalic", size: size)!}
    
    
    /**
    Returns the UIFont for HelveticaNeue of a particular size
    - parameter size: The size of the font
    */
    class func helveticaNeue(_ size: CGFloat) -> UIFont{return UIFont(name: "HelveticaNeue", size: size)!}
    
    
    /**
    Returns the UIFont for GurmukhiMN-Bold of a particular size
    - parameter size: The size of the font
    */
    class func gurmukhiMNBold(_ size: CGFloat) -> UIFont{return UIFont(name: "GurmukhiMN-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for GurmukhiMN of a particular size
    - parameter size: The size of the font
    */
    class func gurmukhiMN(_ size: CGFloat) -> UIFont{return UIFont(name: "GurmukhiMN", size: size)!}
    
    
    /**
    Returns the UIFont for TimesNewRomanPSMT of a particular size
    - parameter size: The size of the font
    */
    class func timesNewRomanPSMT(_ size: CGFloat) -> UIFont{return UIFont(name: "TimesNewRomanPSMT", size: size)!}
    
    
    /**
    Returns the UIFont for TimesNewRomanPS-BoldItalicMT of a particular size
    - parameter size: The size of the font
    */
    class func timesNewRomanPSBoldItalicMT(_ size: CGFloat) -> UIFont{return UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: size)!}
    
    
    /**
    Returns the UIFont for TimesNewRomanPS-ItalicMT of a particular size
    - parameter size: The size of the font
    */
    class func timesNewRomanPSItalicMT(_ size: CGFloat) -> UIFont{return UIFont(name: "TimesNewRomanPS-ItalicMT", size: size)!}
    
    
    /**
    Returns the UIFont for TimesNewRomanPS-BoldMT of a particular size
    - parameter size: The size of the font
    */
    class func timesNewRomanPSBoldMT(_ size: CGFloat) -> UIFont{return UIFont(name: "TimesNewRomanPS-BoldMT", size: size)!}
    
    
    /**
    Returns the UIFont for Georgia-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func georgiaBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Georgia-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Georgia of a particular size
    - parameter size: The size of the font
    */
    class func georgia(_ size: CGFloat) -> UIFont{return UIFont(name: "Georgia", size: size)!}
    
    
    /**
    Returns the UIFont for Georgia-Italic of a particular size
    - parameter size: The size of the font
    */
    class func georgiaItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Georgia-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for Georgia-Bold of a particular size
    - parameter size: The size of the font
    */
    class func georgiaBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Georgia-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for AppleColorEmoji of a particular size
    - parameter size: The size of the font
    */
    class func appleColorEmoji(_ size: CGFloat) -> UIFont{return UIFont(name: "AppleColorEmoji", size: size)!}
    
    
    /**
    Returns the UIFont for ArialRoundedMTBold of a particular size
    - parameter size: The size of the font
    */
    class func arialRoundedMTBold(_ size: CGFloat) -> UIFont{return UIFont(name: "ArialRoundedMTBold", size: size)!}
    
    
    /**
    Returns the UIFont for Kailasa-Bold of a particular size
    - parameter size: The size of the font
    */
    class func kailasaBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Kailasa-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Kailasa of a particular size
    - parameter size: The size of the font
    */
    class func kailasa(_ size: CGFloat) -> UIFont{return UIFont(name: "Kailasa", size: size)!}
    
    
    /**
    Returns the UIFont for KohinoorDevanagari-Light of a particular size
    - parameter size: The size of the font
    */
    class func kohinoorDevanagariLight(_ size: CGFloat) -> UIFont{return UIFont(name: "KohinoorDevanagari-Light", size: size)!}
    
    
    /**
    Returns the UIFont for KohinoorDevanagari-Medium of a particular size
    - parameter size: The size of the font
    */
    class func kohinoorDevanagariMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "KohinoorDevanagari-Medium", size: size)!}
    
    
    /**
    Returns the UIFont for KohinoorDevanagari-Book of a particular size
    - parameter size: The size of the font
    */
    class func kohinoorDevanagariBook(_ size: CGFloat) -> UIFont{return UIFont(name: "KohinoorDevanagari-Book", size: size)!}
    
    
    /**
    Returns the UIFont for SinhalaSangamMN-Bold of a particular size
    - parameter size: The size of the font
    */
    class func sinhalaSangamMNBold(_ size: CGFloat) -> UIFont{return UIFont(name: "SinhalaSangamMN-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for SinhalaSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func sinhalaSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "SinhalaSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for ChalkboardSE-Bold of a particular size
    - parameter size: The size of the font
    */
    class func chalkboardSEBold(_ size: CGFloat) -> UIFont{return UIFont(name: "ChalkboardSE-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for ChalkboardSE-Light of a particular size
    - parameter size: The size of the font
    */
    class func chalkboardSELight(_ size: CGFloat) -> UIFont{return UIFont(name: "ChalkboardSE-Light", size: size)!}
    
    
    /**
    Returns the UIFont for ChalkboardSE-Regular of a particular size
    - parameter size: The size of the font
    */
    class func chalkboardSERegular(_ size: CGFloat) -> UIFont{return UIFont(name: "ChalkboardSE-Regular", size: size)!}
    
    
    /**
    Returns the UIFont for Superclarendon-Italic of a particular size
    - parameter size: The size of the font
    */
    class func superclarendonItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Superclarendon-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for Superclarendon-Black of a particular size
    - parameter size: The size of the font
    */
    class func superclarendonBlack(_ size: CGFloat) -> UIFont{return UIFont(name: "Superclarendon-Black", size: size)!}
    
    
    /**
    Returns the UIFont for Superclarendon-LightItalic of a particular size
    - parameter size: The size of the font
    */
    class func superclarendonLightItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Superclarendon-LightItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Superclarendon-BlackItalic of a particular size
    - parameter size: The size of the font
    */
    class func superclarendonBlackItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Superclarendon-BlackItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Superclarendon-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func superclarendonBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Superclarendon-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Superclarendon-Light of a particular size
    - parameter size: The size of the font
    */
    class func superclarendonLight(_ size: CGFloat) -> UIFont{return UIFont(name: "Superclarendon-Light", size: size)!}
    
    
    /**
    Returns the UIFont for Superclarendon-Regular of a particular size
    - parameter size: The size of the font
    */
    class func superclarendonRegular(_ size: CGFloat) -> UIFont{return UIFont(name: "Superclarendon-Regular", size: size)!}
    
    
    /**
    Returns the UIFont for Superclarendon-Bold of a particular size
    - parameter size: The size of the font
    */
    class func superclarendonBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Superclarendon-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for GujaratiSangamMN-Bold of a particular size
    - parameter size: The size of the font
    */
    class func gujaratiSangamMNBold(_ size: CGFloat) -> UIFont{return UIFont(name: "GujaratiSangamMN-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for GujaratiSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func gujaratiSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "GujaratiSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for DamascusLight of a particular size
    - parameter size: The size of the font
    */
    class func damascusLight(_ size: CGFloat) -> UIFont{return UIFont(name: "DamascusLight", size: size)!}
    
    
    /**
    Returns the UIFont for DamascusBold of a particular size
    - parameter size: The size of the font
    */
    class func damascusBold(_ size: CGFloat) -> UIFont{return UIFont(name: "DamascusBold", size: size)!}
    
    
    /**
    Returns the UIFont for DamascusSemiBold of a particular size
    - parameter size: The size of the font
    */
    class func damascusSemiBold(_ size: CGFloat) -> UIFont{return UIFont(name: "DamascusSemiBold", size: size)!}
    
    
    /**
    Returns the UIFont for DamascusMedium of a particular size
    - parameter size: The size of the font
    */
    class func damascusMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "DamascusMedium", size: size)!}
    
    
    /**
    Returns the UIFont for Damascus of a particular size
    - parameter size: The size of the font
    */
    class func damascus(_ size: CGFloat) -> UIFont{return UIFont(name: "Damascus", size: size)!}
    
    
    /**
    Returns the UIFont for Noteworthy-Light of a particular size
    - parameter size: The size of the font
    */
    class func noteworthyLight(_ size: CGFloat) -> UIFont{return UIFont(name: "Noteworthy-Light", size: size)!}
    
    
    /**
    Returns the UIFont for Noteworthy-Bold of a particular size
    - parameter size: The size of the font
    */
    class func noteworthyBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Noteworthy-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for GeezaPro of a particular size
    - parameter size: The size of the font
    */
    class func geezaPro(_ size: CGFloat) -> UIFont{return UIFont(name: "GeezaPro", size: size)!}
    
    
    /**
    Returns the UIFont for GeezaPro-Bold of a particular size
    - parameter size: The size of the font
    */
    class func geezaProBold(_ size: CGFloat) -> UIFont{return UIFont(name: "GeezaPro-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-Medium of a particular size
    - parameter size: The size of the font
    */
    class func avenirMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-Medium", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-HeavyOblique of a particular size
    - parameter size: The size of the font
    */
    class func avenirHeavyOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-HeavyOblique", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-Book of a particular size
    - parameter size: The size of the font
    */
    class func avenirBook(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-Book", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-Light of a particular size
    - parameter size: The size of the font
    */
    class func avenirLight(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-Light", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-Roman of a particular size
    - parameter size: The size of the font
    */
    class func avenirRoman(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-Roman", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-BookOblique of a particular size
    - parameter size: The size of the font
    */
    class func avenirBookOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-BookOblique", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-Black of a particular size
    - parameter size: The size of the font
    */
    class func avenirBlack(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-Black", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-MediumOblique of a particular size
    - parameter size: The size of the font
    */
    class func avenirMediumOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-MediumOblique", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-BlackOblique of a particular size
    - parameter size: The size of the font
    */
    class func avenirBlackOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-BlackOblique", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-Heavy of a particular size
    - parameter size: The size of the font
    */
    class func avenirHeavy(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-Heavy", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-LightOblique of a particular size
    - parameter size: The size of the font
    */
    class func avenirLightOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-LightOblique", size: size)!}
    
    
    /**
    Returns the UIFont for Avenir-Oblique of a particular size
    - parameter size: The size of the font
    */
    class func avenirOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Avenir-Oblique", size: size)!}
    
    
    /**
    Returns the UIFont for AcademyEngravedLetPlain of a particular size
    - parameter size: The size of the font
    */
    class func academyEngravedLetPlain(_ size: CGFloat) -> UIFont{return UIFont(name: "AcademyEngravedLetPlain", size: size)!}
    
    
    /**
    Returns the UIFont for DiwanMishafi of a particular size
    - parameter size: The size of the font
    */
    class func diwanMishafi(_ size: CGFloat) -> UIFont{return UIFont(name: "DiwanMishafi", size: size)!}
    
    
    /**
    Returns the UIFont for Futura-CondensedMedium of a particular size
    - parameter size: The size of the font
    */
    class func futuraCondensedMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "Futura-CondensedMedium", size: size)!}
    
    
    /**
    Returns the UIFont for Futura-CondensedExtraBold of a particular size
    - parameter size: The size of the font
    */
    class func futuraCondensedExtraBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Futura-CondensedExtraBold", size: size)!}
    
    
    /**
    Returns the UIFont for Futura-Medium of a particular size
    - parameter size: The size of the font
    */
    class func futuraMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "Futura-Medium", size: size)!}
    
    
    /**
    Returns the UIFont for Futura-MediumItalic of a particular size
    - parameter size: The size of the font
    */
    class func futuraMediumItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Futura-MediumItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Farah of a particular size
    - parameter size: The size of the font
    */
    class func farah(_ size: CGFloat) -> UIFont{return UIFont(name: "Farah", size: size)!}
    
    
    /**
    Returns the UIFont for KannadaSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func kannadaSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "KannadaSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for KannadaSangamMN-Bold of a particular size
    - parameter size: The size of the font
    */
    class func kannadaSangamMNBold(_ size: CGFloat) -> UIFont{return UIFont(name: "KannadaSangamMN-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for ArialHebrew-Bold of a particular size
    - parameter size: The size of the font
    */
    class func arialHebrewBold(_ size: CGFloat) -> UIFont{return UIFont(name: "ArialHebrew-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for ArialHebrew-Light of a particular size
    - parameter size: The size of the font
    */
    class func arialHebrewLight(_ size: CGFloat) -> UIFont{return UIFont(name: "ArialHebrew-Light", size: size)!}
    
    
    /**
    Returns the UIFont for ArialHebrew of a particular size
    - parameter size: The size of the font
    */
    class func arialHebrew(_ size: CGFloat) -> UIFont{return UIFont(name: "ArialHebrew", size: size)!}
    
    
    /**
    Returns the UIFont for ArialMT of a particular size
    - parameter size: The size of the font
    */
    class func arialMT(_ size: CGFloat) -> UIFont{return UIFont(name: "ArialMT", size: size)!}
    
    
    /**
    Returns the UIFont for Arial-BoldItalicMT of a particular size
    - parameter size: The size of the font
    */
    class func arialBoldItalicMT(_ size: CGFloat) -> UIFont{return UIFont(name: "Arial-BoldItalicMT", size: size)!}
    
    
    /**
    Returns the UIFont for Arial-BoldMT of a particular size
    - parameter size: The size of the font
    */
    class func arialBoldMT(_ size: CGFloat) -> UIFont{return UIFont(name: "Arial-BoldMT", size: size)!}
    
    
    /**
    Returns the UIFont for Arial-ItalicMT of a particular size
    - parameter size: The size of the font
    */
    class func arialItalicMT(_ size: CGFloat) -> UIFont{return UIFont(name: "Arial-ItalicMT", size: size)!}
    
    
    /**
    Returns the UIFont for PartyLetPlain of a particular size
    - parameter size: The size of the font
    */
    class func partyLetPlain(_ size: CGFloat) -> UIFont{return UIFont(name: "PartyLetPlain", size: size)!}
    
    
    /**
    Returns the UIFont for Chalkduster of a particular size
    - parameter size: The size of the font
    */
    class func chalkduster(_ size: CGFloat) -> UIFont{return UIFont(name: "Chalkduster", size: size)!}
    
    
    /**
    Returns the UIFont for HiraKakuProN-W6 of a particular size
    - parameter size: The size of the font
    */
    class func hiraKakuProNW6(_ size: CGFloat) -> UIFont{return UIFont(name: "HiraKakuProN-W6", size: size)!}
    
    
    /**
    Returns the UIFont for HiraKakuProN-W3 of a particular size
    - parameter size: The size of the font
    */
    class func hiraKakuProNW3(_ size: CGFloat) -> UIFont{return UIFont(name: "HiraKakuProN-W3", size: size)!}
    
    
    /**
    Returns the UIFont for HoeflerText-Italic of a particular size
    - parameter size: The size of the font
    */
    class func hoeflerTextItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "HoeflerText-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for HoeflerText-Regular of a particular size
    - parameter size: The size of the font
    */
    class func hoeflerTextRegular(_ size: CGFloat) -> UIFont{return UIFont(name: "HoeflerText-Regular", size: size)!}
    
    
    /**
    Returns the UIFont for HoeflerText-Black of a particular size
    - parameter size: The size of the font
    */
    class func hoeflerTextBlack(_ size: CGFloat) -> UIFont{return UIFont(name: "HoeflerText-Black", size: size)!}
    
    
    /**
    Returns the UIFont for HoeflerText-BlackItalic of a particular size
    - parameter size: The size of the font
    */
    class func hoeflerTextBlackItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "HoeflerText-BlackItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Optima-Regular of a particular size
    - parameter size: The size of the font
    */
    class func optimaRegular(_ size: CGFloat) -> UIFont{return UIFont(name: "Optima-Regular", size: size)!}
    
    
    /**
    Returns the UIFont for Optima-ExtraBlack of a particular size
    - parameter size: The size of the font
    */
    class func optimaExtraBlack(_ size: CGFloat) -> UIFont{return UIFont(name: "Optima-ExtraBlack", size: size)!}
    
    
    /**
    Returns the UIFont for Optima-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func optimaBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Optima-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Optima-Italic of a particular size
    - parameter size: The size of the font
    */
    class func optimaItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Optima-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for Optima-Bold of a particular size
    - parameter size: The size of the font
    */
    class func optimaBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Optima-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Palatino-Bold of a particular size
    - parameter size: The size of the font
    */
    class func palatinoBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Palatino-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Palatino-Roman of a particular size
    - parameter size: The size of the font
    */
    class func palatinoRoman(_ size: CGFloat) -> UIFont{return UIFont(name: "Palatino-Roman", size: size)!}
    
    
    /**
    Returns the UIFont for Palatino-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func palatinoBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Palatino-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Palatino-Italic of a particular size
    - parameter size: The size of the font
    */
    class func palatinoItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Palatino-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for MalayalamSangamMN-Bold of a particular size
    - parameter size: The size of the font
    */
    class func malayalamSangamMNBold(_ size: CGFloat) -> UIFont{return UIFont(name: "MalayalamSangamMN-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for MalayalamSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func malayalamSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "MalayalamSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for LaoSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func laoSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "LaoSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for AlNile-Bold of a particular size
    - parameter size: The size of the font
    */
    class func alNileBold(_ size: CGFloat) -> UIFont{return UIFont(name: "AlNile-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for AlNile of a particular size
    - parameter size: The size of the font
    */
    class func alNile(_ size: CGFloat) -> UIFont{return UIFont(name: "AlNile", size: size)!}
    
    
    /**
    Returns the UIFont for BradleyHandITCTT-Bold of a particular size
    - parameter size: The size of the font
    */
    class func bradleyHandITCTTBold(_ size: CGFloat) -> UIFont{return UIFont(name: "BradleyHandITCTT-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for HiraMinProN-W6 of a particular size
    - parameter size: The size of the font
    */
    class func hiraMinProNW6(_ size: CGFloat) -> UIFont{return UIFont(name: "HiraMinProN-W6", size: size)!}
    
    
    /**
    Returns the UIFont for HiraMinProN-W3 of a particular size
    - parameter size: The size of the font
    */
    class func hiraMinProNW3(_ size: CGFloat) -> UIFont{return UIFont(name: "HiraMinProN-W3", size: size)!}
    
    
    /**
    Returns the UIFont for Trebuchet-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func trebuchetBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Trebuchet-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for TrebuchetMS of a particular size
    - parameter size: The size of the font
    */
    class func trebuchetMS(_ size: CGFloat) -> UIFont{return UIFont(name: "TrebuchetMS", size: size)!}
    
    
    /**
    Returns the UIFont for TrebuchetMS-Bold of a particular size
    - parameter size: The size of the font
    */
    class func trebuchetMSBold(_ size: CGFloat) -> UIFont{return UIFont(name: "TrebuchetMS-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for TrebuchetMS-Italic of a particular size
    - parameter size: The size of the font
    */
    class func trebuchetMSItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "TrebuchetMS-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for Helvetica-Bold of a particular size
    - parameter size: The size of the font
    */
    class func helveticaBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Helvetica-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Helvetica of a particular size
    - parameter size: The size of the font
    */
    class func helvetica(_ size: CGFloat) -> UIFont{return UIFont(name: "Helvetica", size: size)!}
    
    
    /**
    Returns the UIFont for Helvetica-LightOblique of a particular size
    - parameter size: The size of the font
    */
    class func helveticaLightOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Helvetica-LightOblique", size: size)!}
    
    
    /**
    Returns the UIFont for Helvetica-Oblique of a particular size
    - parameter size: The size of the font
    */
    class func helveticaOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Helvetica-Oblique", size: size)!}
    
    
    /**
    Returns the UIFont for Helvetica-BoldOblique of a particular size
    - parameter size: The size of the font
    */
    class func helveticaBoldOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Helvetica-BoldOblique", size: size)!}
    
    
    /**
    Returns the UIFont for Helvetica-Light of a particular size
    - parameter size: The size of the font
    */
    class func helveticaLight(_ size: CGFloat) -> UIFont{return UIFont(name: "Helvetica-Light", size: size)!}
    
    
    /**
    Returns the UIFont for Courier-BoldOblique of a particular size
    - parameter size: The size of the font
    */
    class func courierBoldOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Courier-BoldOblique", size: size)!}
    
    
    /**
    Returns the UIFont for Courier of a particular size
    - parameter size: The size of the font
    */
    class func courier(_ size: CGFloat) -> UIFont{return UIFont(name: "Courier", size: size)!}
    
    
    /**
    Returns the UIFont for Courier-Bold of a particular size
    - parameter size: The size of the font
    */
    class func courierBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Courier-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Courier-Oblique of a particular size
    - parameter size: The size of the font
    */
    class func courierOblique(_ size: CGFloat) -> UIFont{return UIFont(name: "Courier-Oblique", size: size)!}
    
    
    /**
    Returns the UIFont for Cochin-Bold of a particular size
    - parameter size: The size of the font
    */
    class func cochinBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Cochin-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Cochin of a particular size
    - parameter size: The size of the font
    */
    class func cochin(_ size: CGFloat) -> UIFont{return UIFont(name: "Cochin", size: size)!}
    
    
    /**
    Returns the UIFont for Cochin-Italic of a particular size
    - parameter size: The size of the font
    */
    class func cochinItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Cochin-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for Cochin-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func cochinBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Cochin-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for DevanagariSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func devanagariSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "DevanagariSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for DevanagariSangamMN-Bold of a particular size
    - parameter size: The size of the font
    */
    class func devanagariSangamMNBold(_ size: CGFloat) -> UIFont{return UIFont(name: "DevanagariSangamMN-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for OriyaSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func oriyaSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "OriyaSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for OriyaSangamMN-Bold of a particular size
    - parameter size: The size of the font
    */
    class func oriyaSangamMNBold(_ size: CGFloat) -> UIFont{return UIFont(name: "OriyaSangamMN-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for SnellRoundhand-Bold of a particular size
    - parameter size: The size of the font
    */
    class func snellRoundhandBold(_ size: CGFloat) -> UIFont{return UIFont(name: "SnellRoundhand-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for SnellRoundhand of a particular size
    - parameter size: The size of the font
    */
    class func snellRoundhand(_ size: CGFloat) -> UIFont{return UIFont(name: "SnellRoundhand", size: size)!}
    
    
    /**
    Returns the UIFont for SnellRoundhand-Black of a particular size
    - parameter size: The size of the font
    */
    class func snellRoundhandBlack(_ size: CGFloat) -> UIFont{return UIFont(name: "SnellRoundhand-Black", size: size)!}
    
    
    /**
    Returns the UIFont for ZapfDingbatsITC of a particular size
    - parameter size: The size of the font
    */
    class func zapfDingbatsITC(_ size: CGFloat) -> UIFont{return UIFont(name: "ZapfDingbatsITC", size: size)!}
    
    
    /**
    Returns the UIFont for BodoniSvtyTwoITCTT-Bold of a particular size
    - parameter size: The size of the font
    */
    class func bodoniSvtyTwoITCTTBold(_ size: CGFloat) -> UIFont{return UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for BodoniSvtyTwoITCTT-Book of a particular size
    - parameter size: The size of the font
    */
    class func bodoniSvtyTwoITCTTBook(_ size: CGFloat) -> UIFont{return UIFont(name: "BodoniSvtyTwoITCTT-Book", size: size)!}
    
    
    /**
    Returns the UIFont for BodoniSvtyTwoITCTT-BookIta of a particular size
    - parameter size: The size of the font
    */
    class func bodoniSvtyTwoITCTTBookIta(_ size: CGFloat) -> UIFont{return UIFont(name: "BodoniSvtyTwoITCTT-BookIta", size: size)!}
    
    
    /**
    Returns the UIFont for Verdana-Italic of a particular size
    - parameter size: The size of the font
    */
    class func verdanaItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Verdana-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for Verdana-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func verdanaBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Verdana-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Verdana of a particular size
    - parameter size: The size of the font
    */
    class func verdana(_ size: CGFloat) -> UIFont{return UIFont(name: "Verdana", size: size)!}
    
    
    /**
    Returns the UIFont for Verdana-Bold of a particular size
    - parameter size: The size of the font
    */
    class func verdanaBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Verdana-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for AmericanTypewriter-CondensedLight of a particular size
    - parameter size: The size of the font
    */
    class func americanTypewriterCondensedLight(_ size: CGFloat) -> UIFont{return UIFont(name: "AmericanTypewriter-CondensedLight", size: size)!}
    
    
    /**
    Returns the UIFont for AmericanTypewriter of a particular size
    - parameter size: The size of the font
    */
    class func americanTypewriter(_ size: CGFloat) -> UIFont{return UIFont(name: "AmericanTypewriter", size: size)!}
    
    
    /**
    Returns the UIFont for AmericanTypewriter-CondensedBold of a particular size
    - parameter size: The size of the font
    */
    class func americanTypewriterCondensedBold(_ size: CGFloat) -> UIFont{return UIFont(name: "AmericanTypewriter-CondensedBold", size: size)!}
    
    
    /**
    Returns the UIFont for AmericanTypewriter-Light of a particular size
    - parameter size: The size of the font
    */
    class func americanTypewriterLight(_ size: CGFloat) -> UIFont{return UIFont(name: "AmericanTypewriter-Light", size: size)!}
    
    
    /**
    Returns the UIFont for AmericanTypewriter-Bold of a particular size
    - parameter size: The size of the font
    */
    class func americanTypewriterBold(_ size: CGFloat) -> UIFont{return UIFont(name: "AmericanTypewriter-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for AmericanTypewriter-Condensed of a particular size
    - parameter size: The size of the font
    */
    class func americanTypewriterCondensed(_ size: CGFloat) -> UIFont{return UIFont(name: "AmericanTypewriter-Condensed", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-UltraLight of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextUltraLight(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-UltraLight", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-UltraLightItalic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextUltraLightItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-UltraLightItalic", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-Bold of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextBold(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-DemiBold of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextDemiBold(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-DemiBold", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-DemiBoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextDemiBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-DemiBoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-Medium of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextMedium(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-Medium", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-HeavyItalic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextHeavyItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-HeavyItalic", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-Heavy of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextHeavy(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-Heavy", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-Italic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-Regular of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextRegular(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-Regular", size: size)!}
    
    
    /**
    Returns the UIFont for AvenirNext-MediumItalic of a particular size
    - parameter size: The size of the font
    */
    class func avenirNextMediumItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "AvenirNext-MediumItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Baskerville-Italic of a particular size
    - parameter size: The size of the font
    */
    class func baskervilleItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Baskerville-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for Baskerville-SemiBold of a particular size
    - parameter size: The size of the font
    */
    class func baskervilleSemiBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Baskerville-SemiBold", size: size)!}
    
    
    /**
    Returns the UIFont for Baskerville-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func baskervilleBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Baskerville-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Baskerville-SemiBoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func baskervilleSemiBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Baskerville-SemiBoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for Baskerville-Bold of a particular size
    - parameter size: The size of the font
    */
    class func baskervilleBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Baskerville-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Baskerville of a particular size
    - parameter size: The size of the font
    */
    class func baskerville(_ size: CGFloat) -> UIFont{return UIFont(name: "Baskerville", size: size)!}
    
    
    /**
    Returns the UIFont for KhmerSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func khmerSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "KhmerSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for Didot-Italic of a particular size
    - parameter size: The size of the font
    */
    class func didotItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Didot-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for Didot-Bold of a particular size
    - parameter size: The size of the font
    */
    class func didotBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Didot-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Didot of a particular size
    - parameter size: The size of the font
    */
    class func didot(_ size: CGFloat) -> UIFont{return UIFont(name: "Didot", size: size)!}
    
    
    /**
    Returns the UIFont for SavoyeLetPlain of a particular size
    - parameter size: The size of the font
    */
    class func savoyeLetPlain(_ size: CGFloat) -> UIFont{return UIFont(name: "SavoyeLetPlain", size: size)!}
    
    
    /**
    Returns the UIFont for BodoniOrnamentsITCTT of a particular size
    - parameter size: The size of the font
    */
    class func bodoniOrnamentsITCTT(_ size: CGFloat) -> UIFont{return UIFont(name: "BodoniOrnamentsITCTT", size: size)!}
    
    
    /**
    Returns the UIFont for Symbol of a particular size
    - parameter size: The size of the font
    */
    class func symbol(_ size: CGFloat) -> UIFont{return UIFont(name: "Symbol", size: size)!}
    
    
    /**
    Returns the UIFont for Menlo-Italic of a particular size
    - parameter size: The size of the font
    */
    class func menloItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Menlo-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for Menlo-Bold of a particular size
    - parameter size: The size of the font
    */
    class func menloBold(_ size: CGFloat) -> UIFont{return UIFont(name: "Menlo-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Menlo-Regular of a particular size
    - parameter size: The size of the font
    */
    class func menloRegular(_ size: CGFloat) -> UIFont{return UIFont(name: "Menlo-Regular", size: size)!}
    
    
    /**
    Returns the UIFont for Menlo-BoldItalic of a particular size
    - parameter size: The size of the font
    */
    class func menloBoldItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "Menlo-BoldItalic", size: size)!}
    
    
    /**
    Returns the UIFont for BodoniSvtyTwoSCITCTT-Book of a particular size
    - parameter size: The size of the font
    */
    class func bodoniSvtyTwoSCITCTTBook(_ size: CGFloat) -> UIFont{return UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: size)!}
    
    
    /**
    Returns the UIFont for DINAlternate-Bold of a particular size
    - parameter size: The size of the font
    */
    class func dinAlternateBold(_ size: CGFloat) -> UIFont{return UIFont(name: "DINAlternate-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for Papyrus of a particular size
    - parameter size: The size of the font
    */
    class func papyrus(_ size: CGFloat) -> UIFont{return UIFont(name: "Papyrus", size: size)!}
    
    
    /**
    Returns the UIFont for Papyrus-Condensed of a particular size
    - parameter size: The size of the font
    */
    class func papyrusCondensed(_ size: CGFloat) -> UIFont{return UIFont(name: "Papyrus-Condensed", size: size)!}
    
    
    /**
    Returns the UIFont for EuphemiaUCAS-Italic of a particular size
    - parameter size: The size of the font
    */
    class func euphemiaUCASItalic(_ size: CGFloat) -> UIFont{return UIFont(name: "EuphemiaUCAS-Italic", size: size)!}
    
    
    /**
    Returns the UIFont for EuphemiaUCAS of a particular size
    - parameter size: The size of the font
    */
    class func euphemiaUCAS(_ size: CGFloat) -> UIFont{return UIFont(name: "EuphemiaUCAS", size: size)!}
    
    
    /**
    Returns the UIFont for EuphemiaUCAS-Bold of a particular size
    - parameter size: The size of the font
    */
    class func euphemiaUCASBold(_ size: CGFloat) -> UIFont{return UIFont(name: "EuphemiaUCAS-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for TeluguSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func teluguSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "TeluguSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for TeluguSangamMN-Bold of a particular size
    - parameter size: The size of the font
    */
    class func teluguSangamMNBold(_ size: CGFloat) -> UIFont{return UIFont(name: "TeluguSangamMN-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for BanglaSangamMN-Bold of a particular size
    - parameter size: The size of the font
    */
    class func banglaSangamMNBold(_ size: CGFloat) -> UIFont{return UIFont(name: "BanglaSangamMN-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for BanglaSangamMN of a particular size
    - parameter size: The size of the font
    */
    class func banglaSangamMN(_ size: CGFloat) -> UIFont{return UIFont(name: "BanglaSangamMN", size: size)!}
    
    
    /**
    Returns the UIFont for Zapfino of a particular size
    - parameter size: The size of the font
    */
    class func zapfino(_ size: CGFloat) -> UIFont{return UIFont(name: "Zapfino", size: size)!}
    
    
    /**
    Returns the UIFont for BodoniSvtyTwoOSITCTT-Book of a particular size
    - parameter size: The size of the font
    */
    class func bodoniSvtyTwoOSITCTTBook(_ size: CGFloat) -> UIFont{return UIFont(name: "BodoniSvtyTwoOSITCTT-Book", size: size)!}
    
    
    /**
    Returns the UIFont for BodoniSvtyTwoOSITCTT-Bold of a particular size
    - parameter size: The size of the font
    */
    class func bodoniSvtyTwoOSITCTTBold(_ size: CGFloat) -> UIFont{return UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: size)!}
    
    
    /**
    Returns the UIFont for BodoniSvtyTwoOSITCTT-BookIt of a particular size
    - parameter size: The size of the font
    */
    class func bodoniSvtyTwoOSITCTTBookIt(_ size: CGFloat) -> UIFont{return UIFont(name: "BodoniSvtyTwoOSITCTT-BookIt", size: size)!}
    
    
    /**
    Returns the UIFont for DINCondensed-Bold of a particular size
    - parameter size: The size of the font
    */
    class func dinCondensedBold(_ size: CGFloat) -> UIFont{return UIFont(name: "DINCondensed-Bold", size: size)!}
    
}
