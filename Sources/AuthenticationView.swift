import SwiftUI

struct AuthenticationView: View {
    weak var appDelegate: AppDelegate?
    
    @State private var siteURL: String = ""
    @State private var username: String = ""
    @State private var applicationPassword: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showInstructions = false
    
    // UI Constants
    private enum Layout {
        static let width: CGFloat = 500
        static let height: CGFloat = 400
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("WordUp Setup")
                .font(.title)
                .padding(.top)
            
            Text("Connect to your WordPress site")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading) {
                    Text("Site URL")
                        .font(.caption)
                    TextField("https://yoursite.com", text: $siteURL)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.caption)
                    TextField("Username", text: $username)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Application Password")
                            .font(.caption)
                        Button(action: {
                            showInstructions.toggle()
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                        .buttonStyle(.plain)
                    }
                    SecureField("xxxx xxxx xxxx xxxx xxxx xxxx", text: $applicationPassword)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .padding(.horizontal)
            
            if showInstructions {
                VStack(alignment: .leading, spacing: 5) {
                    Text("How to generate an Application Password:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("1. Log in to your WordPress site")
                        .font(.caption2)
                    Text("2. Go to Users → Profile")
                        .font(.caption2)
                    Text("3. Scroll to 'Application Passwords' section")
                        .font(.caption2)
                    Text("4. Enter a name and click 'Add New Application Password'")
                        .font(.caption2)
                    Text("5. Copy the generated password here")
                        .font(.caption2)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
            }
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            HStack {
                Button("Cancel") {
                    appDelegate?.closeAuthWindow()
                }
                
                Button("Connect") {
                    authenticate()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(siteURL.isEmpty || username.isEmpty || applicationPassword.isEmpty || isLoading)
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            
            Spacer()
        }
        .frame(width: Layout.width, height: Layout.height)
    }
    
    func authenticate() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await WordPressAuth.shared.authenticate(
                    siteURL: siteURL,
                    username: username,
                    applicationPassword: applicationPassword
                )
                
                await MainActor.run {
                    isLoading = false
                    appDelegate?.closeAuthWindow()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
