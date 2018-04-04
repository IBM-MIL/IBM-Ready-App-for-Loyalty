//  RAMTransitionItemAniamtions.swift
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

class RAMTransitionItemAniamtions : RAMItemAnimation {

    var transitionOptions : UIViewAnimationOptions!

    override init() {
        super.init()

        transitionOptions = UIViewAnimationOptions()
    }

    override func playAnimation(_ icon : UIImageView, textLabel : UILabel, selectedImage: UIImage) {

        selectedColor(icon, textLabel: textLabel)

        UIView.transition(with: icon, duration: TimeInterval(duration), options: transitionOptions, animations: {
            }, completion: { finished in
        })
    }

    override func deselectAnimation(_ icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {

        let renderImage = icon.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        icon.image = renderImage;
        textLabel.textColor = defaultTextColor
    }

    override func selectedState(_ icon : UIImageView, textLabel : UILabel, selectedImage: UIImage) {

        selectedColor(icon, textLabel: textLabel)
    }


    func selectedColor(_ icon : UIImageView, textLabel : UILabel) {

        if iconSelectedColor != nil {
            let renderImage = icon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            icon.image = renderImage
        }

        textLabel.textColor = textSelectedColor
    }
}

class RAMFlipLeftTransitionItemAniamtions : RAMTransitionItemAniamtions {

    override init() {
        super.init()

        transitionOptions = UIViewAnimationOptions.transitionFlipFromLeft
    }
}


class RAMFlipRightTransitionItemAniamtions : RAMTransitionItemAniamtions {

    override init() {
        super.init()

        transitionOptions = UIViewAnimationOptions.transitionFlipFromRight
    }
}

class RAMFlipTopTransitionItemAniamtions : RAMTransitionItemAniamtions {

    override init() {
        super.init()

        transitionOptions = UIViewAnimationOptions.transitionFlipFromTop
    }
}

class RAMFlipBottomTransitionItemAniamtions : RAMTransitionItemAniamtions {

    override init() {
        super.init()

        transitionOptions = UIViewAnimationOptions.transitionFlipFromBottom
    }
}
