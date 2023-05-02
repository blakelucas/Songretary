//current 1:26 5/2/23

import AudioKit
import AudioKitEX
import AudioKitUI
import AudioToolbox
import SoundpipeAudioKit
import SwiftUI

struct Note {
    var letter: String
    let date = Date().timeIntervalSince1970 * 1000
    var time: Double
}

struct Notel: Hashable {
    var letter: String
    var type: String
    var xpos: Double
    var ypos: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(letter)
        hasher.combine(type)
        hasher.combine(xpos)
        hasher.combine(ypos)
    }
}

struct TransposerData {
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
    var noteNameWithSharps = [Note]()
    var noteNameWithFlats = [Note]()
    var isRecording = false
    var oldNote = Note(letter: " ", time: 0.0)
    var notes = [Note]()
    var noteL = [Notel]()
    var timer = Timer()
    var timeInterval: Float = 0.0
    var oldTime: Float = 0.0
    var i = 0
    var recordingStartDate: Double = 0.0
    var currLine: Float = 0.0
    var xOffset: Float = 0.0
    var yOffset: Float = 0.0

}

class TransposerConductor: ObservableObject, HasAudioEngine {
    @Published var data = TransposerData()
    var timer: Timer?
    let engine = AudioEngine()
    let initialDevice: Device
    
    let mic: AudioEngine.InputNode
    let tappableNodeA: Fader
    let tappableNodeB: Fader
    let tappableNodeC: Fader
    let silence: Fader
    
    var tracker: PitchTap!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    
    
    func printNotes(bpm: Int)
    {
        var noteListWithTiming = self.noteAggregate(bpm: bpm)
        if noteListWithTiming.isEmpty {
            print("No notes detected")
            return
        }
        if noteListWithTiming.first?.letter == "-" {noteListWithTiming.removeFirst()}
        data.noteL = noteListWithTiming
    }
    init() {
        guard let input = engine.input else { fatalError() }
        
        guard let device = engine.inputDevice else { fatalError() }
        
        initialDevice = device
        
        mic = input
        tappableNodeA = Fader(mic)
        tappableNodeB = Fader(tappableNodeA)
        tappableNodeC = Fader(tappableNodeB)
        silence = Fader(tappableNodeC, gain: 0)
        engine.output = silence
        
        
        tracker = PitchTap(mic) { pitch, amp in
                DispatchQueue.main.async {
                    if self.data.isRecording {
                        let n = self.update(pitch[0], amp[0])
                        if self.data.notes.isEmpty {
                            self.data.recordingStartDate = Date().timeIntervalSince1970 * 1000
                            self.data.notes.append(n)
                        }
                        else if !(n.time >= (4 * self.data.notes.last!.time)) {
                            self.data.notes.append(n)
                        }
                }
            }
        }
        tracker.start()
    }
    
    func resetData() {
        data.pitch = 0.0
        data.amplitude = 0.0
        data.noteNameWithSharps = [Note]()
        data.noteNameWithFlats = [Note]()
        data.isRecording = false
        data.oldNote = Note(letter: " ", time: 0.0)
        data.notes = [Note]()
        data.noteL = [Notel]()
        data.timer = Timer()
        data.timeInterval = 0.0
        data.oldTime = 0.0
        data.i = 0
        data.recordingStartDate = 0.0
        data.xOffset = 0.0
        data.yOffset = 0.0
        data.currLine = 0
    }
    
