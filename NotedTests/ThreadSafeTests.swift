//
//  ThreadSafeTests.swift
//  Noted
//
//  Created by Todor Brachkov on 09/09/2016.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
@testable import Noted

enum TestNotification {
    case TestUpdated
}

extension TestNotification: Notification {
    func trigger(reciever: AnyObject) {
//        print(reciever)
    }
}

class ThreadSafeTests: XCTestCase {
    
    var recieverStore : [NSObject] = []
    var notificationsCount : Int = 0
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.recieverStore = []
        self.notificationsCount = 0
    }
    
    func testThreadSafe() {
        
        for index in 0...300 {
            let controller = NSObject()
            recieverStore.append(recieverStore)
            let queue = dispatch_queue_create("com.noted.queue.\(index)", nil)
            dispatch_async(queue, {
                Noted.defaultInstance.addObserver(controller)
                Noted.defaultInstance.postNotification(TestNotification.TestUpdated)
            })
        }
        XCTAssert(true)
    }
}
