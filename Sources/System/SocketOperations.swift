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
        }.map { FileDescriptor(rawValue: $0) }
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
                system_setsockopt(self.rawValue, T.ID.optionLevel.rawValue, option.id.rawValue, bufferPointer.baseAddress!, UInt32(bufferPointer.count))
            }
        }
    }
}
