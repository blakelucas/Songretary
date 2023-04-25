import SwiftUI
import AudioKitUI

/*
 The main view.
 A simple VStack with a start/stop button, TempoStepper, and descriptive text.
 */
struct MetronomeView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    // An instance of the object defined above. Handles Audio
    @StateObject var conductor = Metronome()

    var body: some View {
        VStack(spacing: 10) {
            
            Text("Slide up and down to choose tempo")
                .padding(10)
            
            // Why does it have those weird visuals?
            ZStack {
                TempoDraggableStepper(tempo: $conductor.tempo).padding(200)
                Circle().strokeBorder(isDarkMode ? Color.black : Color.white, lineWidth: 70)
                    .foregroundColor(.clear).frame(width: 355)
            }
            
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
            //conductor = Metronome()
            conductor.start()
        }
        .onDisappear {
            //Stopping conductor caused sound to reset to oscillator
//            conductor.stop()
        }
    }
}
