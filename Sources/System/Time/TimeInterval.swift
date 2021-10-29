/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// Time Interval
@frozen
public enum TimeInterval {
    
    case seconds(Time)
    case microseconds(Microseconds)
    case nanoseconds(Nanoseconds)
}

// MARK: - Time Conversion

public extension TimeInterval {
    
    /// Returns the seconds value of the time interval.
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
    
    /// Forceably converts a time interval to seconds precision.
    init(seconds other: TimeInterval) {
        self = .seconds(other.seconds)
    }
    
    /// Forceably converts a time interval to microseconds precision.
    init(microseconds other: TimeInterval) {
        self = .microseconds(.init(timeInverval: other))
    }
    
    /// Forceably converts a time interval to nanoseconds precision.
    init(nanoseconds other: TimeInterval) {
        self = .nanoseconds(.init(timeInverval: other))
    }
}

public extension TimeInterval.Microseconds {
    
    /// Forceably converts a time interval to microseconds precision.
    init(timeInverval: TimeInterval) {
        switch timeInverval {
        case let .seconds(seconds):
            self = .init(seconds: seconds, microseconds: 0)
        case let .microseconds(microseconds):
            self = microseconds
        case let .nanoseconds(nanoseconds):
            self = .init(seconds: nanoseconds.bytes.seconds)
        }
    }
}

public extension TimeInterval.Nanoseconds {
    
    /// Forceably converts a time interval to nanoseconds precision.
    init(timeInverval: TimeInterval) {
        switch timeInverval {
        case let .seconds(seconds):
            self = .init(seconds: seconds, nanoseconds: 0)
        case let .microseconds(microseconds):
            self = .init(seconds: microseconds.bytes.seconds)
        case let .nanoseconds(nanoseconds):
            self = nanoseconds
        }
    }
}

// MARK: - Get and Set Current Time

public extension TimeInterval {
    
    /// Returns the system time (since Unix epoch).
    static func timeInvervalSince1970(
        retryOnInterrupt: Bool = true
    ) throws -> TimeInterval {
        return try .microseconds(
            .timeInvervalSince1970(retryOnInterrupt: retryOnInterrupt)
        )
    }
    
    /// Sets the system time (since Unix epoch).
    func setTimeInvervalSince1970(
        _ timeInverval: TimeInterval,
        retryOnInterrupt: Bool = true
    ) throws {
        try Microseconds(timeInverval: self)
            .bytes
            .setTime(retryOnInterrupt: retryOnInterrupt)
            .get()
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
