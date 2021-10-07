/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// Socket Address
public protocol SocketAddress {
    
    /// Socket Address Family
    static var family: SocketAddressFamily { get }
    
    func withUnsafeBytes<Result>(_ body: ((UnsafeRawBufferPointer) -> (Result))) -> Result
}

/// IPv4 Socket Address
public struct IPv4Address: SocketAddress, Equatable, Hashable {
    
    @usableFromInline
    internal let bytes: CInterop.IPv4Address
    
    @_alwaysEmitIntoClient
    internal init(_ bytes: CInterop.IPv4Address) {
        self.bytes = bytes
    }
    
    @_alwaysEmitIntoClient
    public static var family: SocketAddressFamily { .ipv4 }
    
    @_alwaysEmitIntoClient
    public func withUnsafeBytes<Result>(_ body: ((UnsafeRawBufferPointer) -> (Result))) -> Result {
        Swift.withUnsafeBytes(of: bytes, body)
    }
}

public extension IPv4Address {
    
    @_alwaysEmitIntoClient
    static var any: IPv4Address { IPv4Address(_INADDR_ANY) }
}

extension IPv4Address: RawRepresentable {
    
    @_alwaysEmitIntoClient
    public init?(rawValue: String) {
        guard let bytes = try? CInterop.IPv4Address(rawValue) else {
            return nil
        }
        self.init(bytes)
    }
    
    @_alwaysEmitIntoClient
    public var rawValue: String {
        return try! String(bytes)
    }
}

extension IPv4Address: CustomStringConvertible {
    
    @_alwaysEmitIntoClient
    public var description: String {
        return rawValue
    }
}
