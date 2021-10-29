/*
 This source file is part of the Swift System open source project

 Copyright (c) 2020 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

import XCTest

#if SYSTEM_PACKAGE
@testable import SystemPackage
#else
@testable import System
#endif

final class TimeTest: XCTestCase {
    
    func testTime() {
        XCTAssertEqual(Time.zero, 0)
        XCTAssertEqual(Time.min, Time(rawValue: .min))
        XCTAssertEqual(Time.max, Time(rawValue: .max))
        XCTAssertEqual(Time.init(rawValue: 1).description, "1")
    }
    
    func testMicroseconds() {
        XCTAssertEqual(Time.Microseconds.zero, 0)
        XCTAssertEqual(Time.Microseconds.min, Time.Microseconds(rawValue: .min))
        XCTAssertEqual(Time.Microseconds.max, Time.Microseconds(rawValue: .max))
        XCTAssertEqual(Time.Microseconds.init(rawValue: 1).description, "1")
    }
    
    func testNanoseconds() {
        XCTAssertEqual(Time.Nanoseconds.zero, 0)
        XCTAssertEqual(Time.Nanoseconds.min, Time.Nanoseconds(rawValue: .min))
        XCTAssertEqual(Time.Nanoseconds.max, Time.Nanoseconds(rawValue: .max))
        XCTAssertEqual(Time.Nanoseconds.init(rawValue: 1).description, "1")
    }
    
    func testProcessorTime() {
        XCTAssertNotEqual(ProcessorTime.current, 0)
        XCTAssertGreaterThan(ProcessorTime.current, 0)
        XCTAssertEqual(ProcessorTime(rawValue: 1).description, "1")
        XCTAssertEqual(ProcessorTime(seconds: 2.0), 2_000_000)
        XCTAssertEqual(ProcessorTime(seconds: 2.5).seconds, 2.5)
        XCTAssertEqual(ProcessorTime(seconds: 3.5) - ProcessorTime(seconds: 2.0), ProcessorTime(seconds: 1.5))
        XCTAssertEqual(ProcessorTime(seconds: 1.5) + ProcessorTime(seconds: 2.0), ProcessorTime(seconds: 3.5))
    }
    
    func testTimeInterval() {
        XCTAssertNoThrow({ try TimeInterval.timeInvervalSince1970() })
        XCTAssertEqual(TimeInterval.seconds(10).description, "10s")
        XCTAssertEqual(TimeInterval.microseconds(.init(seconds: 1, microseconds: 12345)).description, "1s 12345µs")
        XCTAssertEqual(TimeInterval.nanoseconds(.init(seconds: 1, nanoseconds: 12345)).description, "1s 12345ns")
    }
    
    func testClock() {
        XCTAssertEqual(Clock.realtime.description, "Clock.realtime")
        XCTAssertEqual(try! Clock.realtime.precision(), .init(seconds: 0, nanoseconds: 1000))
        XCTAssertEqual(try! Clock.monotonic.precision(), .init(seconds: 0, nanoseconds: 1000))
        XCTAssertNotEqual(try! Clock.realtime.time(), .zero)
    }
}
