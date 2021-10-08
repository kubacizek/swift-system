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
    
    func withUnsafePointer<Result>(_ body: ((UnsafePointer<CInterop.SocketAddress>) -> (Result))) -> Result
}

/// IPv4 Socket Address
public struct IPv4SocketAddress: SocketAddress, Equatable, Hashable {
    
    @_alwaysEmitIntoClient
    public static var family: SocketAddressFamily { .ipv4 }
    
    @_alwaysEmitIntoClient
    public var address: IPv4Address
    
    public var port: UInt16
    
    public init(address: IPv4Address,
                port: UInt16) {
        
        self.address = address
        self.port = port
    }
    
    public func withUnsafePointer<Result>(_ body: ((UnsafePointer<CInterop.SocketAddress>) -> (Result))) -> Result {
        
        var socketAddress = CInterop.IPv4SocketAddress()
        socketAddress.sin_family = numericCast(Self.family.rawValue)
        socketAddress.sin_port = port.bigEndian
        socketAddress.sin_addr = address.bytes
        socketAddress.sin_len = 0
        assert(MemoryLayout.size(ofValue: socketAddress) == MemoryLayout<CInterop.SocketAddress>.size)
        return Swift.withUnsafePointer(to: unsafeBitCast(socketAddress, to: CInterop.SocketAddress.self), body)
    }
}

/// IPv6 Socket Address
public struct IPv6SocketAddress: SocketAddress, Equatable, Hashable {
    
    public static var family: SocketAddressFamily { .ipv6 }
    
    public var address: IPv6Address
    
    public var port: UInt16
    
    public init(address: IPv6Address,
                port: UInt16) {
        
        self.address = address
        self.port = port
    }
    
    public func withUnsafePointer<Result>(_ body: ((UnsafePointer<CInterop.SocketAddress>) -> (Result))) -> Result {
        
        var socketAddress = CInterop.IPv6SocketAddress()
        socketAddress.sin6_family = numericCast(Self.family.rawValue)
        socketAddress.sin6_port = port.bigEndian
        socketAddress.sin6_addr = address.bytes
        socketAddress.sin6_len = 0
        assert(MemoryLayout.size(ofValue: socketAddress) == MemoryLayout<CInterop.SocketAddress>.size)
        return Swift.withUnsafePointer(to: unsafeBitCast(socketAddress, to: CInterop.SocketAddress.self), body)
    }
}
