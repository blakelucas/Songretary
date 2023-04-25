

import SwiftUI

struct FeatureRow: View {
    var feature: Feature
    
    var body: some View {
        HStack {
            feature.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(feature.name)
            
            Spacer()
        }
    }
}

struct featureRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeatureRow(feature: features[0])
            FeatureRow(feature: features[1])
            FeatureRow(feature: features[2])
            FeatureRow(feature: features[3])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
