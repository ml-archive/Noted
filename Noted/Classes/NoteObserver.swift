//
//  NoteObserver.swift
//  Noted
//
//  Created by Dominik Hádl on 17/09/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

public protocol NoteObserver: AnyObject {
    func didReceive(note: NoteType)
    var noteFilter: NoteFilter { get }
}

extension NoteObserver {
    public var noteFilter: NoteFilter {
        return Noted.passthroughFilter
    }
}
