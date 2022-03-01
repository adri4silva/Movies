import Foundation

// MARK: - VideoResponse
public struct VideoResponse: Codable {
    // MARK: - Result
    public struct Video: Codable {
        public let name, key: String
        let site: String
        let size: Int
        let type: String
        let official: Bool
        public let publishedAt, id: String
    }

    let id: Int
    let results: [Video]
}
