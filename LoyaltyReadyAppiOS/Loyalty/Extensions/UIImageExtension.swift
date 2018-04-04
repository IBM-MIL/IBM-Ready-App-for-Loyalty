/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation
import AVFoundation
import UIKit

//Custom images for the project
extension UIImage{
    
    //Fans
    
    class func fanCoolImage() ->UIImage {
        return UIImage(named: "fan_on_cool")!
    }
    
    class func fanHeatImage() ->UIImage {
        return UIImage(named: "fan_on_heat")!
    }
    
    class func fanHeatCoolImage() ->UIImage {
        return UIImage(named: "fan_on_heat_cool")!
    }
    
    class func fanDisabled() ->UIImage {
        return UIImage(named: "fan_disabled")!
    }
    
    //Up Arrows
    
    class func upButtonArrowBlue() ->UIImage {
        return UIImage(named: "up_button_arrow_blue")!
    }
    
    class func upButtonArrowPurple() ->UIImage {
        return UIImage(named: "up_button_arrow_purple")!
    }
    
    class func upButtonArrowRed() ->UIImage {
        return UIImage(named: "up_button_arrow_red")!
    }
    
    //Down Arrows
    
    class func downButtonArrowBlue() ->UIImage {
        return UIImage(named: "down_button_arrow_blue")!
    }
    
    class func downButtonArrowPurple() ->UIImage {
        return UIImage(named: "down_button_arrow_purple")!
    }
    
    class func downButtonArrowRed() ->UIImage {
        return UIImage(named: "down_button_arrow_red")!
    }
}

extension UIImage{
    func croppedImage(_ bound : CGRect) -> UIImage
    {
        let scaledBounds : CGRect = CGRect(x: bound.origin.x * scale, y: bound.origin.y * scale, width: bound.size.width * scale, height: bound.size.height * scale)
        let imageRef = cgImage!.cropping(to: scaledBounds)
        let croppedImage : UIImage = UIImage(cgImage: imageRef!, scale: scale, orientation: UIImageOrientation.up)
        return croppedImage
    }
    
    /**
    Creates an image from a video. Created with help from http://stackoverflow.com/questions/8906004/thumbnail-image-of-video/8906104#8906104
    
    - parameter videoURL: The url of the video to grab an image from
    
    - returns: The thumbnail image
    */
    class func getThumbnailFromVideo(_ videoURL: URL) -> UIImage {
        let asset: AVURLAsset = AVURLAsset(url: videoURL, options: nil)
        let imageGen: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        imageGen.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0, 600)
        let image: CGImage = try! imageGen.copyCGImage(at: time, actualTime: nil)
        let thumbnail: UIImage = UIImage(cgImage: image)
        
        return thumbnail
    }
    
    /**
    Create an image of a given color
    
    - parameter color:  The color that the image will have
    - parameter width:  Width of the returned image
    - parameter height: Height of the returned image
    
    - returns: An image with the color, height and width
    */
    class func imageWithColor(_ color: UIColor, width: CGFloat, height: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
    Method to perform crop based on square inside app frame
    
    - parameter view: the view image was capture in
    - parameter square: the crop square over the image
    - parameter fromCam: determine how to handle the passed in image
    
    - returns: UIImage - the cropped image
    */
    func cropImageInView(_ view: UIView, square: CGRect, fromCam: Bool) -> UIImage {
        let cropSquare: CGRect
        let frameWidth = view.frame.size.width
        let imageHeight = size.height
        let imageWidth = size.width
        
        // "if" creates a square from cameraroll image, else creates square from square frame in camera
        if !fromCam {
            
            let edge: CGFloat
            if imageWidth > imageHeight {
                edge = imageHeight
            } else {
                edge = imageWidth
            }
            
            let posX = (imageWidth  - edge) / 2.0
            let posY = (imageHeight - edge) / 2.0
            
            cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)
            
        } else {
            
            let imageScale: CGFloat!
            imageScale = imageWidth / frameWidth
            // x and y are switched because image has -90 degrees rotation by default
            cropSquare = CGRect(x: square.origin.y * imageScale, y: square.origin.x * imageScale, width: square.size.width * imageScale, height: square.size.height * imageScale)
        }
        
        let imageRef = cgImage!.cropping(to: cropSquare)
        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: imageOrientation)
    }
}
