/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// POSIX Socket Protocol
public protocol SocketProtocol: RawRepresentable {
    
    static var family: SocketAddressFamily { get }
    
    var type: SocketType { get }
    
    init?(rawValue: Int32)
    
    var rawValue: Int32 { get }
}

/// Unix Protocol Family
public enum UnixProtocol: Int32, Codable, SocketProtocol {
    
    case raw = 0
    
    public static var family: SocketAddressFamily { .unix }
    
    public var type: SocketType {
        switch self {
        case .raw: return .raw
        }
    }
}

/// IPv4 Protocol Family
public enum IPv4Protocol: Int32, Codable, SocketProtocol {
    
    case raw
    case tcp
    case udp
    
    public static var family: SocketAddressFamily { .ipv4 }
    
    public var type: SocketType {
        switch self {
        case .raw: return .raw
        case .tcp: return .stream
        case .udp: return .datagram
        }
    }
    
    public var rawValue: Int32 {
        switch self {
        case .raw: return _IPPROTO_RAW
        case .tcp: return _IPPROTO_TCP
        case .udp: return _IPPROTO_UDP
        }
    }
}

/// IPv6 Protocol Family
public enum IPv6Protocol: Int32, Codable, SocketProtocol {
    
    case raw
    case tcp
    case udp
    
    public static var family: SocketAddressFamily { .ipv6 }
    
    public var type: SocketType {
        switch self {
        case .raw: return .raw
        case .tcp: return .stream
        case .udp: return .datagram
        }
    }
    
    public var rawValue: Int32 {
        switch self {
        case .raw: return _IPPROTO_RAW
        case .tcp: return _IPPROTO_TCP
        case .udp: return _IPPROTO_UDP
        }
    }
}

#if os(Linux)
/// Bluetooth Socket Protocol
public enum BluetoothProtocol: Int32, Codable, SocketProtocol {
    
    /// Bluetooth L2CAP (Logical link control and adaptation protocol)
    case l2cap      = 0
    
    /// Bluetooth HCI protocol (Host Controller Interface)
    case hci        = 1
    
    /// Bluetooth SCO protocol (Synchronous Connection Oriented Link)
    case sco        = 2
    
    /// Bluetooth RFCOMM protocol (Radio frequency communication)
    case rfcomm     = 3
    
    /// Bluetooth BNEP (network encapsulation protocol)
    case bnep       = 4
    
    /// CAPI Message Transport Protocol
    case cmtp       = 5
    
    /// HIDP (Human Interface Device Protocol) is a transport layer for HID reports.
    case hidp       = 6
    
    /// Audio/video data transport protocol
    case avdtp      = 7
    
    public static var family: SocketAddressFamily { .bluetooth }
    
    public var type: SocketType {
        switch self {
        case .l2cap:    return .sequencedPacket
        case .hci:      return .raw
        case .sco:      return .sequencedPacket
        case .rfcomm:   return .stream
        case .bnep:     return .raw
        case .cmtp:     return .raw
        case .hidp:     return .raw
        case .avdtp:    return .raw
        }
    }
}
#endif
