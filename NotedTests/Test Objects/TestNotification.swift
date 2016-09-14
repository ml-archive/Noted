//
//  TestNotification.swift
//  Noted
//
//  Created by Dominik Hádl on 14/09/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Noted

enum TestNotification {
    case Test
}

extension TestNotification: Notification {
    static var testTriggerAction: ((AnyObject) -> Void)?

    func trigger(receiver: AnyObject) {
        TestNotification.testTriggerAction?(receiver)
    }
}