import Foundation

// MARK: - TrendingResponse
struct TrendingResponse: Codable {
    // MARK: - Trending
    struct Trending: Codable, Hashable {
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

    enum MediaType: String, Codable, Hashable {
        case movie = "movie"
        case tv = "tv"
    }

    enum OriginalLanguage: String, Codable, Hashable {
        case en = "en"
        case it = "it"
        case ja = "ja"
    }

    let page: Int
    let results: [Trending]
    let totalPages, totalResults: Int
}
