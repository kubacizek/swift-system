/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

public extension Signal {
    
    /// POSIX Signal Handler
    @frozen
    struct Action {
        
        @usableFromInline
        internal fileprivate(set) var bytes: CInterop.SignalAction
        
        @usableFromInline
        internal init(_ bytes: CInterop.SignalAction) {
            self.bytes = bytes
        }
        
        @_alwaysEmitIntoClient
        public init(
            handler: Signal.Handler,
            mask: Signal.Set = Signal.Set(),
            flags: CInt = 0x00
        ) {
            self.init(CInterop.SignalAction(
                __sigaction_u: .init(__sa_handler: handler.rawValue),
                sa_mask: mask.bytes,
                sa_flags: flags)
            )
        }
        
        @_alwaysEmitIntoClient
        internal init() {
            self.init(CInterop.SignalAction())
        }
    }
}

public extension Signal.Action {
    
    @_alwaysEmitIntoClient
    var flags: CInt {
        return bytes.sa_flags
    }
    
    @_alwaysEmitIntoClient
    var mask: Signal.Set {
        return Signal.Set(bytes.sa_mask)
    }
}

public extension Signal {
    
    @discardableResult
    @_alwaysEmitIntoClient
    func handle(_ handler: Handler, retryOnInterrupt: Bool = true) throws -> Signal.Action {
        return try _handle(handler, retryOnInterrupt: retryOnInterrupt).get()
    }
    
    @usableFromInline
    internal func _handle(_ handler: Handler, retryOnInterrupt: Bool) -> Result<Signal.Action, Errno> {
        var action = Signal.Action(handler: handler)
        var oldAction = Signal.Action()
        return nothingOrErrno(retryOnInterrupt: retryOnInterrupt) {
            system_sigaction(self.rawValue, &action.bytes, &oldAction.bytes)
        }.map { oldAction }
    }
}
