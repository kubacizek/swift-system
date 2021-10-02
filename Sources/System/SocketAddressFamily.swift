//
//  AddressFamily.swift
//  
//
//  Created by Alsey Coleman Miller on 1/10/21.
//

/// POSIX Socket Address Family
@frozen
public struct SocketAddressFamily: RawRepresentable, Hashable, Codable {
    
  /// The raw socket address family identifier.
  @_alwaysEmitIntoClient
  public let rawValue: CInt

  /// Creates a strongly-typed socket address family from a raw address family identifier.
  @_alwaysEmitIntoClient
  public init(rawValue: CInt) { self.rawValue = rawValue }
  
  @_alwaysEmitIntoClient
  private init(_ raw: CInt) { self.init(rawValue: raw) }
}

public extension SocketAddressFamily {
    
    /// Local communication
    static var unix: SocketAddressFamily { SocketAddressFamily(_AF_UNIX) }
    
    /// IPv4 Internet protocol
    static var inet: SocketAddressFamily { SocketAddressFamily(_AF_INET) }
    
    /// IPv6 Internet protocol
    static var inet6: SocketAddressFamily { SocketAddressFamily(_AF_INET6) }
    
    /// IPX - Novell protocol
    static var ipx: SocketAddressFamily { SocketAddressFamily(_AF_IPX) }
    
    /// AppleTalk protocol
    static var appleTalk: SocketAddressFamily { SocketAddressFamily(_AF_APPLETALK) }
}

#if !os(Windows)
public extension SocketAddressFamily {
    
    /// DECet protocol sockets
    static var decnet: SocketAddressFamily { SocketAddressFamily(_AF_DECnet) }
    
    /// VSOCK (originally "VMWare VSockets") protocol for hypervisor-guest communication
    static var vsock: SocketAddressFamily { SocketAddressFamily(_AF_VSOCK) }
    
    /// Integrated Services Digital Network protocol
    static var isdn: SocketAddressFamily { SocketAddressFamily(_AF_ISDN) }
}
#endif

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
public extension SocketAddressFamily {
    
    /// NetBIOS protocol
    static var netbios: SocketAddressFamily { SocketAddressFamily(_AF_NETBIOS) }
    
    ///
    static var implink: SocketAddressFamily { SocketAddressFamily(_AF_IMPLINK) }
    
    ///
    static var pup: SocketAddressFamily { SocketAddressFamily(_AF_PUP) }
    
    ///
    static var chaos: SocketAddressFamily { SocketAddressFamily(_AF_CHAOS) }
    
    ///
    static var ns: SocketAddressFamily { SocketAddressFamily(_AF_NS) }
    
    ///
    static var iso: SocketAddressFamily { SocketAddressFamily(_AF_ISO) }
    
    /// Generic PPP transport layer, for setting up L2 tunnels (L2TP and PPPoE).
    static var ppp: SocketAddressFamily { SocketAddressFamily(_AF_PPP) }
    
    ///
    static var link: SocketAddressFamily { SocketAddressFamily(_AF_LINK) }
}
#endif

#if os(Linux)
public extension SocketAddressFamily {
    
    /// Amateur radio AX.25 protocol
    static var ax25: SocketAddressFamily { SocketAddressFamily(_AF_AX25) }
    
    /// ITU-T X.25 / ISO-8208 protocol
    static var x25: SocketAddressFamily { SocketAddressFamily(_AF_X25) }
    
    /// Key management protocol
    static var key: SocketAddressFamily { SocketAddressFamily(_AF_KEY) }
    
    /// Kernel user interface device
    static var netlink: SocketAddressFamily { SocketAddressFamily(_AF_NETLINK) }
    
    /// Low-level packet interface
    static var packet: SocketAddressFamily { SocketAddressFamily(_AF_PACKET) }
    
    /// Access to ATM Switched Virtual Circuits
    static var atm: SocketAddressFamily { SocketAddressFamily(_AF_ATMSVC) }
    
    /// Reliable Datagram Sockets (RDS) protocol
    static var rds: SocketAddressFamily { SocketAddressFamily(_AF_RDS) }
    
    /// Generic PPP transport layer, for setting up L2 tunnels (L2TP and PPPoE).
    static var ppp: SocketAddressFamily { SocketAddressFamily(_AF_PPPOX) }
    
    /// Legacy protocol for wide area network (WAN) connectivity that was used by Sangoma WAN cards.
    static var wanpipe: SocketAddressFamily { SocketAddressFamily(_AF_WANPIPE) }
    
    /// Logical link control (IEEE 802.2 LLC) protocol, upper part of data link layer of ISO/OSI networking protocol stack
    static var link: SocketAddressFamily { SocketAddressFamily(_AF_LLC) }
    
    /// InfiniBand native addressing
    static var ib: SocketAddressFamily { SocketAddressFamily(_AF_IB) }
    
    /// Multiprotocol Label Switching
    static var mpls: SocketAddressFamily { SocketAddressFamily(_AF_MPLS) }
    
    /// Controller Area Network automotive bus protocol
    static var can: SocketAddressFamily { SocketAddressFamily(_AF_CAN) }
    
    /// TIPC, "cluster domain sockets" protocol
    static var tipc: SocketAddressFamily { SocketAddressFamily(_AF_TIPC) }
    
    /// Bluetooth protocol
    static var bluetooth: SocketAddressFamily { SocketAddressFamily(_AF_BLUETOOTH) }
    
    /// IUCV (inter-user communication vehicle) z/VM protocol for hypervisor-guest interaction
    static var iucv: SocketAddressFamily { SocketAddressFamily(_AF_IUCV) }
    
    /// Rx, Andrew File System remote procedure call protocol
    static var rxrpc: SocketAddressFamily { SocketAddressFamily(_AF_RXRPC) }
    
    /// Nokia cellular modem IPC/RPC interface
    static var phonet: SocketAddressFamily { SocketAddressFamily(_AF_PHONET) }
    
    /// IEEE 802.15.4 WPAN (wireless personal area network) raw packet protocol
    static var ieee802154: SocketAddressFamily { SocketAddressFamily(_AF_IEEE802154) }
    
    /// Ericsson's Communication CPU to Application CPU interface (CAIF) protocol
    static var caif: SocketAddressFamily { SocketAddressFamily(_AF_CAIF) }
    
    /// Interface to kernel crypto API
    static var crypto: SocketAddressFamily { SocketAddressFamily(_AF_ALG) }
    
    /// KCM (kernel connection multiplexer) interface
    static var kcm: SocketAddressFamily { SocketAddressFamily(_AF_KCM) }
    
    /// Qualcomm IPC router interface protocol
    static var qipcrtr: SocketAddressFamily { SocketAddressFamily(_AF_QIPCRTR) }
    
    /// SMC-R (shared memory communications over RDMA) protocol
    /// and SMC-D (shared memory communications, direct memory access) protocol for intra-node z/VM quest interaction
    static var smc: SocketAddressFamily { SocketAddressFamily(_AF_SMC) }
    
    /// XDP (express data path) interface
    static var xdp: SocketAddressFamily { SocketAddressFamily(_AF_XDP) }
}
#endif

#if os(Windows)
public extension SocketAddressFamily {
    
    /// NetBIOS protocol
    static var netbios: SocketAddressFamily { SocketAddressFamily(_AF_NETBIOS) }
    
    /// IrDA protocol
    static var irda: SocketAddressFamily { SocketAddressFamily(_AF_IRDA) }
    
    /// Bluetooth protocol
    static var bluetooth: SocketAddressFamily { SocketAddressFamily(_AF_BTH) }
}
#endif
