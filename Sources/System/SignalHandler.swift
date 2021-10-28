/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

public extension Signal {
    
    /// POSIX Signal Handler
    @frozen
    struct Handler: RawRepresentable {
        
        public let rawValue: CInterop.SignalFunction?
        
        public init(rawValue: CInterop.SignalFunction?) {
            self.rawValue = rawValue
        }
    }
}

public extension Signal {
    
    @_alwaysEmitIntoClient
    @discardableResult
    func handle(_ handler: Handler) -> Handler {
        return _handle(handler)
    }
    
    @usableFromInline
    internal func _handle(_ handler: Handler) -> Handler {
        return Handler(rawValue: system_signal(self.rawValue, handler.rawValue))
    }
}

public extension Signal.Handler {
    
    /// Default signal handler
    @_alwaysEmitIntoClient
    static var `default`: Signal.Handler { Signal.Handler(rawValue: _SIG_DFL) }
    
    /// Signal handler for ignoring signals
    @_alwaysEmitIntoClient
    static var ignore: Signal.Handler { Signal.Handler(rawValue: _SIG_IGN) }
    
    /// Signal handler for ignoring signals
    @_alwaysEmitIntoClient
    internal static var error: Signal.Handler { Signal.Handler(rawValue: _SIG_ERR) }
    
    /// Default signal handler
    @_alwaysEmitIntoClient
    static var hold: Signal.Handler { Signal.Handler(rawValue: _SIG_HOLD) }
}
