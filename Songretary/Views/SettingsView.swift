import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("isHaptic") private var isHaptic = true
    //@AppStorage("textSize") public var textSize: CGFloat = 16
    
    var body: some View {
        NavigationView {
            List {
                VStack{
                    Toggle("Dark Mode", isOn: $isDarkMode)
                    Toggle("Metronome Haptic Feedback", isOn: $isHaptic)
                }
            }.navigationTitle("Settings")
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
