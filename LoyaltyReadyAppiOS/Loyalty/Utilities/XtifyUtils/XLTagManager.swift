/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

public class XLTagManager {
    
    private var tagsChanged : Bool;
    private var recentTags : [XLTag];
    public static let sharedInstance = XLTagManager()
    
    init() {
        self.tagsChanged = false;
        self.recentTags  = [XLTag]();
    }
    
    /**
    Method to add tags to local recent tags, to be used later in server update
    
    - parameter tag: XLTag to add
    */
    func updatedTag(tag : XLTag) {
        self.recentTags.append(tag);
    }
    
    /**
    Method to update server with tags to be added and removed
    */
    func sendTagsToServerBulk() {
        if(!tagsChanged) {
            return;
        }
    
        let xtifyID : String? = XLappMgr.get().getXid();
        if let _ = xtifyID {
            let tagdic : [XLTag] = self.recentTags;
    
            var toBeTagged = [String]();
            var toBeUntagged = [String]();
            for tag in tagdic {
                if(tag.getIsSet()) {
                    toBeTagged.append(tag.getTagName());
                } else {
                    toBeUntagged.append(tag.getTagName());
                }
            }
    
            if(toBeTagged.count > 0) {
                XLappMgr.get().addTag(NSMutableArray(array: toBeTagged));
            }
            if(toBeUntagged.count > 0) {
                XLappMgr.get().unTag(NSMutableArray(array: toBeUntagged))
            }
            self.tagsChanged = false;
            self.recentTags  = [XLTag]();
        }
    }
    
    /**
    Method to notifiy XLTagManager that tags have been changed and should be updated later
    
    - parameter value: boolean to dermine if tags changed
    */
    func notifyTagsChanged(value : Bool){
        self.tagsChanged = value;
    }
    
    /**
    Simplified bulk tag update which sets an array of tags to be updated and then calls `sendTagsToServerBulk`
    
    - parameter tags:   array of tags in string format
    - parameter toKeep: if true, we are adding tags in array, if false, we are removing all tags in array
    */
    func updateWithTags(tags: [String], toKeep: Bool) {
        
        for tag in tags {
            MQALogger.log("tags: \(tag)")
            XLTagManager.sharedInstance.updatedTag(XLTag(tagName: tag, isSet: toKeep))
        }
        
        XLTagManager.sharedInstance.notifyTagsChanged(true)
        XLTagManager.sharedInstance.sendTagsToServerBulk()
        
    }
    
    /**
    Helper metho to simply reset all tags for this user on the Xtify servers
    */
    func resetRemoteTags() {
        XLappMgr.get().setTag(NSMutableArray())
    }
}