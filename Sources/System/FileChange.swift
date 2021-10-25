/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

public extension FileDescriptor {
    
    /// Duplicate
    func duplicate(
        closeOnExec: Bool = false,
        retryOnInterrupt: Bool = true
    ) throws -> FileDescriptor {
        let fileDescriptor = try _change(
            closeOnExec ? .duplicateCloseOnExec : .duplicate,
            self.rawValue, retryOnInterrupt: retryOnInterrupt
        ).get()
        return FileDescriptor(rawValue: fileDescriptor)
    }
    
    /// Get Flags
    func getFlags(retryOnInterrupt: Bool = true) throws -> CInt {
        return try _change(
            .getFileDescriptorFlags,
            retryOnInterrupt: retryOnInterrupt
        ).get()
    }
    
    /// Set Flags
    func setFlags(
        _ newValue: CInt,
        retryOnInterrupt: Bool = true
    ) throws {
        let _ = try _change(
            .setFileDescriptorFlags,
            newValue,
            retryOnInterrupt: retryOnInterrupt
        ).get()
    }
    
    /// Get Status
    func getStatus(retryOnInterrupt: Bool = true) throws -> CInt {
        return try _change(
            .getStatusFlags,
            retryOnInterrupt: retryOnInterrupt
        ).get()
    }
    
    /// Set Status
    func setStatus(
        _ newValue: CInt,
        retryOnInterrupt: Bool = true
    ) throws {
        let _ = try _change(
            .setStatusFlags,
            newValue,
            retryOnInterrupt: retryOnInterrupt
        ).get()
    }
    
    @usableFromInline
    internal func _change(
        _ operation: FileChangeID,
        retryOnInterrupt: Bool
    ) -> Result<CInt, Errno> {
        valueOrErrno(retryOnInterrupt: retryOnInterrupt) {
            system_fcntl(self.rawValue, operation.rawValue)
        }
    }
    
    @usableFromInline
    internal func _change(
        _ operation: FileChangeID,
        _ value: CInt,
        retryOnInterrupt: Bool
    ) -> Result<CInt, Errno> {
        valueOrErrno(retryOnInterrupt: retryOnInterrupt) {
            system_fcntl(self.rawValue, operation.rawValue, value)
        }
    }
    
    @usableFromInline
    internal func _change(
        _ operation: FileChangeID,
        _ pointer: UnsafeMutableRawPointer,
        retryOnInterrupt: Bool
    ) -> Result<CInt, Errno> {
        valueOrErrno(retryOnInterrupt: retryOnInterrupt) {
            system_fcntl(self.rawValue, operation.rawValue, pointer)
        }
    }
}

@usableFromInline
internal struct FileChangeID: RawRepresentable, Hashable, Codable {
    
    /// The raw C file handle.
    @_alwaysEmitIntoClient
    public let rawValue: CInt
    
    /// Creates a strongly-typed file handle from a raw C file handle.
    @_alwaysEmitIntoClient
    public init(rawValue: CInt) { self.rawValue = rawValue }
    
    @_alwaysEmitIntoClient
    private init(_ raw: CInt) { self.init(rawValue: raw) }
}

internal extension FileChangeID {
    
    /// Duplicate a file descriptor.
    @_alwaysEmitIntoClient
    static var duplicate: FileChangeID { FileChangeID(_F_DUPFD) }
    
    /// Duplicate a file descriptor and additionally set the close-on-exec flag for the duplicate descriptor.
    @_alwaysEmitIntoClient
    static var duplicateCloseOnExec: FileChangeID { FileChangeID(_F_DUPFD_CLOEXEC) }
    
    /// Read the file descriptor flags.
    @_alwaysEmitIntoClient
    static var getFileDescriptorFlags: FileChangeID { FileChangeID(_F_GETFD) }
    
    /// Set the file descriptor flags.
    @_alwaysEmitIntoClient
    static var setFileDescriptorFlags: FileChangeID { FileChangeID(_F_SETFD) }
    
    /// Get the file access mode and the file status flags.
    @_alwaysEmitIntoClient
    static var getStatusFlags: FileChangeID { FileChangeID(_F_GETFL) }
    
    /// Set the file status flags.
    @_alwaysEmitIntoClient
    static var setStatusFlags: FileChangeID { FileChangeID(_F_SETFL) }
}
