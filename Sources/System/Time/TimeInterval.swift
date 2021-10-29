/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

@frozen
public enum TimeInterval {
    
    case seconds(Time)
    case microseconds(Time, Time.Microseconds)
    case nanoseconds(Time, Time.Nanoseconds)
}

public extension TimeInterval {
    
    init(_ cTime: CInterop.TimeIntervalMicroseconds) {
        self = .microseconds(
            .init(rawValue: cTime.tv_sec),
            .init(rawValue: cTime.tv_usec)
        )
    }
    
    init(_ cTime: CInterop.TimeIntervalNanoseconds) {
        self = .nanoseconds(
            .init(rawValue: cTime.tv_sec),
            .init(rawValue: cTime.tv_nsec)
        )
    }
}

// MARK: - CustomStringConvertible

extension TimeInterval: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case let .seconds(seconds):
            return "\(seconds)s"
        case let .microseconds(seconds, microseconds):
            return "\(seconds)s \(microseconds)µs"
        case let .nanoseconds(seconds, nanoseconds):
            return "\(seconds)s \(nanoseconds)ns"
        }
    }
}
