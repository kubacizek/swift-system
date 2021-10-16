/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// Input / Output Request identifier for manipulating underlying device parameters of special files.
@frozen
// @available(macOS 10.16, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public struct IOControlID: RawRepresentable, Hashable, Codable {
    
    /// The raw C IO request.
    @_alwaysEmitIntoClient
    public let rawValue: CUnsignedLong

    /// Create a strongly-typed file events from a raw C IO request.
    @_alwaysEmitIntoClient
    public init(rawValue: CUnsignedLong) { self.rawValue = rawValue }

    @_alwaysEmitIntoClient
    private init(_ raw: CUnsignedLong) { self.init(rawValue: raw) }
}

#if os(macOS)

#endif

#if os(Linux)

#endif

public protocol IOControlInteger {
    
    static var id: IOControlID { get }
    
    var intValue: Int32 { get }
}

public protocol IOControlValue {
    
    static var id: IOControlID { get }
    
    mutating func withUnsafeMutablePointer<Result>(_ body: (UnsafeMutableRawPointer) throws -> (Result)) rethrows -> Result
}
