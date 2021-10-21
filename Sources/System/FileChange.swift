/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

///
@frozen
// @available(macOS 10.16, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public struct FileChangeID: RawRepresentable, Hashable, Codable {
  
    /// The raw C file handle.
    @_alwaysEmitIntoClient
    public let rawValue: CInt

    /// Creates a strongly-typed file handle from a raw C file handle.
    @_alwaysEmitIntoClient
    public init(rawValue: CInt) { self.rawValue = rawValue }
    
    @_alwaysEmitIntoClient
    private init(_ raw: CInt) { self.init(rawValue: raw) }
}

public extension FileChangeID {
    
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
