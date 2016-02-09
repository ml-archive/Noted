//
//  NotificationCenter.swift
//  yPinion
//
//  Created by Kasper Welner on 09/03/15.
//  Copyright (c) 2015 Nodes. All rights reserved.
//

import Foundation

public protocol NONotification {
    func trigger(reciever:AnyObject)
}

public class NotificationCenter {
    
    public static let defaultCenter = NotificationCenter()
    
    var receivers = NSHashTable(options: NSPointerFunctionsOptions.WeakMemory)
    
    public func addObserver(observer: AnyObject) {
        receivers.addObject(observer)
    }
    
    public func removeObserver(observer: AnyObject) {
        receivers.removeObject(observer)
    }
    
    public func postNotification(notification:NONotification) {
        for receiver in receivers.allObjects {
            notification.trigger(receiver)
        }
    }
}