import SwiftUI

struct DetailView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail View")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Text("Here you can add more details about the water tracking app.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
    }
}