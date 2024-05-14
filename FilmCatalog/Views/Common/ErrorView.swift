import SwiftUI

struct ErrorView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.red)
            .padding(.top, 12)
            .frame(width: 0.9 * UIScreen.main.bounds.width)
    }
}
