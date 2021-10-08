/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// POSIX Socket Option ID
public protocol SocketOption {
    
    associatedtype ID: SocketOptionID
    
    static var id: ID { get }
    
    func withUnsafeBytes<T>(_: ((UnsafeRawBufferPointer) -> (T))) -> T
}

/// Platform Socket Option
@frozen
public enum GenericSocketOption {
    
    @frozen
    public struct Debug: SocketOption, Equatable, Hashable {
        
        @_alwaysEmitIntoClient
        public static var id: GenericSocketOptionID { .debug }
        
        public var isEnabled: Bool
        
        @_alwaysEmitIntoClient
        public init(isEnabled: Bool) {
            self.isEnabled = true
        }
        
        @_alwaysEmitIntoClient
        public func withUnsafeBytes<T>(_ pointer: ((UnsafeRawBufferPointer) -> (T))) -> T {
            return Swift.withUnsafeBytes(of: isEnabled.cInt) { bufferPointer in
                pointer(bufferPointer)
            }
        }
    }
    
    @frozen
    public struct KeepAlive: SocketOption, Equatable, Hashable {
        
        @_alwaysEmitIntoClient
        public static var id: GenericSocketOptionID { .keepAlive }
        
        public var isEnabled: Bool
        
        @_alwaysEmitIntoClient
        public init(isEnabled: Bool) {
            self.isEnabled = true
        }
        
        @_alwaysEmitIntoClient
        public func withUnsafeBytes<T>(_ pointer: ((UnsafeRawBufferPointer) -> (T))) -> T {
            return Swift.withUnsafeBytes(of: isEnabled.cInt) { bufferPointer in
                pointer(bufferPointer)
            }
        }
    }
}
