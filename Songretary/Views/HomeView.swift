import SwiftUI

struct HomeView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    let items = ["Tutorial", "Approach", "About", "Contact Us"]
    let filepath1 = Bundle.main.url(forResource: "TutorialText", withExtension: "md")
    let filepath2 = Bundle.main.url(forResource: "ApproachText", withExtension: "md")
    
    var body: some View {
        ScrollView {
            Image(isDarkMode ? "icon" : "iconlight").resizable().frame(width: 70, height: 70, alignment: .center)
            VStack(alignment: .leading) {
                Text("**Songretary**").font(.largeTitle)
                Text("**Tutorial**").font(.title).padding(.top, 7)
                Text(try! AttributedString(
                                      contentsOf: filepath1!,
                                      options: AttributedString.MarkdownParsingOptions(
                                            interpretedSyntax: .inlineOnlyPreservingWhitespace
                                      ))).padding(.top, 1)
                Text("**Approach**").font(.title).padding(.top, 5)
                Text(try! AttributedString(
                                      contentsOf: filepath2!,
                                      options: AttributedString.MarkdownParsingOptions(
                                            interpretedSyntax: .inlineOnlyPreservingWhitespace
                                      ))).padding(.top, 1)
                Text("**Credits**: AudioKit")
                Text("**Contact Us**").font(.title).padding(.top, 5)
                Text("**Blake Lucas**\n  Mobile: (336)202-9525\n  Email: blucas9898@gmail.com").padding(.top, 2)
                Text("**Darian Silvers**\n  Mobile: (828)260-9163\n  Email: dariansilvers@gmail.com").padding(.top, 2)
                Text("**Philip Lavey**\n  Mobile: (336)420-4772\n  Email: laveyphillip@gmail.com").padding(.top, 2)
            }
        }
    }
    
//    func destinationView(for item: String) -> some View {
//        switch item {
//        case "Tutorial":
//            return TutorialView()
//        case "Approach":
//            return ApproachView()
//        case "About":
//            return AboutView()
//        case "Contact Us":
//            return ContactView()
//        default:
//            return Text("Unknown View")
//        }
//    }
    func destinationView(for item: String) -> some View {
            switch item {
            case "Tutorial":
                return Text("Tutorial View")
            case "Approach":
                return Text("Approach View")
            case "About":
                return Text("About View")
            case "Contact Us":
                return Text("Contact Us View")
            default:
                return Text("Unknown View")
            }
        }
}

struct TutorialView: View {
    var body: some View {
        Text("Tutorial Page")
    }
}

struct ApproachView: View {
    var body: some View {
        Text("Here is our approach")
    }
}

struct AboutView: View {
    var body: some View {
        Text("About our app")
    }
}

struct ContactView: View {
    var body: some View {
        Text("Here is our contact info")
    }
}
