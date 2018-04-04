//
//  OCLogger.swift
//  Loyalty
//
//  Created by Devipriya on 3/20/18.
//  Copyright © 2018 ibm. All rights reserved.
//

import Foundation
extension OCLogger {
    //Log methods with no metadata
    
    func logTraceWithMessages(message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_TRACE, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logDebugWithMessages(message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_DEBUG, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logInfoWithMessages(message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_INFO, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logWarnWithMessages(message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_WARN, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logErrorWithMessages(message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_ERROR, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logFatalWithMessages(message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_FATAL, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logAnalyticsWithMessages(message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_ANALYTICS, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    //Log methods with metadata
    
    func logTraceWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_TRACE, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logDebugWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_DEBUG, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logInfoWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_INFO, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logWarnWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_WARN, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logErrorWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_ERROR, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logFatalWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_FATAL, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logAnalyticsWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArg...) {
        log(withLevel: OCLogger_ANALYTICS, message: message, args:getVaList(args), userInfo:userInfo)
    }
}

