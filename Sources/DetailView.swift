import SwiftUI
import AuthenticationServices

class DetailView: UIViewController, ASWebAuthenticationPresentationContextProviding {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let label = UILabel()
        label.text = "Detail View"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        let button = UIButton(type: .system)
        button.setTitle("Authenticate with Bungie", for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(authenticateWithBungie), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),

            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func authenticateWithBungie() {
        print("Starting authentication with Bungie...")
        let callbackScheme = "com.example.ui" // Ensure this matches the scheme without special characters
        guard let authURL = URL(string: "https://www.bungie.net/en/OAuth/Authorize?client_id=37130&response_type=code&redirect_uri=com.example.ui") else {
            print("Invalid authentication URL")
            return
        }

        print("Authentication URL is valid: \(authURL)")

        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callbackScheme) { callbackURL, error in
            if let error = error {
                print("Authentication failed: \(error.localizedDescription)")
                return
            }

            if let callbackURL = callbackURL {
                print("Callback URL received: \(callbackURL)")
                if let queryItems = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems {
                    if let code = queryItems.first(where: { $0.name == "code" })?.value {
                        print("Authentication succeeded with code: \(code)")
                        // Exchange the code for an access token here
                    } else {
                        print("No code found in callback URL")
                    }
                } else {
                    print("Failed to parse query items from callback URL")
                }
            } else {
                print("No callback URL received")
            }
        }

        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true // Ensure a clean session
        print("Starting ASWebAuthenticationSession...")
        session.start()
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
}