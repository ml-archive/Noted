//
//  NoteType.swift
//  Noted
//
//  Created by Dominik Hádl on 17/09/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

public protocol NoteType {
    var context: AnyObject? { get }
}

extension NoteType {
    public var context: AnyObject? {
        return nil
    }
}
