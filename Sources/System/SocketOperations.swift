/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

extension FileDescriptor {
    
    /// Creates an endpoint for communication and returns a descriptor.
    ///
    /// - Parameters:
    ///   - family: The protocol family which will be used for communication.
    ///   - type: Specifies the communication semantics.
    ///   - protocol: Specifies the communication semantics.
    ///   - retryOnInterrupt: Whether to retry the read operation
    ///     if it throws ``Errno/interrupted``.
    ///     The default is `true`.
    ///     Pass `false` to try only once and throw an error upon interruption.
    /// - Returns: The file descriptor of the opened socket.
    ///
    @_alwaysEmitIntoClient
    public static func socket<T: SocketProtocol>(
        _ protocolID: T,
        retryOnInterrupt: Bool = true
    ) throws -> FileDescriptor {
        try _socket(T.family, type: protocolID.type, protocol: protocolID.rawValue, retryOnInterrupt: retryOnInterrupt).get()
    }
    
    @usableFromInline
    internal static func _socket(
        _ family: SocketAddressFamily,
        type: SocketType,
        protocol protocolID: Int32,
        retryOnInterrupt: Bool
    ) throws -> Result<FileDescriptor, Errno> {
        valueOrErrno(retryOnInterrupt: retryOnInterrupt) {
            system_socket(family.rawValue, type.rawValue, protocolID)
        }.map { FileDescriptor(socket: $0) }
    }
    
    @_alwaysEmitIntoClient
    public func setSocketOption<T: SocketOption>(
        _ option: T,
        retryOnInterrupt: Bool = true
    ) throws {
        try _setSocketOption(option, retryOnInterrupt: retryOnInterrupt).get()
    }
    
    @usableFromInline
    internal func _setSocketOption<T: SocketOption>(
        _ option: T,
        retryOnInterrupt: Bool
    ) -> Result<(), Errno> {
        nothingOrErrno(retryOnInterrupt: retryOnInterrupt) {
            option.withUnsafeBytes { bufferPointer in
                system_setsockopt(self.rawValue, T.ID.optionLevel.rawValue, T.id.rawValue, bufferPointer.baseAddress!, UInt32(bufferPointer.count))
            }
        }
    }
    
    @_alwaysEmitIntoClient
    public func getSocketOption<T: SocketOption>(
        _ option: T.Type,
        retryOnInterrupt: Bool = true
    ) throws -> T {
        return try _getSocketOption(option, retryOnInterrupt: retryOnInterrupt)
    }
    
    @usableFromInline
    internal func _getSocketOption<T: SocketOption>(
        _ option: T.Type,
        retryOnInterrupt: Bool
    ) throws -> T {
        return try T.withUnsafeBytes { bufferPointer in
            var length = UInt32(bufferPointer.count)
            guard system_getsockopt(self.rawValue, T.ID.optionLevel.rawValue, T.id.rawValue, bufferPointer.baseAddress!, &length) != -1 else {
                throw Errno.current
            }
        }
    }
    
    @_alwaysEmitIntoClient
    public func bind<Address: SocketAddress>(
        _ address: Address,
        retryOnInterrupt: Bool = true
    ) throws {
        try _bind(address, retryOnInterrupt: retryOnInterrupt).get()
    }
    
    @usableFromInline
    internal func _bind<T: SocketAddress>(
        _ address: T,
        retryOnInterrupt: Bool
    ) -> Result<(), Errno> {
        nothingOrErrno(retryOnInterrupt: retryOnInterrupt) {
            address.withUnsafePointer { (addressPointer, length) in
                system_bind(T.family.rawValue, addressPointer, length)
            }
        }
    }
    
    @_alwaysEmitIntoClient
    public func send<Address: SocketAddress>(
        _ data: UnsafeRawBufferPointer,
        to address: Address,
        flags: MessageFlags = [],
        retryOnInterrupt: Bool = true
    ) throws {
        try _send(data, to: address, flags: flags, retryOnInterrupt: retryOnInterrupt).get()
    }
    
    public func send<Address, Data>(
        _ data: Data,
        to address: Address,
        flags: MessageFlags = [],
        retryOnInterrupt: Bool = true
    ) throws where Address: SocketAddress, Data: Sequence, Data.Element == UInt8 {
        try data._withRawBufferPointer { dataPointer in
            _send(dataPointer, to: address, flags: flags, retryOnInterrupt: retryOnInterrupt)
        }.get()
    }
    
    @usableFromInline
    internal func _send<T: SocketAddress>(
        _ data: UnsafeRawBufferPointer,
        to address: T,
        flags: MessageFlags,
        retryOnInterrupt: Bool
    ) -> Result<(), Errno> {
        nothingOrErrno(retryOnInterrupt: retryOnInterrupt) {
            address.withUnsafePointer { (addressPointer, addressLength) in
                system_sendto(self.rawValue, data.baseAddress, data.count, flags.rawValue, addressPointer, addressLength)
            }
        }
    }
    
    @_alwaysEmitIntoClient
    public func listen(
        backlog: Int,
        retryOnInterrupt: Bool = true
    ) throws {
        try _listen(backlog: Int32(backlog), retryOnInterrupt: retryOnInterrupt).get()
    }
    
    @usableFromInline
    internal func _listen(
        backlog: Int32,
        retryOnInterrupt: Bool
    ) -> Result<(), Errno> {
        nothingOrErrno(retryOnInterrupt: retryOnInterrupt) {
            system_listen(self.rawValue, backlog)
        }
    }
    
    @_alwaysEmitIntoClient
    public func accept<Address: SocketAddress>(
        _ address: Address.Type,
        retryOnInterrupt: Bool = true
    ) throws -> (FileDescriptor, Address) {
        return try _accept(Address.self, retryOnInterrupt: retryOnInterrupt).get()
    }
    
    @usableFromInline
    internal func _accept<Address: SocketAddress>(
        _ address: Address.Type,
        retryOnInterrupt: Bool
    ) -> Result<(FileDescriptor, Address), Errno> {
        var result: Result<CInt, Errno> = .success(0)
        let address = Address.withUnsafePointer { socketPointer, socketLength in
            var length = socketLength
            result = valueOrErrno(retryOnInterrupt: retryOnInterrupt) {
                system_accept(self.rawValue, socketPointer, &length)
            }
        }
        return result.map { (FileDescriptor(socket: $0), address) }
    }
    
    func connect() {
        
    }
    
    func poll() {
        
    }
}
