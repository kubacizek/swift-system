/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

@usableFromInline
internal protocol CInternetAddress {
    
    static var stringLength: Int { get }
    
    static var family: SocketAddressFamily { get }
    
    init()
}

internal extension CInternetAddress {
    
    @usableFromInline
    init(_ string: String) throws {
        self = try Self.parse(string).get()
    }
    
    @usableFromInline
    static func parse(_ string: String) -> Result<Self, Errno> {
        var address = Self.init()
        return nothingOrErrno(retryOnInterrupt: false) {
            string.withCString { cString in
                system_inet_pton(Self.family.rawValue, cString, &address)
            }
        }.flatMap { .success(address) }
    }
}

internal extension String {
    
    @usableFromInline
    init<T: CInternetAddress>(_ cInternetAddress: T) throws {
        try self.init(_unsafeUninitializedCapacity: Int(T.stringLength)) { stringBuffer in
            try stringBuffer.withMemoryRebound(to: CChar.self) { charBuffer in
                let success = withUnsafePointer(to: cInternetAddress) { addressPointer in
                    system_inet_ntop(T.family.rawValue, addressPointer, charBuffer.baseAddress!, UInt32(stringBuffer.count)) != nil
                }
                guard success else {
                    throw Errno.current
                }
            }
            return T.stringLength
        }
    }
}

extension CInterop.IPv4Address: CInternetAddress {
    
    @usableFromInline
    static var stringLength: Int { return numericCast(_INET_ADDRSTRLEN) }
    
    @usableFromInline
    static var family: SocketAddressFamily { .ipv4 }
}

extension CInterop.IPv6Address: CInternetAddress {
    
    @usableFromInline
    static var stringLength: Int { return numericCast(_INET6_ADDRSTRLEN) }
    
    @usableFromInline
    static var family: SocketAddressFamily { .ipv6 }
}
