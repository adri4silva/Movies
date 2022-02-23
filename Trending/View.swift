import SwiftUI
import Kingfisher

public struct View: SwiftUI.View {
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    public var body: some SwiftUI.View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.trendingMovies, id: \.id) { movie in
                    Cell(movie: movie)
                        .frame(height: 300)
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

}

struct Cell: SwiftUI.View {
    let movie: TrendingResponse.Trending

    var body: some SwiftUI.View {
        GeometryReader { proxy in
            ZStack {
                KFImage(URL(string: "https://image.tmdb.org/t/p/original\(movie.posterPath)")!)
                    .resizable()
                    .setProcessor(
                        ResizingImageProcessor(
                            referenceSize: CGSize(
                                width: proxy.size.width,
                                height: proxy.size.height
                            ),
                            mode: .aspectFill
                        )
                    )
                    .aspectRatio(contentMode: .fill)

                VStack {
                    Spacer()
                    Text(movie.title ?? movie.originalTitle ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(12)
    }
}
