//
//  Noted.swift
//
//  Created by Kasper Welner on 09/03/15.
//  Copyright (c) 2015 Nodes. All rights reserved.
//

import Foundation

public protocol Notification {
    func trigger(reciever: AnyObject)
}

public class Noted {
    
    public static let defaultInstance = Noted()
    
    var receivers = NSHashTable(options: NSPointerFunctionsOptions.WeakMemory)
    
    public func addObserver(observer: AnyObject) {
        receivers.addObject(observer)
    }
    
    public func removeObserver(observer: AnyObject) {
        receivers.removeObject(observer)
    }
    
    public func postNotification(notification: Notification) {
        for receiver in receivers.allObjects {
            notification.trigger(receiver)
        }
    }
}
