import Foundation

// Data models
struct ChatMessage {
    let from: String
    let content: String
    let isPrivate: Bool
    let to: String?
    
    init(from: String, content: String, isPrivate: Bool, to: String? = nil) {
        self.from = from
        self.content = content
        self.isPrivate = isPrivate
        self.to = to
    }
}