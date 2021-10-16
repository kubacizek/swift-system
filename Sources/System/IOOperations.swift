/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

extension FileDescriptor {
    
    /// Manipulates the underlying device parameters of special files.
    @usableFromInline
    internal func _inputOutput(
        _ request: IOControlID,
        retryOnInterrupt: Bool
    ) -> Result<(), Errno> {
        nothingOrErrno(retryOnInterrupt: retryOnInterrupt) {
            system_ioctl(self.rawValue, request.rawValue)
        }
    }
    
    /// Manipulates the underlying device parameters of special files.
    @usableFromInline
    internal func _inputOutput<T: IOControlInteger>(
        _ control: T,
        retryOnInterrupt: Bool
    ) -> Result<(), Errno> {
        nothingOrErrno(retryOnInterrupt: retryOnInterrupt) {
            system_ioctl(self.rawValue, T.id.rawValue, control.intValue)
        }
    }
    
    /// Manipulates the underlying device parameters of special files.
    @usableFromInline
    internal func _inputOutput<T: IOControlValue>(
        _ control: inout T,
        retryOnInterrupt: Bool
    ) -> Result<(), Errno> {
        nothingOrErrno(retryOnInterrupt: retryOnInterrupt) {
            control.withUnsafeMutablePointer { pointer in
                system_ioctl(self.rawValue, T.id.rawValue, pointer)
            }
        }
    }
}
