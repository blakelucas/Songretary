import AudioKit
import Controls
import SoundpipeAudioKit
import SwiftUI
import Foundation

//struct TuningForkView_Preview: PreviewProvider {
//    static var previews: some View {
//        TuningForkView()
//    }
//}

public class TuningFork {
    let engine = AudioEngine()
    let player = AudioPlayer()
    // Initialize oscillator at piano middle C (261.63Hz)
    let osc = Oscillator(frequency: 261.63, amplitude: 0.5)
    
    let noteFrequencies: [Float] = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let notesSharp = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let notesFlat = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    @Published var isPlaying = false
    var octave: Float = 5.0
    var currNoteIndex: Int = 0
    var useSharps: Bool = true
    //@Published var currNoteName: String
    
//    init() {
//        currNoteName = notesSharp[currNoteIndex]
//    }
    
    // Start oscillator and sound engine
    func start() {
        osc.start()
        engine.output = osc
        do {
            try engine.start()
            isPlaying = true
        } catch let err {
            print("#@25 engine did not start\(err.localizedDescription)")
        }
    }
    
    // Stop oscillator and sound engine
    func stop() {
        osc.stop()
        engine.stop()
        isPlaying = false
    }
    
    // Tune frequency
    func tune(_ freq: Float) {
        osc.frequency = (freq * (pow(2, octave)))
        currNoteIndex = noteFrequencies.firstIndex(of: freq) ?? 0
        // currNoteName = notesSharp[currNoteIndex]
    }
    
    // Up one octave
    func octaveUp() {
        octave += 1
        osc.frequency = (osc.frequency * 2)
    }
    
    // Down one octave
    func octaveDown() {
        octave -= 1
        osc.frequency = (osc.frequency / 2)
    }
    
    // Frequency getter
    func getCurrFreq() -> Float {
        return osc.frequency
    }
    
    // Octave getter
    func getOctave() -> Float {
        return octave
    }
    
    func getUseSharps() -> Bool {
        return useSharps
    }
    
    func getCurrentNoteName(useSharps: Bool = true) -> String {
        let noteNames = useSharps ? notesSharp : notesFlat
        let noteNameIndex = currNoteIndex % noteNames.count
        return noteNames[noteNameIndex]
    }
}
