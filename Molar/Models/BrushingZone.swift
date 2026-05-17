import Foundation

struct BrushingZone: Identifiable, Equatable, Hashable {
    let id: Int

    static let all: [BrushingZone] = (1...14).map { BrushingZone(id: $0) }
}
