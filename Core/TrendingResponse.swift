import Foundation

// MARK: - TrendingResponse
public struct TrendingResponse: Codable {
    // MARK: - Trending
    public struct Trending: Codable {
        let id: Int
        let title: String?
        let overview: String
        let releaseDate: String?
        let adult: Bool?
        let backdropPath: String
        let voteCount: Int
        let genreIds: [Int]
        let voteAverage: Double
        let originalLanguage: OriginalLanguage
        let originalTitle: String?
        let posterPath: String
        let video: Bool?
        let popularity: Double
        let mediaType: MediaType
        let originalName: String?
        let originCountry: [String]?
        let name, firstAirDate: String?
    }

    public enum MediaType: String, Codable {
        case movie = "movie"
        case tv = "tv"
    }

    public enum OriginalLanguage: String, Codable {
        case en = "en"
        case it = "it"
        case ja = "ja"
    }

    public let page: Int
    public let results: [Trending]
    public let totalPages, totalResults: Int
}
