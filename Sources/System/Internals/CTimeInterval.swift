/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

internal protocol CTimeInterval {
    
    init(seconds: Double)
    
    var seconds: Double { get }
}

extension CInterop.TimeIntervalMicroseconds: CTimeInterval {
    
    init(seconds: Double) {
        let (integerValue, decimalValue) = system_modf(seconds)
        let microseconds = decimalValue * 1_000_000.0
        self.init(
            tv_sec: Int(integerValue),
            tv_usec: CInterop.Microseconds(microseconds)
        )
    }
    
    var seconds: Double {
        let seconds = Double(self.tv_sec)
        let microseconds = Double(self.tv_usec) / 1_000_000.0
        return seconds + microseconds
    }
}

extension CInterop.TimeIntervalNanoseconds: CTimeInterval {
    
    init(seconds: Double) {
        let (integerValue, decimalValue) = system_modf(seconds)
        let nanoseconds = decimalValue * 1_000_000_000.0
        self.init(
            tv_sec: Int(integerValue),
            tv_nsec: Int(nanoseconds)
        )
    }
    
    var seconds: Double {
        let seconds = Double(self.tv_sec)
        let nanoseconds = Double(self.tv_nsec) / 1_000_000_000.0
        return seconds + nanoseconds
    }
}
