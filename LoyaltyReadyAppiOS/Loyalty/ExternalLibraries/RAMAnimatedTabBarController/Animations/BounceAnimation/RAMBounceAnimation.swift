//  RAMBounceAnimation.swift
//
// Copyright (c) 11/10/14 Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit


class RAMBounceAnimation : RAMItemAnimation {

    var startImage: UIImage?
    var selectedImage: UIImage?
    
    override func playAnimation(_ icon : UIImageView, textLabel : UILabel, selectedImage: UIImage) {
        startImage = icon.image
        self.selectedImage = selectedImage
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }

    override func deselectAnimation(_ icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
        textLabel.textColor = defaultTextColor
        icon.image = startImage
    }

    override func selectedState(_ icon : UIImageView, textLabel : UILabel, selectedImage: UIImage) {
        textLabel.textColor = textSelectedColor
        
        startImage = icon.image
        let renderImage = selectedImage.withRenderingMode(.alwaysTemplate)
        icon.image = renderImage
        icon.tintColor = UIColor.purpleLoyalty()
    }

    func playBounceAnimation(_ icon : UIImageView) {

        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = kCAAnimationCubic

        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
      
        let renderImage = selectedImage?.withRenderingMode(.alwaysTemplate)
        icon.image = renderImage
        icon.tintColor = UIColor.purpleLoyalty()
    }

}
