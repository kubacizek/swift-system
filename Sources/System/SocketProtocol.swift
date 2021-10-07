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
    
    @_alwaysEmitIntoClient
    public static var family: SocketAddressFamily { .unix }
    
    @_alwaysEmitIntoClient
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
    
    @_alwaysEmitIntoClient
    public static var family: SocketAddressFamily { .ipv4 }
    
    @_alwaysEmitIntoClient
    public var type: SocketType {
        switch self {
        case .raw: return .raw
        case .tcp: return .stream
        case .udp: return .datagram
        }
    }
    
    @_alwaysEmitIntoClient
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
    
    @_alwaysEmitIntoClient
    public static var family: SocketAddressFamily { .ipv6 }
    
    @_alwaysEmitIntoClient
    public var type: SocketType {
        switch self {
        case .raw: return .raw
        case .tcp: return .stream
        case .udp: return .datagram
        }
    }
    
    @_alwaysEmitIntoClient
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
    
    @_alwaysEmitIntoClient
    public static var family: SocketAddressFamily { .bluetooth }
    
    @_alwaysEmitIntoClient
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

/// Netlink Socket Protocol
public enum NetLinkProtocol: Int32, Codable, SocketProtocol {
        
    case generic
    
    /* Receives routing and link updates and may be used to
     modify the routing tables (both IPv4 and IPv6), IP
     addresses, link parameters, neighbor setups, queueing
     disciplines, traffic classes, and packet classifiers. */
    case route
    
    /// Messages from 1-wire subsystem.
    case wire1
    
    /// Reserved for user-mode socket protocols.
    case user
    
    /* Transport IPv4 packets from netfilter to user space.  Used
     by ip_queue kernel module.  After a long period of being
     declared obsolete (in favor of the more advanced
     nfnetlink_queue feature), NETLINK_FIREWALL was removed in
     Linux 3.5. */
    case firewall
    
    /// Query information about sockets of various protocol families from the kernel.
    case socketDiagnosis
    
    /// Netfilter/iptables ULOG.
    case log
    
    /// IPsec
    case xfrm
    
    /// SELinux event notifications.
    case selinux
    
    /// Open-iSCSI.
    case iscsi
    
    /// Auditing.
    case audit
    
    /// Access to FIB lookup from user space.
    case fibLookup
    
    /// Kernel connector.
    case connector
    
    /// Netfilter subsystem.
    case netfilter
    
    /// SCSI Transports.
    case scsiTransports
    
    /// Infiniband RDMA.
    case rdma
    
    /// Transport IPv6 packets from netfilter to user space.
    case ipv6Forward
    
    /// DECnet routing messages.
    case decnetRoute
    
    /// Kernel messages to user space.
    case uevent
    
    /// Netlink interface to request information about ciphers
    /// registered with the kernel crypto API as well as allow
    /// configuration of the kernel crypto API.
    case crypto
    
    public static var family: SocketAddressFamily { .netlink }
    
    public var type: SocketType {
        /* Netlink is a datagram-oriented service.  Both SOCK_RAW and
         SOCK_DGRAM are valid values for socket_type.  However, the
         netlink protocol does not distinguish between datagram and raw
         sockets.*/
        return .raw
    }
    
    @_alwaysEmitIntoClient
    public var rawValue: Int32 {
        switch self {
        case .generic: return _NETLINK_GENERIC
        case .route: return _NETLINK_ROUTE
        }
    }
}

#endif
