//
//  Created by Eric Firestone on 1/26/16.
//  Copyright © 2016 Square, Inc. All rights reserved.
//

import GoMemory
import UIKit

class MemoryTestController: UIViewController {

    @IBOutlet var increaseNativeMemoryButton: UIButton!
    @IBOutlet var decreaseNativeMemoryButton: UIButton!
    @IBOutlet var nativeMemoryChunkCountLabel: UILabel!
    
    @IBOutlet var increaseGoMobileMemoryButton: UIButton!
    @IBOutlet var decreaseGoMobileMemoryButton: UIButton!
    @IBOutlet var goMobileMemoryChunkCountLabel: UILabel!
    
    @IBOutlet var memoryWarningLabel: UILabel!
    @IBOutlet var memoryUsageLabel: UILabel!
    
    @IBOutlet var lastGCTimeLabel: UILabel!
    
    private var goMobileMemoryManager = GoMobileMemoryManager()
    private var nativeMemoryManager = NativeMemoryManager()
    
    private var timer: NSTimer?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerDidFire:", userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        memoryWarningLabel.hidden = false
    }
    
    // MARK: - Public Methods - Actions
    
    @IBAction func decreaseGoMobileMemory() {
        goMobileMemoryManager.decreaseMemory()
        
        refreshUI()
    }
    
    @IBAction func decreaseNativeMemory() {
        nativeMemoryManager.decreaseMemory()
        
        refreshUI()
    }
    
    @IBAction func increaseGoMobileMemory() {
        goMobileMemoryManager.increaseMemory()
        
        refreshUI()
    }
    
    @IBAction func increaseNativeMemory() {
        nativeMemoryManager.increaseMemory()
        
        refreshUI()
    }
    
    func timerDidFire(timer: NSTimer) {
        refreshUI()
    }
    
    // MARK: - Private Methods
    
    private func refreshUI() {
        let byteFormatter = NSByteCountFormatter()
        byteFormatter.countStyle = NSByteCountFormatterCountStyle.Memory

        goMobileMemoryChunkCountLabel.text = byteFormatter.stringForObjectValue(NSNumber(long: goMobileMemoryManager.allocatedChunkCount * goMobileMemoryManager.chunkSize))
        nativeMemoryChunkCountLabel.text = byteFormatter.stringForObjectValue(NSNumber(long: nativeMemoryManager.allocatedChunkCount * nativeMemoryManager.chunkSize))
        
        memoryUsageLabel.text = byteFormatter.stringForObjectValue(NSNumber(long: Int(UIDevice.currentDevice().currentMemoryUsage())))
        
        lastGCTimeLabel.text = "Last GC: \(GoGoMemoryLastGCTime())"
        
        memoryWarningLabel.hidden = true
    }
}

