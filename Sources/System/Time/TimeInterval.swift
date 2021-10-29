/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

@frozen
public enum TimeInterval {
    
    case seconds(Time)
    case microseconds(Microseconds)
    case nanoseconds(Nanoseconds)
}

public extension TimeInterval {
    
    var seconds: Time {
        switch self {
        case let .seconds(time):
            return time
        case let .microseconds(value):
            return value.seconds
        case let .nanoseconds(value):
            return value.seconds
        }
    }
    
    init(microseconds other: TimeInterval) {
        switch other {
        case let .seconds(seconds):
            self = .microseconds(.init(seconds: seconds, microseconds: 0))
        case let .microseconds(microseconds):
            self = .microseconds(microseconds)
        case let .nanoseconds(nanoseconds):
            self = .microseconds(.init(seconds: nanoseconds.bytes.seconds))
        }
    }
    
    init(nanoseconds other: TimeInterval) {
        switch other {
        case let .seconds(seconds):
            self = .nanoseconds(.init(seconds: seconds, nanoseconds: 0))
        case let .microseconds(microseconds):
            self = .nanoseconds(.init(seconds: microseconds.bytes.seconds))
        case let .nanoseconds(nanoseconds):
            self = .nanoseconds(nanoseconds)
        }
    }
}

// MARK: - CustomStringConvertible

extension TimeInterval: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case let .seconds(seconds):
            return "\(seconds)s"
        case let .microseconds(microseconds):
            return microseconds.description
        case let .nanoseconds(nanoseconds):
            return nanoseconds.description
        }
    }
}
