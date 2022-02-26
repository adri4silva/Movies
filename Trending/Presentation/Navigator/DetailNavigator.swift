import SwiftUI

protocol DetailNavigatorProtocol {
    func navigate(to movie: Binding<TrendingResponse.Trending?>) -> Detail
}

struct DetailNavigator: DetailNavigatorProtocol {
    func navigate(to movie: Binding<TrendingResponse.Trending?>) -> Detail {
        Detail(movie: movie)
    }
}
