import SwiftUI
import CoreData
import AVFoundation

struct ContentView: View {
    @State private var selectedTab = 3
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        //FeatureList()
        TabView(selection: $selectedTab) {
            TunerView()
                .onTapGesture {
                    selectedTab = 1
                }
                .tabItem {
                    Label("Tuner", systemImage: "ear")
                }
                .tag(1)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            MetronomeView()
                .onTapGesture {
                    selectedTab = 2
                }
                .tabItem {
                    Label("Metronome", systemImage: "metronome")
                }
                .tag(2)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            HomeView()
                .onTapGesture {
                    selectedTab = 3
                }
                .tabItem {
                    Label("Home", systemImage: "music.note.house")
                }
                .tag(3)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            TransposerView()
                .onTapGesture {
                    selectedTab = 4
                }
                .tabItem {
                    Label("Transcribe", systemImage: "pencil")
                }
                .tag(4)
                .preferredColorScheme(.light)
            SettingsView()
                .onTapGesture {
                    selectedTab = 5
                }
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(5)
        }
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
