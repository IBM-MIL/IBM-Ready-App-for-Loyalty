//  RAMRotationAnimation.swift
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
import QuartzCore

enum RAMRotationDirection {
    case left
    case right
}

class RAMRotationAnimation : RAMItemAnimation {

    var direction : RAMRotationDirection!

    override func playAnimation(_ icon : UIImageView, textLabel : UILabel, selectedImage: UIImage) {
        playRoatationAnimation(icon)
        textLabel.textColor = textSelectedColor
    }

    override func deselectAnimation(_ icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
        textLabel.textColor = defaultTextColor
      
        let renderImage = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.image = renderImage
        icon.tintColor = defaultTextColor
    }

    override func selectedState(_ icon : UIImageView, textLabel : UILabel, selectedImage: UIImage) {
        textLabel.textColor = textSelectedColor
      
        let renderImage = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.image = renderImage
        icon.tintColor = textSelectedColor
    }

    func playRoatationAnimation(_ icon : UIImageView) {

        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0

        var toValue = CGFloat(M_PI * 2.0)
        if direction != nil && direction == RAMRotationDirection.left {
            toValue = toValue * -1.0
        }

        rotateAnimation.toValue = toValue
        rotateAnimation.duration = TimeInterval(duration)

        icon.layer.add(rotateAnimation, forKey: "rotation360")
      
        let renderImage = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.image = renderImage
        icon.tintColor = iconSelectedColor
    }
}

class RAMLeftRotationAnimation : RAMRotationAnimation {

    override init() {
        super.init()
        direction = RAMRotationDirection.left
    }
}


class RAMRightRotationAnimation : RAMRotationAnimation {

    override init() {
        super.init()
        direction = RAMRotationDirection.right
    }
}


