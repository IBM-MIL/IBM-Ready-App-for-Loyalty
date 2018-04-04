
//  RAMFumeAnimation.swift
//
// Copyright (c) 12/2/14 Ramotion Inc. (http://ramotion.com)
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


class RAMFumeAnimation : RAMItemAnimation {

    override func playAnimation(_ icon : UIImageView, textLabel : UILabel, selectedImage: UIImage) {
        playMoveIconAnimation(icon, values:[icon.center.y as AnyObject, icon.center.y + 4.0 as AnyObject])
        playLabelAnimation(textLabel)
        textLabel.textColor = textSelectedColor
      
        let renderImage = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.image = renderImage
        icon.tintColor = textSelectedColor
    }

    override func deselectAnimation(_ icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
        playMoveIconAnimation(icon, values:[icon.center.y + 4.0 as AnyObject, icon.center.y as AnyObject])
        playDeselectLabelAnimation(textLabel)
        textLabel.textColor = defaultTextColor
      
        let renderImage = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.image = renderImage
        icon.tintColor = defaultTextColor
    }

    override func selectedState(_ icon : UIImageView, textLabel : UILabel, selectedImage: UIImage) {

        playMoveIconAnimation(icon, values:[icon.center.y + 8.0 as AnyObject])
        textLabel.alpha = 0
        textLabel.textColor = textSelectedColor
      
        let renderImage = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.image = renderImage
        icon.tintColor = textSelectedColor
    }

    func playMoveIconAnimation(_ icon : UIImageView, values: [AnyObject]) {

        let yPositionAnimation = createAnimation("position.y", values:values, duration:duration / 2)

        icon.layer.add(yPositionAnimation, forKey: "yPositionAnimation")
    }

    // MARK: select animation

    func playLabelAnimation(_ textLabel: UILabel) {

        let yPositionAnimation = createAnimation("position.y", values:[textLabel.center.y as AnyObject, textLabel.center.y - 60.0 as AnyObject], duration:duration)
        yPositionAnimation.fillMode = kCAFillModeRemoved
        yPositionAnimation.isRemovedOnCompletion = true
        textLabel.layer.add(yPositionAnimation, forKey: "yLabelPostionAnimation")

        let scaleAnimation = createAnimation("transform.scale", values:[1.0 as AnyObject ,2.0 as AnyObject], duration:duration)
        scaleAnimation.fillMode = kCAFillModeRemoved
        scaleAnimation.isRemovedOnCompletion = true
        textLabel.layer.add(scaleAnimation, forKey: "scaleLabelAnimation")

        let opacityAnimation = createAnimation("opacity", values:[1.0 as AnyObject ,0.0 as AnyObject], duration:duration)
        textLabel.layer.add(opacityAnimation, forKey: "opacityLabelAnimation")
    }

    func createAnimation(_ keyPath: String, values: [AnyObject], duration: CGFloat)->CAKeyframeAnimation {
      
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.values = values
        animation.duration = TimeInterval(duration)
        animation.calculationMode = kCAAnimationCubic
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        return animation
    }

    // MARK: deselect animation

    func playDeselectLabelAnimation(_ textLabel: UILabel) {
      
        let yPositionAnimation = createAnimation("position.y", values:[textLabel.center.y + 15 as AnyObject, textLabel.center.y as AnyObject], duration:duration)
        textLabel.layer.add(yPositionAnimation, forKey: "yLabelPostionAnimation")

        let opacityAnimation = createAnimation("opacity", values:[0 as AnyObject, 1 as AnyObject], duration:duration)
        textLabel.layer.add(opacityAnimation, forKey: "opacityLabelAnimation")
    }

}
