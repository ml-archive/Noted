//
//  TestObserver.swift
//  Noted
//
//  Created by Dominik Hádl on 14/09/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
@testable import Noted

class TestObserver: NoteObserver {
    var noteAction: ((NoteType) -> Void)?
    let noteFilter: NoteFilter

    init(filter: NoteFilter = PassthroughNoteFilter()) {
        self.noteFilter = filter
    }

    func didReceive(note: NoteType) {
        noteAction?(note)
    }
}

