//
//  NotedTests.swift
//  NotedTests
//
//  Created by Chris Combs on 09/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
@testable import Noted

class NotedTests: XCTestCase {

    // Used for having strong reference to objects
    var receiverStore: [TestObserver] = []

    override func tearDown() {
        Noted.defaultInstance._observers.removeAllObjects()
        receiverStore = []
        super.tearDown()
    }

    func testAddRemoveObserver() {
        let observer = TestObserver()
        receiverStore.append(observer)

        let expect = expectation(description: "Noted should finish adding and removing receiver.")

        XCTAssertEqual(Noted.defaultInstance.observers.count, 0,
                       "Noted shouldn't contain any receivers by default.")

        Noted.defaultInstance.add(observer: observer)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime(secondsFromNow: 0.5)) {
            XCTAssertEqual(Noted.defaultInstance.observers.count, 1,
                           "Noted should contain a receiver after adding it.")

            Noted.defaultInstance.remove(observer: observer)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime(secondsFromNow: 0.5)) {
                XCTAssertEqual(Noted.defaultInstance.observers.count, 0,
                               "Noted shouldn't contain a receiver after removing  it.")
                expect.fulfill()
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testPostNotification() {
        let observer = TestObserver()
        let expect = expectation(description: "A notification should be triggered.")

        observer.noteAction = { note in
            let test = note as? TestNote
            XCTAssert(test == TestNote.Test,
                      "The receiver of the notification should be the observer.")
            expect.fulfill()
        }

        receiverStore.append(observer)

        Noted.defaultInstance.add(observer: observer)
        Noted.defaultInstance.post(note: TestNote.Test)

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testThreadSafety() {
        for index in 0...300 {
            let controller = TestObserver()
            receiverStore.append(controller)

            let queue = DispatchQueue(label: "com.noted.queue.\(index)")

            queue.async {
                Noted.defaultInstance.add(observer: controller)
                Noted.defaultInstance.post(note: TestNote.Test)
            }
        }
        
        XCTAssert(true)
    }
    
    func testFilter() {
        let notedInstance = Noted()
        let observer      = TestObserver(filter: TestFilter())
        let expect        = expectation(description: "Notification should be filtered out.")
        
        observer.noteAction = { note in            
            XCTAssert(false,
                      "No notification should be received.")
            
            notedInstance.remove(observer:observer)
        }

        receiverStore.append(observer)
        
        notedInstance.add(observer: observer)
        notedInstance.post(note: TestNote.Test)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}


extension DispatchTime {
    init(secondsFromNow seconds: Double) {
        let now   = DispatchTime.now().uptimeNanoseconds
        let delay = UInt64(seconds * Double(NSEC_PER_SEC))
        self.init(uptimeNanoseconds: now + delay)
    }
}
