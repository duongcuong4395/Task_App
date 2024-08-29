//
//  HapticManage.swift
//  MyTasks
//
//  Created by pc on 29/08/2024.
//

import Foundation
import SwiftUI


extension View {
    func selectionChanged(){
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
    }
    
    func lightEffect(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
    }
    
    func mediumEffect(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
    }
    
    func heavyEffect(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
    }
    
    func successHaptic(){
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.error)
    }
    
    func warningHaptic(){
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success)
    }
    
    func errorHaptic(){
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.warning)
    }
    
    
}

import CoreHaptics
protocol HapticsEvent {
    var engine: CHHapticEngine? { get set }
}

extension HapticsEvent {
    mutating func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try self.engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        //let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        //let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try self.engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    
    // Light Effect
    func lightEffect() {
        playHaptic(intensity: 0.3, sharpness: 0.5, duration: 0.1)
    }

    // Medium Effect
    func mediumEffect() {
        playHaptic(intensity: 0.6, sharpness: 0.5, duration: 0.2)
    }

    // Heavy Effect
    func heavyEffect() {
        playHaptic(intensity: 1.0, sharpness: 0.8, duration: 0.3)
    }

    // Success Haptic
    func successHaptic() {
        playHapticPattern(intensities: [0.6, 0.4, 0.8], sharpnesses: [0.5, 0.5, 0.8], durations: [0.1, 0.1, 0.2], relativeTimes: [0, 0.1, 0.2])
    }

    // Warning Haptic
    func warningHaptic() {
        playHapticPattern(intensities: [0.8, 0.7, 0.9], sharpnesses: [0.5, 0.5, 0.7], durations: [0.15, 0.15, 0.3], relativeTimes: [0, 0.2, 0.4])
    }

    // Error Haptic
    func errorHaptic() {
        playHapticPattern(intensities: [1.0, 0.8, 1.0], sharpnesses: [0.8, 0.6, 0.9], durations: [0.3, 0.1, 0.4], relativeTimes: [0, 0.2, 0.4])
    }
    
    private func playHapticPattern(intensities: [Float], sharpnesses: [Float], durations: [TimeInterval], relativeTimes: [TimeInterval]) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        for (index, intensity) in intensities.enumerated() {
            let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
            let sharpnessParam = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpnesses[index])
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensityParam, sharpnessParam], relativeTime: relativeTimes[index])
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try self.engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic pattern: \(error.localizedDescription)")
        }
    }
    
    private func playHaptic(intensity: Float, sharpness: Float, duration: TimeInterval) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpnessParam = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensityParam, sharpnessParam], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try self.engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }
}

class HapticsManager: ObservableObject {
    private var engine: CHHapticEngine?
    
    init() {
        prepareHaptics()
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func playHaptic(intensity: Float, sharpness: Float, duration: TimeInterval) {
        guard let engine = engine else { return }
        
        let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpnessParam = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensityParam, sharpnessParam], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }
    
    func successHaptic() {
        playHapticPattern(intensities: [0.6, 0.4, 0.8], sharpnesses: [0.5, 0.5, 0.8], durations: [0.1, 0.1, 0.2], relativeTimes: [0, 0.1, 0.2])
    }
    
    func warningHaptic() {
        playHapticPattern(intensities: [0.8, 0.7, 0.9], sharpnesses: [0.5, 0.5, 0.7], durations: [0.15, 0.15, 0.3], relativeTimes: [0, 0.2, 0.4])
    }
    
    func errorHaptic() {
        playHapticPattern(intensities: [1.0, 0.8, 1.0], sharpnesses: [0.8, 0.6, 0.9], durations: [0.3, 0.1, 0.4], relativeTimes: [0, 0.2, 0.4])
    }
    
    private func playHapticPattern(intensities: [Float], sharpnesses: [Float], durations: [TimeInterval], relativeTimes: [TimeInterval]) {
        guard let engine = engine else { return }
        var events = [CHHapticEvent]()
        
        for (index, intensity) in intensities.enumerated() {
            let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
            let sharpnessParam = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpnesses[index])
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensityParam, sharpnessParam], relativeTime: relativeTimes[index])
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play haptic pattern: \(error.localizedDescription)")
        }
    }
}
