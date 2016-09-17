//
//  TestObserver.swift
//  Noted
//
//  Created by Dominik Hádl on 14/09/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Noted

class TestObserver: NoteObserver {
    var noteAction: ((NoteType) -> Void)?
    
    func didReceive(note: NoteType) {
        noteAction?(note)
    }
}
