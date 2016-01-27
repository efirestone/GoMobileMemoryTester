//
//  Created by Eric Firestone on 1/26/16.
//  Copyright © 2016 Square, Inc. All rights reserved.
//

import UIKit

extension UIDevice {
    func currentMemoryUsage() -> UInt64 {
        let port = mach_task_self_
        let flavor = task_flavor_t(TASK_BASIC_INFO)
        let basicInfo = task_basic_info()
        var size: mach_msg_type_number_t = mach_msg_type_number_t(sizeofValue(basicInfo))
        let pointerOfBasicInfo = UnsafeMutablePointer<task_basic_info>.alloc(1)
        
        let kerr: kern_return_t = task_info(port, flavor, UnsafeMutablePointer(pointerOfBasicInfo), &size)
        let info = pointerOfBasicInfo.move()
        pointerOfBasicInfo.dealloc(1)
        
        guard kerr == KERN_SUCCESS else {
            return 0//throw Error.KernelError(result: kerr)
        }
        
        return UInt64(info.resident_size)
    }
}
