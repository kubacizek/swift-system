/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// POSIX Socket Option ID
public protocol SocketOptionID: RawRepresentable {
        
    static var optionLevel: SocketOptionLevel { get }
    
    init?(rawValue: Int32)
    
    var rawValue: Int32 { get }
}

public enum GenericSocketOptionID: Int32, SocketOptionID {
    
    case debug
    case keepAlive
    
    @_alwaysEmitIntoClient
    public static var optionLevel: SocketOptionLevel { .default }
    
    @_alwaysEmitIntoClient
    public var rawValue: Int32 {
        switch self {
        case .debug: return _SO_DEBUG
        case .keepAlive: return _SO_KEEPALIVE
        }
    }
}

#if os(Linux)
public enum NetlinkSocketOptionID: Int32, SocketOptionID {
    
    case addMembership
    case removeMembership
    
    
    @_alwaysEmitIntoClient
    public static var optionLevel: SocketOptionLevel { .netlink }
    
    @_alwaysEmitIntoClient
    public var rawValue: Int32 {
        switch self {
        case .addMembership: return _NETLINK_ADD_MEMBERSHIP
        case .removeMembership: return _NETLINK_DROP_MEMBERSHIP
        }
    }
    
}
#endif
