import SwiftUI

struct TuningForkView: View {
    @State private var isTapped = false
    //@ObservedObject var tuningFork: TuningFork
    @State private var displayNote = "C"
    @State private var displayOctave: Float = 4.0
    @State private var displayFreq: Float = 261.63
    
    var body: some View {
        
        let tuningFork = TuningFork()
        
        VStack {
            // Note info display
            VStack {
                Text(displayNote)
                    .font(.system(size: 125))
                    .fontWeight(.bold)
                Text(String(format: "%.0f", displayOctave - 1))
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                Text(String(displayFreq) + " Hz")
            }.padding(.bottom, 100)
            
            //            // **NOTE: Does not work
            //            Button(action: {tuningFork.useSharps.toggle()}) {
            //                Text("Use Sharps (does not work)")
            //            }.padding()
            
            
            // Note buttons
            HStack {
                // **NOTE: Will not toggle sharps
                ForEach(0..<tuningFork.noteFrequencies.count) { index in
                    Button(action: {
                        tuningFork.tune(tuningFork.noteFrequencies[index])
                        // Change display note
                        displayNote = tuningFork.notesSharp[index]
                        // Change display freq
                        displayFreq = tuningFork.getCurrFreq()
                    }) {
                        Text(tuningFork.getUseSharps() ? tuningFork.notesSharp[index] : tuningFork.notesFlat[index])
                    }
                }
            }
            
            // Octave up/down button
            VStack {
                Text("**Octave**").padding(.top, 10)
                HStack {
                    Button(action: {
                        tuningFork.octaveUp()
                        displayOctave = tuningFork.getOctave()
                    }) {
                        Image(systemName: "plus")
                    }.padding(1).font(Font.title.weight(.medium))
                
                    Button(action: {
                        tuningFork.octaveDown()
                    displayOctave = tuningFork.getOctave()
                    }) {
                        Image(systemName: "minus")
                    }.padding(1).font(Font.title.weight(.medium))
                }.padding(.bottom, 10)
            }
            
            // Toggle button **NOTE: Text toggling not working,
            //   causing oscillator to not start
            Button(action: {
                if tuningFork.isPlaying {
                    tuningFork.stop()
                } else {
                    tuningFork.start()
                }
                //isTapped.toggle()
            }) {
                // Text(isTapped ? "Stop" : "Start")
                Text("Toggle")
                    .frame(width: 100, height: 50)
                    .font(.system(size: 25))
                    .fontWeight(.bold)
            }
        }
    }
}

struct TuningForkView_Previews: PreviewProvider {
    static var previews: some View {
        TuningForkView()
    }
}
