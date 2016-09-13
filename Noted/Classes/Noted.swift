//
//  Noted.swift
//
//  Created by Kasper Welner on 09/03/15.
//  Copyright (c) 2015 Nodes. All rights reserved.
//

import Foundation

public protocol NoteObserver: AnyObject {
    func didReceive(note: NoteType)
}

public protocol NoteType {
    func trigger(_ receiver: AnyObject)
}

public protocol NoteFilter {
    func shouldFilter(note: NoteType) -> Bool
}

internal struct PassthroughNoteFilter: NoteFilter {
    internal func shouldFilter(note: NoteType) -> Bool {
        return false
    }
}

private func ==(lhs: NoteObserverInfo, rhs: NoteObserverInfo) -> Bool { return lhs.receiver === rhs.receiver }

private final class NoteObserverInfo: AnyObject, Equatable {
    
    let receiver: NoteObserver
    let filter:NoteFilter
    
    required init(receiver: NoteObserver, filter: NoteFilter) {
        self.receiver = receiver
        self.filter = filter
    }
}

public class Noted {
    
    public static let defaultInstance = Noted()
    

    private let notedQueue = DispatchQueue(label: "com.nodes.noted", attributes: .concurrent)
    
    private var _observers = NSHashTable<NoteObserverInfo>(options: .weakMemory)
    
    public var receivers : [NoteObserver] {
        return _observers.allObjects.map {$0.receiver}
    }
    

    private init() {}
    
    public func addObserver(_ observer: NoteObserver, filter: NoteFilter = PassthroughNoteFilter()) {
        notedQueue.async(group: nil, qos: .default, flags: .barrier) {
            self._observers.add(NoteObserverInfo(receiver: observer, filter: filter))
        }
    }
    
    public func removeObserver(_ observer: NoteObserver) {
        notedQueue.async(group: nil, qos: .default, flags: .barrier) {
            if let foundEntry = (self._observers.allObjects).first(where: {$0.receiver === observer}) {
                self._observers.remove(foundEntry)
            }
        }
    }
    
    public func postNote(_ note: NoteType) {
        notedQueue.async {
            for receiver in self._observers.allObjects {
                if !receiver.filter.shouldFilter(note:note) {
                    DispatchQueue.main.async {
                        note.trigger(receiver)
                    }
                }

            }
        }
    }
}
