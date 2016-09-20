//
//  Noted.swift
//
//  Created by Kasper Welner on 09/03/15.
//  Copyright (c) 2015 Nodes. All rights reserved.
//

import Foundation

public protocol Notification {
    func trigger(receiver: AnyObject)
}

public class Noted {
    
    public static let defaultInstance = Noted()

    private let notedQueue = dispatch_queue_create("com.nodes.queue", DISPATCH_QUEUE_CONCURRENT)
    internal var receivers = NSHashTable(options: .WeakMemory)

    private init() {}
    
    public func addObserver(observer: AnyObject) {
        dispatch_barrier_async(notedQueue) { [weak self] in
            self?.receivers.addObject(observer)
        }
    }
    
    public func removeObserver(observer: AnyObject) {
        dispatch_barrier_async(notedQueue) { [weak self] in
            self?.receivers.removeObject(observer)
        }
    }
    
    public func postNotification(notification: Notification) {
        dispatch_async(notedQueue) {
            for receiver in self.receivers.allObjects {
                dispatch_async(dispatch_get_main_queue()) {
                    notification.trigger(receiver)
                }
            }
        }
    }
}
