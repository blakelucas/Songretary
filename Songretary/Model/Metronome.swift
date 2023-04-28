/*
 @author: Phillip Lavey
 Metronome View!
 Slide up and down on the BPM number to change tempo
 
 NOTE: There is a known bug with Apple's audio engine that can cause it to stutter when it starts up, so starting the metronome might not be perfectly accurate...
*/

import AudioKit
import AudioKitUI
import AVFoundation
import SwiftUI

let url = Bundle.main.url(forResource: "blick", withExtension: "wav")
let midiUrl = Bundle.main.url(forResource: "4channel_150", withExtension: "mid")

/*
 Controller for metronome
 */
class MetronomeConductor: ObservableObject, HasAudioEngine {
    
    let engine = AudioEngine()
    let click = MIDISampler(name: "Click")
    let sequencer = AppleSequencer(fromURL: midiUrl!)

    @Published var tempo: Float = 120 {
        didSet {
            sequencer.setTempo(BPM(tempo))
        }
    }

    @Published var isPlaying = false {
        didSet {
            isPlaying ? sequencer.play() : sequencer.stop()
        }
    }

    // Runs when object constructed
    init() {
        
        let callbacker = MIDICallbackInstrument { [self] status, note, _ in
                    guard let midiStatus = MIDIStatusType.from(byte: status) else {
                        return
                    }
                    if midiStatus == .noteOn {
                        DispatchQueue.main.async {
                            let hapt = UIImpactFeedbackGenerator(style: .heavy)
                            hapt.impactOccurred()
                            print("feedback")
                        }
                        
                        visualize()
                    }
                }
        
        // Set engine output to MIDI Sampler
        engine.output = click
        
        // Attempt loading audio file
        // TODO: Add multiple audio files and enable polyrhythm
        do {
            try click.loadAudioFile(try AVAudioFile(forReading: url!))
        }
        catch {
            Log("Files Didn't Load")
            // Should continue any but no audio will play??
        }
        
        // Sequencer Setup
        sequencer.clearRange(start: Duration(beats: 0), duration: Duration(beats: 100))
        sequencer.debug()
        sequencer.setGlobalMIDIOutput(click.midiIn)
        sequencer.enableLooping()
        sequencer.setTempo(120)

        // Add four note events to midi track:
        // One high pitched on every downbeat followed by three lower pitched on subsequent beats
        sequencer.tracks[0].add(noteNumber: 70, velocity: 80, position: Duration(beats: 0), duration: Duration(beats: 1))

        sequencer.tracks[0].add(noteNumber: 64, velocity: 80, position: Duration(beats: 1), duration: Duration(beats: 1))
        
        sequencer.tracks[0].add(noteNumber: 64, velocity: 80, position: Duration(beats: 2), duration: Duration(beats: 1))
        
        sequencer.tracks[0].add(noteNumber: 64, velocity: 80, position: Duration(beats: 3), duration: Duration(beats: 1))

        // TODO: Allow for different time signatures and polyrhythm.
    }
    
    func visualize() {
        
    }
}

/*
 The main view.
 A simple VStack with a start/stop button, TempoStepper, and descriptive text.
 */
struct MetronomeView: View {
    
    // An instance of the object defined above. Handles Audio
    @StateObject var conductor = MetronomeConductor()

    var body: some View {
        VStack(spacing: 10) {
            
            Text("Slide up and down to choose tempo")
                .padding(10)
            
            // Why does it have those weird visuals?
            TempoDraggableStepper(tempo: $conductor.tempo).padding(200)
            
            Button(conductor.isPlaying ? "Stop" : "Start") {
                conductor.isPlaying.toggle()
                // Rewind when stopped
                if !conductor.isPlaying {
                    conductor.sequencer.rewind()
                }
            
            }
            .bold()
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .controlSize(.large)
            
            // TODO: Make visuals for metronome
            // TODO: Allow for user-typed tempo input
        }
        .padding(5)
        .onAppear {
            conductor.start()
        }
        .onDisappear {
            conductor.stop()
        }
    }
}


