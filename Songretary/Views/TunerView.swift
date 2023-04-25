import SwiftUI

struct TunerView: View {
    @StateObject var tnr = Tuner()
    
    // Red
    var colorR = 0.96 //245
    var colorG = 0.35 //90
    var colorB = 0.27 //60
    
    // Green
    var colorR2 = 0.54 //138
    var colorG2 = 0.96 //245
    var colorB2 = 0.27 //66
    
//    @State var distR = 0.0 //0.96 -
//    @State var distG = 0.0 //0.35 +
//    @State var distB = 0.27
    
    var body: some View {
        
        ZStack {
            //Background gradient
            Color(red: colorR, green: colorG, blue: colorB).ignoresSafeArea()
            VStack {
                // Note
                Text("\(tnr.data.noteNameWithSharps)")
                    .font(.system(size: 150))
                // Frequency
                Text("\(tnr.data.pitch, specifier: "%0.1f") Hz")
                
                ZStack {
                    // NOTE: Update tick jpg from placeholder
                    Image("ticks").resizable().aspectRatio(contentMode: .fit)
                        .padding(.top, 70)
                    
                    GeometryReader { geometry in
                        VStack(alignment: .center) {
                            Rectangle()
                                .frame(width: 6, height: 250)
                                .cornerRadius(4)
                            // NOTE: Add current frequency here
//                            Text("curr freq")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
                        }
                        .frame(width: geometry.size.width)
                        .offset(x: (geometry.size.width / 2) * CGFloat(tnr.data.cents / 50), y:154)
                        .animation(.easeInOut, value: tnr.data.cents)
                    }
                }
            }
        }
        .onAppear {
            tnr.start()
        }
        .onDisappear {
            tnr.stop()
        }
    }
}
