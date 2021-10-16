/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// Input / Output Request identifier for manipulating underlying device parameters of special files.
public protocol IOControlID: RawRepresentable {
    
    /// Create a strongly-typed file events from a raw C IO request.
    init?(rawValue: CUnsignedLong)
    
    /// The raw C IO request ID.
    var rawValue: CUnsignedLong { get }
}

public protocol IOControlInteger {
    
    associatedtype ID: IOControlID
    
    static var id: ID { get }
    
    var intValue: Int32 { get }
}

public protocol IOControlValue {
    
    associatedtype ID: IOControlID
    
    static var id: ID { get }
    
    mutating func withUnsafeMutablePointer<Result>(_ body: (UnsafeMutableRawPointer) throws -> (Result)) rethrows -> Result
}

#if os(macOS) || os(Linux) || os(FreeBSD) || os(Android)
/// Terminal `ioctl` definitions
@frozen
public struct TerminalIO: IOControlID, Equatable, Hashable {
    
    public let rawValue: CUnsignedLong
    
    public init(rawValue: CUnsignedLong) {
        self.rawValue = rawValue
    }
    
    @_alwaysEmitIntoClient
    private init(_ rawValue: CUnsignedLong) {
        self.init(rawValue: rawValue)
    }
}

public extension TerminalIO {
    
    /// Turn break on, that is, start sending zero bits.
    @_alwaysEmitIntoClient
    static var setBreakBit: TerminalIO { TerminalIO(_TIOCSBRK) }
    
    /// Turn break off, that is, stop sending zero bits.
    @_alwaysEmitIntoClient
    static var clearBreakBit: TerminalIO { TerminalIO(_TIOCCBRK) }
    
    /// Put the terminal into exclusive mode.
    @_alwaysEmitIntoClient
    static var setExclusiveMode: TerminalIO { TerminalIO(_TIOCEXCL) }
    
    /// Reset exclusive use of tty.
    @_alwaysEmitIntoClient
    static var resetExclusiveMode: TerminalIO { TerminalIO(_TIOCNXCL) }
}
#endif
