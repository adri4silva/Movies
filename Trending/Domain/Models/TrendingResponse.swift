import Foundation

// MARK: - TrendingResponse
struct TrendingResponse: Codable {
    // MARK: - Trending
    struct Trending: Codable, Hashable, Identifiable {
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
        case en
        case it
        case ja
        case fr
        case ko
        case tr
    }

    let page: Int
    let results: [Trending]
    let totalPages, totalResults: Int
}

extension TrendingResponse.Trending {
    static let movie = Self(
        id: 632727,
        title: "Texas Chainsaw Massacre",
        overview: "In this sequel, influencers looking to breathe new life into a Texas ghost town encounter Leatherface, an infamous killer who wears a mask of human skin.",
        releaseDate: "2022-02-18",
        adult: false,
        backdropPath: "/aTSA5zMWlVFTYBIZxTCMbLkfOtb.jpg",
        voteCount: 341,
        genreIds: [27],
        voteAverage: 5.2,
        originalLanguage: .en,
        originalTitle: "Texas Chainsaw Massacre",
        posterPath: "/meRIRfADEGVo65xgPO6eZvJ0CRG.jpg",
        video: false,
        popularity: 619.57,
        mediaType: .movie,
        originalName: nil,
        originCountry: nil,
        name: nil,
        firstAirDate: nil
    )
}

extension TrendingResponse.Trending {
    var titleName: String {
        title ?? originalTitle ?? name ?? originalName ?? ""
    }

    var posterComposed: String {
        "https://image.tmdb.org/t/p/original\(posterPath)"
    }

    var backdropComposed: String {
        "https://image.tmdb.org/t/p/original\(backdropPath)"
    }
}
