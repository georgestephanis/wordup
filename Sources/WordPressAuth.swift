import Foundation
import Security

class WordPressAuth {
    static let shared = WordPressAuth()
    
    private let keychainService = "com.wordup.wordpress"
    private let siteURLKey = "siteURL"
    private let usernameKey = "username"
    private let passwordKey = "applicationPassword"
    
    private init() {}
    
    func authenticate(siteURL: String, username: String, applicationPassword: String) async throws {
        // Validate site URL
        var cleanedURL = siteURL.trimmingCharacters(in: .whitespaces)
        if !cleanedURL.hasPrefix("http://") && !cleanedURL.hasPrefix("https://") {
            cleanedURL = "https://" + cleanedURL
        }
        
        guard let url = URL(string: cleanedURL) else {
            throw AuthError.invalidURL
        }
        
        // Test the connection
        try await testConnection(url: url, username: username, password: applicationPassword)
        
        // Save credentials to keychain
        try saveToKeychain(siteURL: cleanedURL, username: username, password: applicationPassword)
    }
    
    func isAuthenticated() -> Bool {
        return getCredentials() != nil
    }
    
    func getCredentials() -> (siteURL: String, username: String, password: String)? {
        guard let siteURL = UserDefaults.standard.string(forKey: siteURLKey),
              let username = UserDefaults.standard.string(forKey: usernameKey),
              let password = getPasswordFromKeychain() else {
            return nil
        }
        
        return (siteURL, username, password)
    }
    
    func getSiteURL() -> String? {
        return UserDefaults.standard.string(forKey: siteURLKey)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: siteURLKey)
        UserDefaults.standard.removeObject(forKey: usernameKey)
        deletePasswordFromKeychain()
    }
    
    private func testConnection(url: URL, username: String, password: String) async throws {
        // Test connection to WordPress REST API
        let testURL = url.appendingPathComponent("/wp-json/wp/v2/users/me")
        
        var request = URLRequest(url: testURL)
        request.httpMethod = "GET"
        
        // Add basic authentication header
        let credentials = "\(username):\(password)"
        guard let credentialsData = credentials.data(using: .utf8) else {
            throw AuthError.invalidCredentials
        }
        let base64Credentials = credentialsData.base64EncodedString()
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.connectionFailed
        }
        
        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw AuthError.invalidCredentials
            } else {
                throw AuthError.connectionFailed
            }
        }
    }
    
    private func saveToKeychain(siteURL: String, username: String, password: String) throws {
        // Save site URL and username to UserDefaults
        UserDefaults.standard.set(siteURL, forKey: siteURLKey)
        UserDefaults.standard.set(username, forKey: usernameKey)
        
        // Save password to Keychain
        guard let passwordData = password.data(using: .utf8) else {
            throw AuthError.keychainError
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: passwordKey,
            kSecValueData as String: passwordData
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw AuthError.keychainError
        }
    }
    
    private func getPasswordFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: passwordKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let passwordData = item as? Data,
              let password = String(data: passwordData, encoding: .utf8) else {
            return nil
        }
        
        return password
    }
    
    private func deletePasswordFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: passwordKey
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

enum AuthError: LocalizedError {
    case invalidURL
    case invalidCredentials
    case connectionFailed
    case keychainError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid site URL"
        case .invalidCredentials:
            return "Invalid username or application password"
        case .connectionFailed:
            return "Failed to connect to WordPress site"
        case .keychainError:
            return "Failed to save credentials securely"
        }
    }
}
