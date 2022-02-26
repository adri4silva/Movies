import Foundation

public struct SimilarResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int
}
