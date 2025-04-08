import SwiftUI

struct ContentView: View {
    @State private var waterAmount: Int = 0
    @State private var animatedAmount: Double = 0

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Water Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text(String(format: "%.0f oz", animatedAmount))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.black)
                        .onChange(of: waterAmount) { newValue in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                animatedAmount = Double(newValue)
                            }
                        }

                    HStack(spacing: 20) {
                        Button(action: {
                            if waterAmount >= 8 {
                                waterAmount -= 8
                            }
                        }) {
                            Text("-8 oz")
                                .font(.headline)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            waterAmount += 8
                        }) {
                            Text("+8 oz")
                                .font(.headline)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }

                    NavigationLink(destination: DetailView()) {
                        Text("View Details")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}