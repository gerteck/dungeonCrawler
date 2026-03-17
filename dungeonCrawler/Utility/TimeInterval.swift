import Foundation

struct TimeInterval {
    var startTime: Float?
    let duration: Float

    init(duration: Float) {
        self.duration = duration
    }

    init(startTime: Float, duration: Float) {
        self.startTime = startTime
        self.duration = duration
    }

    mutating func start(at time: Float) {
        startTime = time
    }

    func isRunning(at time: Float) -> Bool {
        guard let startTime = startTime {
            return time >= startTime && time < startTime + duration
        }
        return false
    }
}