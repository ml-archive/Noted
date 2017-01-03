//
//  TestFilter.swift
//  Noted
//
//  Created by Kasper Welner on 04/01/2017.
//  Copyright © 2017 Nodes. All rights reserved.
//

import Foundation
import Noted

struct TestFilter : NoteFilter {
    func shouldFilter(note: NoteType) -> Bool {
        return false
    }
}