    func noteAggregate(bpm: Int) -> [Notel]
    {
        let b = Double(bpm)
        var noteList = [Notel]()
        var tempList = [Note]()
        if self.data.notes.isEmpty {
            return noteList
        }
        var temp = self.data.notes[0]
        print("---")
        var length = temp.time
        for note in self.data.notes {
            if temp.letter == note.letter {
                if temp.date != note.date {
                    length += note.time
                }
            }
            else {
                tempList.append(Note(letter: temp.letter, time: length))
                length = note.time
            }
            temp = note
        }
        print("---")
        if tempList.isEmpty {
            return noteList
        }
        temp = tempList[0]
        var c = 0
        for note in tempList {
            let noteLengthInSeconds = note.time // Replace this with the actual length of the note in seconds
            let quarterNoteDuration = 60000/b
            
            let wholeNoteDuration = 4 * quarterNoteDuration // In seconds
            let halfNoteDuration = 2 * quarterNoteDuration // In seconds
            let eighthNoteDuration = (1/2) * quarterNoteDuration // In seconds
            _ = 250.00 // In seconds
            
            var xp = 40.0
            var yp = -12.0
            if (c == 0) {
                xp = 40.0
            }
            else if (c < 13) {
                xp = noteList.last!.xpos + 25
            }
            else {
                xp = 25.0
                c = 0
                data.currLine += 1
            }
            c += 1
            if note.letter != "-" {
                var digit = Int(String(note.letter.last!))
                if digit! < 4 {
                    digit = 4
                }
                else if digit! > 5 {
                    digit = 5
                }
                switch note.letter.first! {
                case "A":
                    if digit == 5 {
                        yp = -15 + Double(69 * data.currLine)
                    }
                    else {
                        yp = 27 + Double(69 * data.currLine)
                    }
                case "B":
                    if digit == 5 {
                        yp = -21 + Double(69 * data.currLine)
                    }
                    else {
                        yp = 21 + Double(69 * data.currLine)
                    }
                case "C":
                    if digit == 5 {
                        yp = 12 + Double(69 * data.currLine)
                    }
                    else {
                        yp = 56 + Double(69 * data.currLine)
                    }
                case "D":
                    if digit == 5 {
                        yp = 9 + Double(69 * data.currLine)
                    }
                    else {
                        yp = 51 + Double(69 * data.currLine)
                    }
                case "E":
                    if digit == 5 {
                        yp = 3 + Double(69 * data.currLine)
                    }
                    else {
                        yp = 46 + Double(69 * data.currLine)
                    }
                case "F":
                    if digit == 5 {
                        yp = -3 + Double(69 * data.currLine)
                    }
                    else {
                        yp = 40 + Double(69 * data.currLine)
                    }
                case "G":
                    if digit == 5 {
                        yp = -7.5 + Double(69 * data.currLine)
                    }
                    else {
                        yp = 34 + Double((69 * data.currLine))
                    }
                default:
                    print(1)
                }
                if noteLengthInSeconds >= wholeNoteDuration {
                    noteList.append(Notel(letter: note.letter, type: "whole", xpos: xp, ypos: yp))
                } else if noteLengthInSeconds >= halfNoteDuration {
                        if digit! >= 5 {
                            noteList.append(Notel(letter: note.letter, type: "half note flipped", xpos: xp, ypos: yp))
                            
                        }
                        else {
                            noteList.append(Notel(letter: note.letter, type: "half note", xpos: xp, ypos: yp))
                        }
                    } else if noteLengthInSeconds >= quarterNoteDuration {
                        if digit! >= 5 {
                            noteList.append(Notel(letter: note.letter, type: "quarter note flipped", xpos: xp, ypos: yp))
                        }
                        else {
                            noteList.append(Notel(letter: note.letter, type: "quarter note", xpos: xp, ypos: yp))
                        }
                    } else if noteLengthInSeconds >= eighthNoteDuration {
                        if digit! >= 5 {
                            noteList.append(Notel(letter: note.letter, type: "eighth note flipped", xpos: xp, ypos: yp))
                        }
                        else {
                            noteList.append(Notel(letter: note.letter, type: "eighth note", xpos: xp, ypos: yp))
                        }
                    } else  {
                        noteList.append(Notel(letter: note.letter, type: "sixteenth note", xpos: xp, ypos: yp))
                        
                    }
                }
                
            else {
                if noteLengthInSeconds >= wholeNoteDuration {
                    noteList.append(Notel(letter: note.letter, type: "rest whole", xpos: xp, ypos: 25 + Double(69 * data.currLine)))
                } else if noteLengthInSeconds >= halfNoteDuration {
                    noteList.append(Notel(letter: note.letter, type: "rest whole", xpos: xp, ypos: 33 + Double(69 * data.currLine)))
                } else if noteLengthInSeconds >= quarterNoteDuration {
                    noteList.append(Notel(letter: note.letter, type: "rest quarter", xpos: xp, ypos: 35 + Double(69 * data.currLine)))
                } else if noteLengthInSeconds >= eighthNoteDuration {
                    noteList.append(Notel(letter: note.letter, type: "rest eighth", xpos: xp, ypos: 35 + Double(69 * data.currLine)))
                } else  {
                    noteList.append(Notel(letter: note.letter, type: "rest sixteenth", xpos: xp, ypos: 35 + Double(69 * data.currLine)))
                }
            }
            print(note.letter, xp, yp, b)
        }
        return noteList
    }
    
