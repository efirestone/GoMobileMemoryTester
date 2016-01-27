//
//  Created by Eric Firestone on 1/26/16.
//  Copyright © 2016 Square, Inc. All rights reserved.
//

import Foundation

final class NativeMemoryManager {
    var allocatedChunkCount: Int {
        return allocatedMemory.count
    }
    let chunkSize = Int(10_485_760) // 10MB
    
    private var allocatedMemory = [[UInt8]]()
    
    func increaseMemory() {
        let chunk = [UInt8](count: Int(chunkSize), repeatedValue: 0)
        allocatedMemory.append(chunk)
    }
    
    func decreaseMemory() {
        guard allocatedMemory.count > 0 else {
            return;
        }
        
        allocatedMemory.removeLast()
    }
}
