import Foundation
import SwiftUI

class Viernes: ObservableObject {
    @Published var waterAmount: Int = 0
    @Published var animatedAmount: Double = 0

    init(waterAmount: Int = 0) {
        self.waterAmount = waterAmount
        self.animatedAmount = Double(waterAmount)
    }
    
    func updateWaterAmount(newAmount: Int) {
        waterAmount = newAmount
        animatedAmount = Double(waterAmount)
    }
    
    func addWater(amount: Int) {
        waterAmount += amount
        updateWaterAmount(newAmount: waterAmount)
    }
    
    func removeWater(amount: Int) {
        if waterAmount >= amount {
            waterAmount -= amount
            updateWaterAmount(newAmount: waterAmount)
        }
    }
    
    func parsingString(string: String) -> Int {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let number = numberFormatter.number(from: string) {
            return number.intValue
        } else {
            return 0
        }
    }
}

struct ViernesVista: View {
    @StateObject private var viernes = Viernes()

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
                    
                    Text(String(format: "%.0f oz", viernes.animatedAmount))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            viernes.removeWater(amount: 8)
                        }) {
                            Text("-8 oz")
                                .font(.headline)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            viernes.addWater(amount: 8)
                        }) {
                            Text("+8 oz")
                                .font(.headline)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }
}