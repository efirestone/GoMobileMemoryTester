//
//  Created by Eric Firestone on 1/26/16.
//  Copyright © 2016 Square, Inc. All rights reserved.
//

import Foundation
import GoMemory

final class GoMobileMemoryManager {
    var allocatedChunkCount: Int {
        return allocatedMemory.count
    }
    var chunkSize: Int {
        return Int(GoGoMemoryMemoryChunkSize())
    }
    private var allocatedMemory = [GoGoMemoryMemoryChunk]()
    
    init() {
        GoGoMemoryInitialize()
    }
    
    func increaseMemory() {
        let chunk = GoGoMemoryNewMemoryChunk()
        allocatedMemory.append(chunk)
    }
    
    func decreaseMemory() {
        guard allocatedMemory.count > 0 else {
            return;
        }
        
        allocatedMemory.removeLast()
    }
}
