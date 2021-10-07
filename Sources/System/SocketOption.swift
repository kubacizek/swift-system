/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// POSIX Socket Option ID
public protocol SocketOption {
    
    associatedtype ID: SocketOptionID
    
    var id: ID { get }
    
    func withUnsafeBytes<T>(_: ((UnsafeRawBufferPointer) -> (T))) -> T
}

public enum GenericSocketOption: SocketOption, Equatable, Hashable {
    
    public typealias ID = GenericSocketOptionID
    
    case debug(Bool)
    case keepAlive(Bool)
    
    @_alwaysEmitIntoClient
    public var id: ID {
        switch self {
        case .debug: return .debug
        case .keepAlive: return .keepAlive
        }
    }
    
    @_alwaysEmitIntoClient
    public func withUnsafeBytes<T>(_ pointer: ((UnsafeRawBufferPointer) -> (T))) -> T {
        switch self {
        case let .debug(value):
            return Swift.withUnsafeBytes(of: value.cInt) { bufferPointer in
                pointer(bufferPointer)
            }
        case let .keepAlive(value):
            return Swift.withUnsafeBytes(of: value.cInt) { bufferPointer in
                pointer(bufferPointer)
            }
        }
    }
}

#if os(Linux)
public enum NetlinkSocketOption: SocketOption, Equatable, Hashable {
    
    public typealias ID = NetlinkSocketOptionID
    
    case addMembership(group: Int32)
    case removeMembership(group: Int32)
    
    @_alwaysEmitIntoClient
    public var id: ID {
        switch self {
        case .addMembership: return .addMembership
        case .removeMembership: return .removeMembership
        }
    }
    
    @_alwaysEmitIntoClient
    public func withUnsafeBytes<T>(_ pointer: ((UnsafeRawBufferPointer) -> (T))) -> T {
        switch self {
        case let .addMembership(group: group):
            withUnsafeBytes(of: group) { bufferPointer in
                pointer(bufferPointer)
            }
        case let .removeMembership(group: group):
            withUnsafeBytes(of: group) { bufferPointer in
                pointer(bufferPointer)
            }
        }
    }
}
#endif
