/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

public extension Signal {
    
    /// Signal Information
    @frozen
    struct Information {
        
        @usableFromInline
        internal let bytes: CInterop.SignalInformation
        
        @usableFromInline
        internal init(_ bytes: CInterop.SignalInformation) {
            self.bytes = bytes
        }
    }
}

public extension Signal.Information {
    
    /// Signal
    var id: Signal { /* signal number */
        return .init(rawValue: bytes.si_signo)
    }
    
    /// Error
    var error: Errno? { /* errno association */
        return bytes.si_errno == 0 ? nil : Errno(rawValue: bytes.si_errno)
    }
    
    var code: Int32 { /* signal code */
        return bytes.si_code
    }

    var process: ProcessID { /* sending process */
        return .init(rawValue: bytes.si_pid)
    }

    var user: CInterop.UserID { /* sender's ruid */
        return bytes.si_uid
    }

    var status: Int32 { /* exit value */
        return bytes.si_status
    }

    var address: UnsafeMutableRawPointer? { /* faulting instruction */
        return bytes.si_addr
    }

    var value: CInterop.SignalValue { /* signal value */
        return bytes.si_value
    }

    var band: Int { /* band event for SIGPOLL */
        return bytes.si_band
    }
}
