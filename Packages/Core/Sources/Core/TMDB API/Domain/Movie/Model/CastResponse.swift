import Foundation

// MARK: - CastResponse
public struct CastResponse: Codable {
    // MARK: - Cast
    public struct Cast: Codable {
        let adult: Bool
        public let gender, id: Int
        let knownForDepartment: Department
        public let name, originalName: String
        let popularity: Double
        let profilePath: String?
        let castId: Int?
        let character: String?
        let creditId: String
        let order: Int?
        let department: Department?
        let job: String?
    }

    public enum Department: String, Codable {
        case acting = "Acting"
        case art = "Art"
        case camera = "Camera"
        case costumeMakeUp = "Costume & Make-Up"
        case crew = "Crew"
        case directing = "Directing"
        case editing = "Editing"
        case lighting = "Lighting"
        case production = "Production"
        case sound = "Sound"
        case visualEffects = "Visual Effects"
        case writing = "Writing"
    }

    let id: Int
    let cast, crew: [Cast]
}

public extension CastResponse.Cast {
    var profileComposed: String {
        "https://image.tmdb.org/t/p/original\(profilePath ?? "")"
    }
}
