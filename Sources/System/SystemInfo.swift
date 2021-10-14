/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// System Information and statistics
public enum SystemInfo {
    
    /// Returns the number of bytes in a memory page, where "page" is a fixed-length block,
    /// the unit for memory allocation and file mapping.
    static var pageSize: UInt {
        return numericCast(system_getpagesize())
    }
    
    
}
