/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

internal extension CInterop.TimeIntervalMicroseconds {
    
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
