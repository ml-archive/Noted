//
//  NoteFilter.swift
//  Noted
//
//  Created by Dominik Hádl on 17/09/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

public protocol NoteFilter {
    func shouldFilter(note: NoteType) -> Bool
}

internal struct PassthroughNoteFilter: NoteFilter {
    internal func shouldFilter(note: NoteType) -> Bool {
        return false
    }
}
