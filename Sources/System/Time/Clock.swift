/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// Type capable of representing the processor time used by a process.
@frozen
public struct Clock: RawRepresentable, Equatable, Hashable, Codable {
    
    public var rawValue: CInterop.Clock
    
    public init(rawValue: CInterop.Clock) {
        self.rawValue = rawValue
    }
}

public extension Clock {
    
    /// Returns the approximate processor time used by the process
    /// since the beginning of an implementation-defined era related to the program's execution.
    static var current: Clock {
        return .init(rawValue: system_clock())
    }
}

public extension Clock {
    
    init(seconds: Double) {
        self.init(rawValue: .init(seconds * Double(_CLOCKS_PER_SEC)))
    }
    
    var seconds: Double {
        return Double(rawValue) / Double(_CLOCKS_PER_SEC)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Clock: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: RawValue) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension Clock: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return rawValue.description
    }
    
    public var debugDescription: String {
        return description
    }
}

// MARK: - Clock ID

public extension Clock {
    
    /// Clock ID
    struct ID: RawRepresentable, Equatable, Hashable, Codable {
        
        public let rawValue: CInterop.ClockID.RawValue
        
        @_alwaysEmitIntoClient
        public init(rawValue: CInterop.ClockID.RawValue) {
            self.rawValue = rawValue
        }
        
        @_alwaysEmitIntoClient
        private init(_ bytes: CInterop.ClockID) {
            self.init(rawValue: bytes.rawValue)
        }
    }
}

public extension Clock.ID {
    
    /// System-wide realtime clock. Setting this clock requires appropriate privileges.
    @available(macOS 10.12, *)
    @_alwaysEmitIntoClient
    static var realtime: Clock.ID { Clock.ID(_CLOCK_REALTIME) }
    
    /// Clock that cannot be set and represents monotonic time since some unspecified starting point.
    @available(macOS 10.12, *)
    @_alwaysEmitIntoClient
    static var monotonic: Clock.ID { Clock.ID(_CLOCK_MONOTONIC) }
    
    /// High-resolution per-process timer from the CPU.
    @available(macOS 10.12, *)
    @_alwaysEmitIntoClient
    static var processCPUTime: Clock.ID { Clock.ID(_CLOCK_PROCESS_CPUTIME_ID) }
    
    /// Thread-specific CPU-time clock.
    @available(macOS 10.12, *)
    @_alwaysEmitIntoClient
    static var threadCPUTime: Clock.ID { Clock.ID(_CLOCK_THREAD_CPUTIME_ID) }
        
    ///
    @available(macOS 10.12, *)
    @_alwaysEmitIntoClient
    static var monotonicRaw: Clock.ID { Clock.ID(_CLOCK_MONOTONIC_RAW) }
    
    ///
    @available(macOS 10.12, *)
    @_alwaysEmitIntoClient
    static var monotonicRawApproximated: Clock.ID { Clock.ID(_CLOCK_MONOTONIC_RAW_APPROX) }
    
    ///
    @available(macOS 10.12, *)
    @_alwaysEmitIntoClient
    static var uptimeRaw: Clock.ID { Clock.ID(_CLOCK_UPTIME_RAW) }
    
    ///
    @available(macOS 10.12, *)
    @_alwaysEmitIntoClient
    static var uptimeRawApproximated: Clock.ID { Clock.ID(_CLOCK_UPTIME_RAW_APPROX) }
}
