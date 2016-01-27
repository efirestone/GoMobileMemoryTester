package GoMemory

import (
    "runtime/debug"
    "time"
)

func Initialize() {
    // Disable the GC for debugging.
    //debug.SetGCPercent(-1)

    debug.SetGCPercent(1)

    // Periodically force a GC flush
    //go periodicFree(1 * time.Minute)
}

func LastGCTime() string {
    var stats = new(debug.GCStats)
    debug.ReadGCStats(stats)

    return stats.LastGC.String()
}

func periodicFree(d time.Duration) {
    tick := time.Tick(d)
    for _ = range tick {
        debug.FreeOSMemory()
    }
}
