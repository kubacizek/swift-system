/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

public extension TimeInterval {
    
    /// POSIX Time
    @frozen
    struct Microseconds: Equatable, Hashable, Codable {
        
        public var seconds: Time
        
        public var microseconds: Time.Microseconds
        
        public init(seconds: Time, microseconds: Time.Microseconds) {
            self.seconds = seconds
            self.microseconds = microseconds
        }
    }
}

public extension TimeInterval.Microseconds {
    
    init(seconds: Double) {
        self.init(.init(seconds: seconds))
    }
}

// MARK: - CustomStringConvertible

extension TimeInterval.Microseconds: CustomStringConvertible {
    
    public var description: String {
        "\(seconds)s \(microseconds)µs"
    }
}

public extension TimeInterval.Microseconds {
    
    static func timeInvervalSince1970(
        retryOnInterrupt: Bool = true
    ) throws -> TimeInterval.Microseconds {
        return try .init(._getTime(retryOnInterrupt: retryOnInterrupt).get())
    }
    
    func setTimeInvervalSince1970(
        _ timeInverval: TimeInterval.Microseconds,
        retryOnInterrupt: Bool = true
    ) throws {
        
    }
}

internal extension TimeInterval.Microseconds {
    
    @usableFromInline
    init(_ bytes: CInterop.TimeIntervalMicroseconds) {
        self.seconds = .init(rawValue: bytes.tv_sec)
        self.microseconds = .init(rawValue: bytes.tv_usec)
    }
    
    @usableFromInline
    var bytes: CInterop.TimeIntervalMicroseconds {
        .init(tv_sec: seconds.rawValue, tv_usec: microseconds.rawValue)
    }
}

internal extension CInterop.TimeIntervalMicroseconds {
    
    @usableFromInline
    static func _getTime(retryOnInterrupt: Bool) -> Result<CInterop.TimeIntervalMicroseconds, Errno> {
        var time = CInterop.TimeIntervalMicroseconds()
        return nothingOrErrno(retryOnInterrupt: retryOnInterrupt) {
            // The use of the timezone structure is obsolete; the tz argument
            // should normally be specified as NULL.
            system_gettimeofday(&time, nil)
        }.map { time }
    }
    
    func _setTime(retryOnInterrupt: Bool) -> Result<(), Errno> {
        withUnsafePointer(to: self) { time in
            nothingOrErrno(retryOnInterrupt: retryOnInterrupt) {
                system_settimeofday(time, nil)
            }
        }
    }
}
