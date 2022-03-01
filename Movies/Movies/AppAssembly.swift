import Core
import MovieDetail
import Trending

final class AppAssembly {
    private let coreAssembly = Core.Assembly()
    private lazy var detailAssembly = MovieDetail.Assembly(coreAssembly: coreAssembly)
    private(set) lazy var trendingAssembly = Trending.Assembly(coreAssembly: coreAssembly, detailAssembly: detailAssembly)
}
