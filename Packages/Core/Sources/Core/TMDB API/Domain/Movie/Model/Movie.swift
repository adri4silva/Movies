import Foundation

public struct Movie: Codable, Hashable, Identifiable {
    public let id: Int
    let title: String?
    public let overview: String
    let releaseDate: String?
    let adult: Bool?
    let backdropPath: String
    let voteCount: Int
    let genreIds: [Int]
    public let voteAverage: Double
    let originalTitle: String?
    let posterPath: String
    let video: Bool?
    let popularity: Double
    let originalName: String?
    let originCountry: [String]?
    let name, firstAirDate: String?
}

public extension Movie {
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
        originalTitle: "Texas Chainsaw Massacre",
        posterPath: "/meRIRfADEGVo65xgPO6eZvJ0CRG.jpg",
        video: false,
        popularity: 619.57,
        originalName: nil,
        originCountry: nil,
        name: nil,
        firstAirDate: nil
    )
}

public extension Movie {
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
