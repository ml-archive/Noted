//
//  TestNote.swift
//  Noted
//
//  Created by Dominik Hádl on 14/09/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Noted

enum TestNote {
    case Test
}

extension TestNote: NoteType {
    static var testTriggerAction: ((AnyObject) -> Void)?

    func trigger(_ receiver: AnyObject) {
        TestNote.testTriggerAction?(receiver)
    }
}
