//
//  Noted.swift
//
//  Created by Kasper Welner on 09/03/15.
//  Copyright (c) 2015 Nodes. All rights reserved.
//

import Foundation

public class Noted {
    
    public static let defaultInstance = Noted()
    
    private let notedQueue = DispatchQueue(label: "com.nodes.noted", attributes: .concurrent)
    internal var _observers = NSHashTable<AnyObject>(options: .weakMemory)

    internal static let passthroughFilter = PassthroughNoteFilter()

    public var observers: [NoteObserver] {
        var values: [AnyObject] = []
        notedQueue.sync {
            values = self._observers.allObjects
        }
        return values.compactMap({ $0 as? NoteObserver })
    }
    
    public init() {}
    
    public func add(observer: NoteObserver) {
        notedQueue.async(group: nil, qos: .default, flags: .barrier) {
            self._observers.add(observer)
        }
    }
    
    public func remove(observer: NoteObserver) {
        notedQueue.async(group: nil, qos: .default, flags: .barrier) {
            if let foundEntry = (self._observers.allObjects).first(where: {$0 === observer}) {
                self._observers.remove(foundEntry)
            }
        }
    }
    

    public func post(note: NoteType) {
        notedQueue.async {
            for receiver in self.observers.filter({ !$0.noteFilter.shouldFilter(note: note) }) {
                DispatchQueue.main.async {
                    receiver.didReceive(note: note)
                }
            }
        }
    }
}
