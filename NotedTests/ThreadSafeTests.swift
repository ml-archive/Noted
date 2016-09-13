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

extension TestNotification: NoteType {
    func trigger(_ receiver: AnyObject) {
//        print(reciever)
    }
}

class TestObserver: NoteObserver {
    func didReceive(note: NoteType) {
        
    }
}

class ThreadSafeTests: XCTestCase {
    
    var receiverStore : [TestObserver] = []
    var notificationsCount : Int = 0
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.receiverStore = []
        self.notificationsCount = 0
    }
    
    func testThreadSafe() {
        
        for index in 0...300 {
            let controller = TestObserver()
            receiverStore.append(controller)
            let queue = DispatchQueue(label:"com.noted.queue.\(index)")
            queue.async {
                Noted.defaultInstance.add(observer: controller)
                Noted.defaultInstance.post(note: TestNotification.TestUpdated)

            }
            
        }
        XCTAssert(true)
    }
}
