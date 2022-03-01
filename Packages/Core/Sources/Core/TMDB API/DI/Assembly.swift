import Foundation

public final class Assembly {
    public private(set) lazy var client = TMDBClient(configuration: .standard)
    public init() {}
}
