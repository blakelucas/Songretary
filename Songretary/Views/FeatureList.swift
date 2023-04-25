

import SwiftUI

struct FeatureList: View {
    var body: some View {
        NavigationView {
            List(features) { feature in
                NavigationLink {
                    if (feature.name == "Tuner") {
                        TunerView()
                    }
                    else {
                        FeatureDetail(feature: feature)
                    }
                } label: {
                    FeatureRow(feature: feature)
                }
            }
            .navigationTitle("Features")
        }
    }
}

struct FeatureList_Previews: PreviewProvider {
    static var previews: some View {
        FeatureList()
    }
}
