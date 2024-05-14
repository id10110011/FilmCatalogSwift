import SwiftUI

struct ButtonView: View {
    var action: () async -> Void
    var text: String
    var disabled: Bool = false
    var color: Color = Color.green
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Text(text)
                .padding()
                .foregroundColor(.white)
                .font(.headline)
                .frame(width: 0.8 * UIScreen.main.bounds.width)
                .background(disabled ? .gray : color)
                .cornerRadius(8)
        }
        .disabled(disabled)
        .opacity(disabled ? 0.5 : 1.0)
    }
}