    func update(_ pitch: AUValue, _ amp: AUValue) -> Note{
        // Reduces sensitivity to background noise to prevent random / fluctuating data.
        if (!data.isRecording) {
            tracker.stop()
            return Note(letter: "-", time: 0.0)
        }

        guard amp > 0.1 else {return Note(letter: "-", time: 0.0)}
        
        
        data.pitch = pitch
        data.amplitude = amp
        
        var frequency = pitch
        while frequency > Float(noteFrequencies[noteFrequencies.count - 1])
        {
            frequency /= 2.0
        }
        while frequency < Float(noteFrequencies[0])
        {
            frequency *= 2.0
        }
        
        var minDistance: Float = 10000.0
        var index = 0
        
        for possibleIndex in 0 ..< noteFrequencies.count
        {
            let distance = fabsf(Float(noteFrequencies[possibleIndex]) - frequency)
            if distance < minDistance {
                index = possibleIndex
                minDistance = distance
            }
        }
        let octave = Int(log2f(pitch / frequency))
        let curTime = Date().timeIntervalSince1970 * 1000
        let time = curTime - self.data.recordingStartDate
        self.data.recordingStartDate = curTime
        let note = Note(letter: "\(noteNamesWithFlats[index])\(octave)", time: time)
        data.oldNote.letter = note.letter
        data.notes.append(note)
        return note

    }
}
    


struct TransposerView: View {
    let bpmRange = 80...120
    @State public var selectedBPM = 88
    @StateObject var conductor = TransposerConductor()
    @State private var resetCount = 0
    var body: some View {
        VStack {
            HStack {
                Text("CLEAR")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        resetCount += 1
                        conductor.resetData()
                        conductor.stop()
                    }
                Spacer()
                Text("BPM:").foregroundColor(.blue)
                Picker("", selection: $selectedBPM) {
                    ForEach(bpmRange, id: \.self) { bpm in
                        Text("\(bpm)")
                    }
                }
                Spacer()
                Text(conductor.data.isRecording ? "STOP RECORDING" : "RECORD")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        conductor.data.isRecording.toggle()
                        if (conductor.data.isRecording) {
                            conductor.data.recordingStartDate = (Date().timeIntervalSince1970 * 1000)
                            //conductor.stop()
                            conductor.start()
                        }
                        else {
                            resetCount = 0

                            conductor.printNotes(bpm: selectedBPM)
                            //conductor.start()
                            conductor.stop()
                        }
                    }
            }
            ZStack {
                StaveView()
                if resetCount == 0 {
                    ForEach(conductor.data.noteL, id: \.self) { note in
                        Image(note.type)
                            .position(x: note.xpos, y: note.ypos)
                        
                    }
                }
            }

        }
        .padding()
        .onDisappear {
            resetCount = 1
            conductor.stop()
        }
    }
}

struct StaveView: View {
    var body: some View {
        ZStack {
            Image("stave5")
                .resizable(resizingMode: .tile)
                .frame(maxWidth: .infinity)
            Image("treble2").position(x: 30, y: 39.5)
        }
        .frame(maxHeight: 625)
    }
}
    

