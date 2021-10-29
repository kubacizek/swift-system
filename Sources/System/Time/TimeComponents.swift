/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// POSIX Time Components
@frozen
public struct TimeComponents: Equatable, Hashable, Codable {
    
    public var second: Int32 = 0
    
    public var minute: Int32 = 0
    
    public var hour: Int32 = 0
    
    public var dayOfMonth: Int32 = 1
    
    public var month: Int32 = 1
    
    public var year: Int32 = 0
    
    public var weekday: Int32 = 0
    
    public var dayOfYear: Int32 = 1
    
    @_alwaysEmitIntoClient
    public init() { }
}

public extension TimeComponents {
    
    @_alwaysEmitIntoClient
    init(time: Time) {
        self.init(.init(utc: time.rawValue))
    }
}

public extension Time {
    
    @_alwaysEmitIntoClient
    init(components: TimeComponents) {
        self.init(rawValue: .init(utc: .init(components)))
    }
}

extension TimeComponents: CustomStringConvertible {
    
    public var description: String {
        return String(CInterop.TimeComponents(self))
    }
}

public extension TimeComponents {
    
    @frozen
    enum Component {
        case second
        case minute
        case hour
        case dayOfMonth
        case month
        case year
        case weekday
        case dayOfYear
    }
    
    /// Get the value for the specified component.
    subscript(component: Component) -> Int32 {
        
        get {
            switch component {
            case .second:
                return second
            case .minute:
                return minute
            case .hour:
                return hour
            case .dayOfMonth:
                return dayOfMonth
            case .month:
                return month
            case .year:
                return year
            case .weekday:
                return weekday
            case .dayOfYear:
                return dayOfYear
            }
        }
        
        set {
            switch component {
            case .second:
                second = newValue
            case .minute:
                minute = newValue
            case .hour:
                hour = newValue
            case .dayOfMonth:
                dayOfMonth = newValue
            case .month:
                month = newValue
            case .year:
                year = newValue
            case .weekday:
                weekday = newValue
            case .dayOfYear:
                dayOfYear = newValue
            }
        }
    }
}

// MARK: - C Interop

internal extension TimeComponents {
    
    @usableFromInline
    init(_ cValue: CInterop.TimeComponents) {
        self.second = cValue.tm_sec
        self.minute = cValue.tm_min
        self.hour = cValue.tm_hour
        self.dayOfMonth = cValue.tm_mday
        self.month = cValue.tm_mon + 1
        self.year = 1900 + cValue.tm_year
        self.weekday = cValue.tm_wday
        self.dayOfYear = cValue.tm_yday
    }
}

internal extension CInterop.TimeComponents {
    
    @usableFromInline
    init(_ value: TimeComponents) {
        self.init(
            tm_sec: value.second,
            tm_min: value.minute,
            tm_hour: value.hour,
            tm_mday: value.dayOfMonth,
            tm_mon: value.month - 1,
            tm_year: value.year - 1900,
            tm_wday: value.weekday,
            tm_yday: value.dayOfYear,
            tm_isdst: -1,
            tm_gmtoff: 0,
            tm_zone: nil
        )
    }
    
    @usableFromInline
    init(utc time: CInterop.Time) {
        self.init()
        let _ = withUnsafePointer(to: time) {
            system_gmtime_r($0, &self)
        }
    }
    
    @usableFromInline
    init(local time: CInterop.Time) {
        self.init()
        let _ = withUnsafePointer(to: time) {
            system_localtime_r($0, &self)
        }
    }
}

internal extension String {
    
    @usableFromInline
    init(_ timeComponents: CInterop.TimeComponents) {
        self.init(_unsafeUninitializedCapacity: 26) { buffer in
            buffer.withMemoryRebound(to: CChar.self) { cString in
                withUnsafePointer(to: timeComponents) {
                    system_strlen(.init(system_asctime_r($0, cString.baseAddress!))) - 1
                }
            }
        }
    }
}

internal extension CInterop.Time {
    
    @usableFromInline
    init(utc timeComponents: CInterop.TimeComponents) {
        self = withUnsafePointer(to: timeComponents) {
            system_timegm($0)
        }
    }
    
    @usableFromInline
    init(local timeComponents: CInterop.TimeComponents) {
        self = withUnsafePointer(to: timeComponents) {
            system_timelocal($0)
        }
    }
}
