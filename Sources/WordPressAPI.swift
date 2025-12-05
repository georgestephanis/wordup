import Foundation
import UniformTypeIdentifiers

class WordPressAPI {
    static let shared = WordPressAPI()
    
    private init() {}
    
    func uploadFile(_ fileURL: URL) async throws -> String {
        guard let credentials = WordPressAuth.shared.getCredentials() else {
            throw APIError.notAuthenticated
        }
        
        // Read file data
        let fileData: Data
        do {
            fileData = try Data(contentsOf: fileURL)
        } catch {
            throw APIError.fileReadError
        }
        
        // Get file extension and mime type
        let filename = fileURL.lastPathComponent
        let mimeType = getMimeType(for: fileURL)
        
        // Build API endpoint
        guard let siteURL = URL(string: credentials.siteURL) else {
            throw APIError.invalidURL
        }
        
        let uploadURL = siteURL.appendingPathComponent("wp-json").appendingPathComponent("wp").appendingPathComponent("v2").appendingPathComponent("media")
        
        // Create request
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        
        // Add authentication
        let authString = "\(credentials.username):\(credentials.password)"
        guard let authData = authString.data(using: .utf8) else {
            throw APIError.authenticationError
        }
        let base64Auth = authData.base64EncodedString()
        request.setValue("Basic \(base64Auth)", forHTTPHeaderField: "Authorization")
        
        // Set content type and disposition
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        request.setValue("attachment; filename=\"\(filename)\"", forHTTPHeaderField: "Content-Disposition")
        
        // Set body
        request.httpBody = fileData
        
        // Send request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 201 else {
            if httpResponse.statusCode == 401 {
                throw APIError.authenticationError
            } else {
                throw APIError.uploadFailed(statusCode: httpResponse.statusCode)
            }
        }
        
        // Parse response
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let link = json["link"] as? String else {
            throw APIError.invalidResponse
        }
        
        return link
    }
    
    private func getMimeType(for url: URL) -> String {
        if let type = UTType(filenameExtension: url.pathExtension) {
            return type.preferredMIMEType ?? "application/octet-stream"
        }
        return "application/octet-stream"
    }
}

enum APIError: LocalizedError {
    case notAuthenticated
    case fileReadError
    case invalidURL
    case authenticationError
    case uploadFailed(statusCode: Int)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Not authenticated. Please sign in first."
        case .fileReadError:
            return "Failed to read file"
        case .invalidURL:
            return "Invalid site URL"
        case .authenticationError:
            return "Authentication failed. Please check your credentials."
        case .uploadFailed(let statusCode):
            return "Upload failed with status code: \(statusCode)"
        case .invalidResponse:
            return "Invalid response from server"
        }
    }
}
