package GoMemory

const chunkSize = 10485760 // 10MB

type MemoryChunk struct {
    bytes [chunkSize]byte
}

func MemoryChunkSize() int64 {
    return chunkSize
}

func NewMemoryChunk() *MemoryChunk {
    var chunk = new(MemoryChunk)
    chunk.initialize()

    return chunk
}

func (m *MemoryChunk)initialize() {
    for i := 0; i < len(m.bytes); i++ {
        m.bytes[i] = 0
    }
}
