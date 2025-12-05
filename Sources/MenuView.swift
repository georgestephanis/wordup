import SwiftUI

struct MenuView: View {
    weak var appDelegate: AppDelegate?
    @State private var isAuthenticated = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("WordUp")
                .font(.headline)
                .padding(.top)
            
            Divider()
            
            if isAuthenticated {
                Text("✓ Authenticated")
                    .foregroundColor(.green)
                
                if let siteURL = WordPressAuth.shared.getSiteURL() {
                    Text(siteURL)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("⚠ Not Authenticated")
                    .foregroundColor(.orange)
            }
            
            Divider()
            
            Text("Drag files here to upload")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            Divider()
            
            Button(action: {
                if isAuthenticated {
                    WordPressAuth.shared.logout()
                    isAuthenticated = false
                    appDelegate?.showAuthWindow()
                } else {
                    appDelegate?.showAuthWindow()
                }
            }) {
                Text(isAuthenticated ? "Sign Out" : "Sign In")
            }
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Text("Quit")
            }
            .padding(.bottom)
        }
        .frame(width: 300, height: 200)
        .onAppear {
            isAuthenticated = WordPressAuth.shared.isAuthenticated()
        }
    }
}
