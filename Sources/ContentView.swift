import SwiftUI

struct DetailViewWrapper: View {
    var body: some View {
        UIViewControllerWrapper(viewController: DetailView())
    }
}

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

                    NavigationLink(destination: DetailViewWrapper()) {
                        Text("View Details")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    .navigationBarTitle("Water Tracker", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        // Add any action for the button here
                        //viernesvista()
                        imageCarouselView()
                    }) {
                        Image(systemName: "info.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                    })
                }
            }
        }
    }
}

struct foraeach_carrusel : View {
    NavigationView {
        VStack{
            Text ("Water tracker")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            ScrollView(.horizonral,showindicators: false){
                HStack(spacing :20) {
                    ForEac(h: 0..<10) { index in
                        VStack{
                            Text("Item \(index)")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .frame(width: 200, height: 200)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
}

struct UIViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

import SwiftUI

func obtainImages() -> [URL] {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
        return []
    }
    
    var imageUrls: [URL] = []
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    for item in jsonArray.prefix(10) { // Limit to 10 images
                        if let imageUrlString = item["url"] as? String, let imageUrl = URL(string: imageUrlString) {
                            imageUrls.append(imageUrl)
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        semaphore.signal()
    }.resume()
    
    semaphore.wait()
    return imageUrls
}

struct ImageCarouselView: View {
    @State private var imageUrls: [URL] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Image Carousel")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(imageUrls, id: \.self) { url in
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipped()
                                    .cornerRadius(20)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 200, height: 200)
                            }
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                imageUrls = obtainImages()
            }
        }
    }
}