//  AnimationTabBarController.swift
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

class RAMAnimatedTabBarItem: UITabBarItem {
    
    @IBOutlet weak var animation: RAMItemAnimation!
    @IBInspectable var textColor: UIColor = UIColor.purpleLoyalty()
    
    func playAnimation(_ icon: UIImageView, textLabel: UILabel, selectedImage: UIImage) {
        
        assert(animation != nil, "add animation in UITabBarItem")
        if animation != nil {
            animation.playAnimation(icon, textLabel: textLabel, selectedImage: selectedImage)
        }
    }
    
    func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {
        if animation != nil {
            animation.deselectAnimation(icon, textLabel: textLabel, defaultTextColor: textColor)
        }
    }
    
    func selectedState(_ icon: UIImageView, textLabel: UILabel, selectedImage: UIImage) {
        if animation != nil {
            animation.selectedState(icon, textLabel: textLabel, selectedImage: selectedImage)
        }
    }
}

class RAMAnimatedTabBarController: UITabBarController {
    typealias MyTuple = (icon: UIImageView, textLabel: UILabel, selectedImage: UIImage)
    var iconsView = [MyTuple]()
    
    // MARK: life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containers = createViewContainers()
        
        createCustomIcons(containers)
        
    }
    
    // MARK: create methods
    
    func createCustomIcons(_ containers : NSDictionary) {
        
        if let _ = tabBar.items {
            let itemsCount = tabBar.items!.count as Int - 1
            var index = 0
            for item in self.tabBar.items as! [RAMAnimatedTabBarItem] {
                assert(item.image != nil, "add image icon in UITabBarItem")
             
                
                let container : UIView = containers["container\(itemsCount-index)"] as! UIView
                container.tag = index
                
                let icon = UIImageView(image: item.image)
                icon.translatesAutoresizingMaskIntoConstraints = false
                
                let selectedImage = item.selectedImage
                
                // text
                let textLabel = UILabel()
                textLabel.text = item.title
                textLabel.backgroundColor = UIColor.clear
                textLabel.textColor = item.textColor
                textLabel.font = UIFont.systemFont(ofSize: 10)
                textLabel.textAlignment = NSTextAlignment.center
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                
                container.addSubview(icon)
                createConstraints(icon, container: container, size: item.image!.size, yOffset: 0)
                
                container.addSubview(textLabel)
                let textLabelWidth = tabBar.frame.size.width / CGFloat(tabBar.items!.count) - 5.0
                createConstraints(textLabel, container: container, size: CGSize(width: textLabelWidth , height: 10), yOffset: 16)
                
                iconsView.append((icon:icon, textLabel: textLabel, selectedImage: selectedImage!))
                
                if selectedIndex == index || 0 == index { // selected first elemet
                    item.selectedState(icon, textLabel: textLabel, selectedImage: selectedImage!)
                }
                
                item.image = nil
                item.title = ""
                index += 1
            }
        }
    }
    
    func createConstraints(_ view:UIView, container:UIView, size:CGSize, yOffset:CGFloat) {
        
        let constX = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: container,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 1,
            constant: 0)
        container.addConstraint(constX)
        
        let constY = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: container,
            attribute: NSLayoutAttribute.centerY,
            multiplier: 1,
            constant: yOffset)
        container.addConstraint(constY)
        
        let constW = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: size.width)
        view.addConstraint(constW)
        
        let constH = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: size.height)
        view.addConstraint(constH)
    }
    
    func createViewContainers() -> NSDictionary {
        
        var containersDict = [String: AnyObject]()
        let itemsCount : Int = tabBar.items!.count as Int - 1
        
        for index in 0...itemsCount {
            let viewContainer = createViewContainer()
            containersDict["container\(index)"] = viewContainer
        }
                
        var formatString = "H:|-(0)-[container0]"
        for index in 1...itemsCount {
            formatString += "-(0)-[container\(index)(==container0)]"
        }
        formatString += "-(0)-|"
        let constranints = NSLayoutConstraint.constraints(withVisualFormat: formatString,
            options:NSLayoutFormatOptions.directionRightToLeft,
            metrics: nil,
            views: containersDict)
        view.addConstraints(constranints)
        
        return containersDict as NSDictionary
    }
    
    func createViewContainer() -> UIView {
        let viewContainer = UIView();
        viewContainer.backgroundColor = UIColor.clear // for test
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        // add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RAMAnimatedTabBarController.tapHandler(_:)))
        tapGesture.numberOfTouchesRequired = 1
        viewContainer.addGestureRecognizer(tapGesture)
        
        // add constrains
        let constY = NSLayoutConstraint(item: viewContainer,
            attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: NSLayoutAttribute.bottom,
            multiplier: 1,
            constant: 0)
        
        view.addConstraint(constY)
        
        let constH = NSLayoutConstraint(item: viewContainer,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: tabBar.frame.size.height)
        viewContainer.addConstraint(constH)
        
        return viewContainer
    }
    
    // MARK: actions
    
    func tapHandler(_ gesture:UIGestureRecognizer) {
        
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        
        let currentIndex = gesture.view!.tag
        if selectedIndex != currentIndex {
            let animationItem : RAMAnimatedTabBarItem = items[currentIndex]
            let icon = iconsView[currentIndex].icon
            let selectedImage = iconsView[currentIndex].selectedImage
            let textLabel = iconsView[currentIndex].textLabel
            animationItem.playAnimation(icon, textLabel: textLabel, selectedImage: selectedImage)
            
            let deselelectIcon = iconsView[selectedIndex].icon
            let deselelectTextLabel = iconsView[selectedIndex].textLabel
            let deselectItem = items[selectedIndex]
            deselectItem.deselectAnimation(deselelectIcon, textLabel: deselelectTextLabel)
            
            //This line was added to remove a modal view (specifically the loyalty card modal) on tab switch
            self.selectedViewController?.dismiss(animated: false, completion: nil)
            
            selectedIndex = gesture.view!.tag
            
        } else if selectedIndex == currentIndex {

            // If user selects selectedIndex, pop to root if possible
            if let navVC = self.viewControllers![selectedIndex] as? UINavigationController {
                navVC.popToRootViewController(animated: true)
            }
        }
    }
    
    func setSelectIndex(from:Int,to:Int) {
        self.selectedIndex = to
        let items = self.tabBar.items as! [RAMAnimatedTabBarItem]
        items[from].deselectAnimation(iconsView[from].icon, textLabel: iconsView[from].textLabel)
        items[to].playAnimation(iconsView[to].icon, textLabel: iconsView[to].textLabel, selectedImage: iconsView[to].selectedImage)
    }
}


