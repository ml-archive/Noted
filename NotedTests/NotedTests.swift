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
        Noted.defaultInstance.receivers.removeAllObjects()
        receiverStore = []
        TestNotification.testTriggerAction = nil
        super.tearDown()
    }

    func testAddObserver() {
        let observer = TestObserver()
        XCTAssertEqual(Noted.defaultInstance.receivers.count, 0,
                       "Noted shouldn't contain any receivers by default.")

        Noted.defaultInstance.addObserver(observer)

        let expectation = expectationWithDescription("Noted should contain a receiver after adding it.")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))

        dispatch_after(delayTime, dispatch_get_main_queue()) {
            XCTAssertEqual(Noted.defaultInstance.receivers.count, 1, "Noted should contain a receiver after adding it.")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testRemoveObserver() {
        let observer = TestObserver()

        Noted.defaultInstance.addObserver(observer)
        Noted.defaultInstance.removeObserver(observer)

        let expectation = expectationWithDescription("Noted shouldn't contain a receiver after removing  it.")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))

        dispatch_after(delayTime, dispatch_get_main_queue()) {
            XCTAssertEqual(Noted.defaultInstance.receivers.count, 0,
                           "Noted shouldn't contain a receiver after removing  it.")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testPostNotification() {
        let observer = TestObserver()
        let expectation = expectationWithDescription("A notification should be triggered.")

        TestNotification.testTriggerAction = { receiver in
            XCTAssert(observer === receiver, "The receiver of the notification should be the observer.")
            expectation.fulfill()
        }

        Noted.defaultInstance.addObserver(observer)
        Noted.defaultInstance.postNotification(TestNotification.Test)

        waitForExpectationsWithTimeout(20, handler: nil)
    }

    func testThreadSafety() {
        for index in 0...300 {
            let controller = TestObserver()
            receiverStore.append(controller)

            let queue = dispatch_queue_create("com.noted.queue.\(index)", nil)

            dispatch_async(queue, {
                Noted.defaultInstance.addObserver(controller)
                Noted.defaultInstance.postNotification(TestNotification.Test)
            })
        }

        XCTAssert(true)
    }
}
