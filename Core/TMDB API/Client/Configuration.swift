import Foundation

struct TMDBClientConfiguration {
    static let standard = TMDBClientConfiguration(
        apiKey: "f255983bec27fed8a5e4fbd9b0e7092c",
        baseUrl: URL(string: "https://api.themoviedb.org/3")!
    )

    let apiKey: String
    let baseUrl: URL

    var parameters: [String: String] {
        ["api_key": apiKey]
    }
}
