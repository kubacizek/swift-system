/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

public extension TimeInterval {
    
    /// POSIX Time
    @frozen
    struct Nanoseconds: Equatable, Hashable, Codable {
        
        public var seconds: Time
        
        public var nanoseconds: Time.Nanoseconds
        
        public init(seconds: Time, nanoseconds: Time.Nanoseconds) {
            self.seconds = seconds
            self.nanoseconds = nanoseconds
        }
    }
}

public extension TimeInterval.Nanoseconds {
    
    init(seconds: Double) {
        self.init(.init(seconds: seconds))
    }
}

// MARK: - CustomStringConvertible

extension TimeInterval.Nanoseconds: CustomStringConvertible {
    
    public var description: String {
        return "\(seconds)s \(nanoseconds)ns"
    }
}

internal extension TimeInterval.Nanoseconds {
    
    @usableFromInline
    init(_ bytes: CInterop.TimeIntervalNanoseconds) {
        self.seconds = .init(rawValue: bytes.tv_sec)
        self.nanoseconds = .init(rawValue: bytes.tv_nsec)
    }
    
    @usableFromInline
    var bytes: CInterop.TimeIntervalNanoseconds {
        .init(tv_sec: seconds.rawValue, tv_nsec: nanoseconds.rawValue)
    }
}
