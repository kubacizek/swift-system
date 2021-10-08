/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// Internet Protocol Address
@frozen
public enum IPAddress: Equatable, Hashable {
    
    /// IPv4
    case v4(IPv4Address)
    
    /// IPv6
    case v6(IPv6Address)
}

extension IPAddress: RawRepresentable {
    
    public init?(rawValue: String) {
        
        if let address = IPv4Address(rawValue: rawValue) {
            self = .v4(address)
        } else if let address = IPv6Address(rawValue: rawValue) {
            self = .v6(address)
        } else {
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case let .v4(address): return address.rawValue
        case let .v6(address): return address.rawValue
        }
    }
}

extension IPAddress: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }
}

/// IPv4 Socket Address
@frozen
public struct IPv4Address: Equatable, Hashable {
    
    @usableFromInline
    internal let bytes: CInterop.IPv4Address
    
    @_alwaysEmitIntoClient
    internal init(_ bytes: CInterop.IPv4Address) {
        self.bytes = bytes
    }
    
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

/// IPv6 Socket Address
@frozen
public struct IPv6Address: Equatable, Hashable {
    
    @usableFromInline
    internal let bytes: CInterop.IPv6Address
    
    @_alwaysEmitIntoClient
    internal init(_ bytes: CInterop.IPv6Address) {
        self.bytes = bytes
    }
    
    @_alwaysEmitIntoClient
    public func withUnsafeBytes<Result>(_ body: ((UnsafeRawBufferPointer) -> (Result))) -> Result {
        Swift.withUnsafeBytes(of: bytes, body)
    }
}

public extension IPv6Address {
    
    @_alwaysEmitIntoClient
    static var any: IPv6Address { IPv6Address(_INADDR6_ANY) }
    
    @_alwaysEmitIntoClient
    static var loopback: IPv6Address { IPv6Address(_INADDR6_LOOPBACK) }
}

extension IPv6Address: RawRepresentable {
    
    @_alwaysEmitIntoClient
    public init?(rawValue: String) {
        guard let bytes = try? CInterop.IPv6Address(rawValue) else {
            return nil
        }
        self.init(bytes)
    }
    
    @_alwaysEmitIntoClient
    public var rawValue: String {
        return try! String(bytes)
    }
}

extension IPv6Address: CustomStringConvertible {
    
    @_alwaysEmitIntoClient
    public var description: String {
        return rawValue
    }
}
