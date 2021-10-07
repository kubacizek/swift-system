/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

@usableFromInline
internal protocol CInternetAddress {
    
    static var stringLength: UInt32 { get }
    
    static var addressFamily: SocketAddressFamily { get }
    
    init()
}

internal extension CInternetAddress {
    
    @usableFromInline
    init(_ string: String) throws {
        
        var address = Self.init()
        
        /**
         inet_pton() returns 1 on success (network address was successfully converted). 0 is returned if src does not contain a character string representing a valid network address in the specified address family. If af does not contain a valid address family, -1 is returned and errno is set to EAFNOSUPPORT.
        */
        try nothingOrErrno(retryOnInterrupt: false) {
            string.withCString { cString in
                system_inet_pton(Self.addressFamily.rawValue, cString, &address)
            }
        }.get()
        
        self = address
    }
}

internal extension String {
    
    @usableFromInline
    init<T: CInternetAddress>(_ cInternetAddress: T) throws {
        
        let cStringLength = T.stringLength
        let cString = UnsafeMutablePointer<CInterop.PlatformChar>.allocate(capacity: Int(cStringLength))
        defer { cString.deallocate() }
        
        let success = withUnsafePointer(to: cInternetAddress) { addressPointer in
            system_inet_ntop(T.addressFamily.rawValue, addressPointer, cString, cStringLength) != nil
        }
        
        guard success else {
            throw Errno.current
        }
        
        self.init(cString: cString)
    }
}

extension CInterop.IPv4Address: CInternetAddress {
    
    @usableFromInline
    static var stringLength: UInt32 { return UInt32(_INET_ADDRSTRLEN) }
    
    @usableFromInline
    static var addressFamily: SocketAddressFamily { .ipv4 }
}

extension CInterop.IPv6Address: CInternetAddress {
    
    @usableFromInline
    static var stringLength: UInt32 { return UInt32(_INET6_ADDRSTRLEN) }
    
    @usableFromInline
    static var addressFamily: SocketAddressFamily { .ipv6 }
}
