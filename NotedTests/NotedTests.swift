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

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testPostNotification() {
        let observer = TestObserver()
        let expect = expectation(description: "A notification should be triggered.")

        observer.noteAction = { note in
            let test = note as? TestNote
            XCTAssert(test == TestNote.Test,
                      "The receiver of the notification should be the observer.")
            XCTAssertNil(test?.context, "Default note context should be nil .")
            expect.fulfill()
        }

        receiverStore.append(observer)

        Noted.defaultInstance.add(observer: observer)
        Noted.defaultInstance.post(note: TestNote.Test)

        waitForExpectations(timeout: 20, handler: nil)
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
}


extension DispatchTime {
    init(secondsFromNow seconds: Double) {
        let now   = DispatchTime.now().uptimeNanoseconds
        let delay = UInt64(seconds * Double(NSEC_PER_SEC))
        self.init(uptimeNanoseconds: now + delay)
    }
}
