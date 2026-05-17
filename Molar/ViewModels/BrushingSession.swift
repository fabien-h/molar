import Foundation
import Observation
import UIKit
import AudioToolbox

enum SessionState: Equatable {
    case idle
    case running
    case paused
    case completed
}

@MainActor
@Observable
final class BrushingSession {
    static let secondsPerZone: Int = 10

    private(set) var state: SessionState = .idle
    var currentZoneIndex: Int = 0
    var secondsRemaining: Int = BrushingSession.secondsPerZone

    @ObservationIgnored private var timer: Timer?

    var currentZone: BrushingZone {
        BrushingZone.all[currentZoneIndex]
    }

    var totalZones: Int { BrushingZone.all.count }

    var totalSeconds: Int { totalZones * Self.secondsPerZone }

    var elapsedSeconds: Int {
        currentZoneIndex * Self.secondsPerZone + (Self.secondsPerZone - secondsRemaining)
    }

    var overallProgress: Double {
        Double(elapsedSeconds) / Double(totalSeconds)
    }

    func start() {
        currentZoneIndex = 0
        secondsRemaining = Self.secondsPerZone
        state = .running
        scheduleTimer()
    }

    func pause() {
        guard state == .running else { return }
        state = .paused
        invalidateTimer()
    }

    func resume() {
        guard state == .paused else { return }
        state = .running
        scheduleTimer()
    }

    func reset() {
        invalidateTimer()
        currentZoneIndex = 0
        secondsRemaining = Self.secondsPerZone
        state = .idle
    }

    func skipToNextZone() {
        advanceZone()
    }

    private func scheduleTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        guard state == .running else { return }
        if secondsRemaining > 1 {
            secondsRemaining -= 1
        } else {
            advanceZone()
        }
    }

    private func advanceZone() {
        if currentZoneIndex + 1 >= totalZones {
            secondsRemaining = 0
            state = .completed
            invalidateTimer()
            playCompletionFeedback()
        } else {
            currentZoneIndex += 1
            secondsRemaining = Self.secondsPerZone
            playZoneChangeFeedback()
        }
    }

    private func playZoneChangeFeedback() {
        AudioServicesPlaySystemSound(1057)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    private func playCompletionFeedback() {
        AudioServicesPlaySystemSound(1025)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
