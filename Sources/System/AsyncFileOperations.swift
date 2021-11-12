/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

#if swift(>=5.5)
@available(macOS 12, iOS 15, *)
public extension FileDescriptor {
    
    /// Reads bytes at the current file offset into a buffer.
    ///
    /// - Parameters:
    ///   - buffer: The region of memory to read into.
    ///   - retryOnInterrupt: Whether to retry the read operation
    ///     if it throws ``Errno/interrupted``.
    ///     The default is `true`.
    ///     Pass `false` to try only once and throw an error upon interruption.
    ///   - sleepOnBlock: The number of nanoseconds to sleep if the operation
    ///     throws ``Errno/wouldBlock`` or other async I/O errors.
    /// - Returns: The number of bytes that were read.
    ///
    /// The <doc://com.apple.documentation/documentation/swift/unsafemutablerawbufferpointer/3019191-count> property of `buffer`
    /// determines the maximum number of bytes that are read into that buffer.
    ///
    /// After reading,
    /// this method increments the file's offset by the number of bytes read.
    /// To change the file's offset,
    /// call the ``seek(offset:from:)`` method.
    ///
    /// The corresponding C function is `read`.
    @_alwaysEmitIntoClient
    func read<S>(
      into sequence: inout S,
      retryOnInterrupt: Bool = true,
      sleepOnBlock sleep: UInt64 = 1000
    ) async throws -> Int where S: MutableCollection, S.Element == UInt8  {
        try await _read(
            into: &sequence,
            retryOnInterrupt: retryOnInterrupt,
            sleepOnBlock: sleep
        )
    }
    
    @usableFromInline
    internal func _read<S>(
      into sequence: inout S,
      retryOnInterrupt: Bool,
      sleepOnBlock sleep: UInt64
    ) async throws -> Int where S: MutableCollection, S.Element == UInt8 {
        try await retryOnBlock(sleep: sleep) {
            sequence._withMutableRawBufferPointer { buffer in
                _read(into: buffer, retryOnInterrupt: retryOnInterrupt)
            }
        }.get()
    }
    
    /// Writes the contents of a buffer at the current file offset.
    ///
    /// - Parameters:
    ///   - buffer: The region of memory that contains the data being written.
    ///   - retryOnInterrupt: Whether to retry the write operation
    ///     if it throws ``Errno/interrupted``.
    ///     The default is `true`.
    ///     Pass `false` to try only once and throw an error upon interruption.
    ///   - sleepOnBlock: The number of nanoseconds to sleep if the operation
    ///     throws ``Errno/wouldBlock`` or other async I/O errors.
    /// - Returns: The number of bytes that were written.
    ///
    /// After writing,
    /// this method increments the file's offset by the number of bytes written.
    /// To change the file's offset,
    /// call the ``seek(offset:from:)`` method.
    ///
    /// The corresponding C function is `write`.
    @_alwaysEmitIntoClient
    func write<S>(
        _ bytes: S,
        retryOnInterrupt: Bool = true,
        sleepOnBlock sleep: UInt64 = 1000
    ) async throws -> Int where S: Sequence, S.Element == UInt8 {
        return try await _write(
            bytes,
            retryOnInterrupt: retryOnInterrupt,
            sleepOnBlock: sleep
        )
    }
    
    @usableFromInline
    internal func _write<S>(
        _ bytes: S,
        retryOnInterrupt: Bool,
        sleepOnBlock sleep: UInt64
    ) async throws -> Int where S: Sequence, S.Element == UInt8 {
        try await retryOnBlock(sleep: sleep) {
            bytes._withRawBufferPointer { buffer in
                _write(buffer, retryOnInterrupt: retryOnInterrupt)
            }
        }.get()
    }
}

@available(macOS 12, iOS 15, *)
internal extension FileDescriptor {
    
    /// Pauses the current task if the operation throws ``Errno/wouldBlock`` or other async I/O errors.
    @usableFromInline
    func retryOnBlock<T>(
        sleep nanoseconds: UInt64,
        _ body: () -> Result<T, Errno>
    ) async throws -> Result<T, Errno> {
        repeat {
            try Task.checkCancellation()
            switch body() {
            case let .success(result):
                return .success(result)
            case let .failure(error):
                guard error.isBlocking else {
                    return .failure(error)
                }
                try await Task.sleep(nanoseconds: nanoseconds)
            }
        } while true
    }
}

internal extension Errno {
    
    var isBlocking: Bool {
        switch self {
        case .wouldBlock,
            .nowInProgress,
            .alreadyInProcess,
            .resourceTemporarilyUnavailable:
            return true
        default:
            return false
        }
    }
}
#endif
