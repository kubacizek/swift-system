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

/// IPv4 Protocol Family
public enum IPv4Protocol: Int32, Codable, SocketProtocol {
    
    case tcp
    case udp
    
    public static var family: SocketAddressFamily { .ipv4 }
    
    public var type: SocketType {
        switch self {
        case .tcp: return .stream
        case .udp: return .datagram
        }
    }
}

#if os(Linux)
/// Bluetooth Socket Protocol
public enum BluetoothProtocol: Int32, Codable, SocketProtocol {
    
    /// Bluetooth L2CAP protocol
    case l2cap      = 0
    
    /// Bluetooth HCI protocol
    case hci        = 1
    
    /// Bluetooth SCO protocol
    case sco        = 2
    
    /// Bluetooth RFCOMM protocol
    case rfcomm     = 3
    case bnep       = 4
    case cmtp       = 5
    case hidp       = 6
    case avdtp      = 7
    
    public static var family: SocketAddressFamily { .bluetooth }
    
    public var type: SocketType {
        switch self {
        case .l2cap: return .sequencedPacket
        case .hci: return .raw
        case .sco: fatalError()
        case .rfcomm: return .stream
        default: fatalError("Unknown")
        }
    }
}
#endif
