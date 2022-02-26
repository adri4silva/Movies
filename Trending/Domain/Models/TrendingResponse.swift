import Core
import Foundation

// MARK: - TrendingResponse
struct TrendingResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int
}
