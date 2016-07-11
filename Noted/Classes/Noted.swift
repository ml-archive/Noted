//
//  Noted.swift
//
//  Created by Kasper Welner on 09/03/15.
//  Copyright (c) 2015 Nodes. All rights reserved.
//

import Foundation

public protocol NotificationObserver : AnyObject {
    func didReceive(notification: Notification)
}

public protocol Notification {
    func trigger(_ receiver: AnyObject)
}

public protocol NotificationFilter {
    func shouldFilter(notification:Notification) -> Bool
}

internal struct PassthroughNotificationFilter : NotificationFilter {
    internal func shouldFilter(notification:Notification) -> Bool {
        return false
    }
}

private func ==(lhs: NotificationObserverInfo, rhs: NotificationObserverInfo) -> Bool { return lhs.receiver === rhs.receiver }

private final class NotificationObserverInfo: AnyObject, Equatable {
    
    let receiver:NotificationObserver
    let filter:NotificationFilter
    
    required init(receiver:NotificationObserver, filter: NotificationFilter) {
        self.receiver = receiver
        self.filter = filter
    }
}

public class Noted {
    
    public static let defaultInstance = Noted()
    
    private let notedQueue = DispatchQueue(label: "com.nodes.noted", attributes: .concurrent)
    
    private var _observers = NSHashTable<NotificationObserverInfo>(options: .weakMemory)
    
    public var receivers : [NotificationObserver] {
        return _observers.allObjects.map {$0.receiver}
    }
    
    private init() {}
    
    public func addObserver(_ observer: NotificationObserver, filter: NotificationFilter = PassthroughNotificationFilter()) {
        notedQueue.async(group: nil, qos: .default, flags: .barrier) {
            self._observers.add(NotificationObserverInfo(receiver: observer, filter: filter))
        }
    }
    
    public func removeObserver(_ observer: NotificationObserver) {
        notedQueue.async(group: nil, qos: .default, flags: .barrier) {
            if let foundEntry = (self._observers.allObjects).first(where: {$0.receiver === observer}) {
                self._observers.remove(foundEntry)
            }
        }
    }
    
    public func postNotification(_ notification: Notification) {
        notedQueue.async {
            for receiver in self._observers.allObjects {
                if !receiver.filter.shouldFilter(notification:notification) {
                    DispatchQueue.main.async {
                        notification.trigger(receiver)
                    }
                }
            }
        }
    }
}
