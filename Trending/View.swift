import SwiftUI
import Kingfisher

public struct View: SwiftUI.View {
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    public var body: some SwiftUI.View {
        ScrollView {
            VStack {
                HStack(spacing: 16) {
                    Text("Trending")
                        .foregroundStyle(.primary)
                        .font(.system(size: 34, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                    Button {

                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 17, weight: .bold))
                            .frame(width: 36, height: 36)
                            .foregroundColor(.secondary)
                            .background(.ultraThinMaterial)
                            .mask(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.horizontal, 16)
                .padding(.vertical, 24)

                LazyVStack(spacing: 16) {
                    ForEach(viewModel.trendingMovies, id: \.id) { movie in
                        Cell(movie: movie)
                    }
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
        VStack {
            Spacer()
            VStack(spacing: 8) {
                Text(movie.title ?? movie.originalTitle ?? "")
                    .font(.title).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)

                Text("Average Rating - \(String(format: "%.1f", movie.voteAverage))".uppercased())
                    .font(.footnote).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white.opacity(0.7))

                Text(movie.overview)
                    .font(.footnote)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(16)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .cornerRadius(16)
                    .blur(radius: 16)
            )
        }
        .background(
            KFImage(URL(string: "https://image.tmdb.org/t/p/original\(movie.posterPath)")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: 100)
        )
        .mask(
            RoundedRectangle(cornerRadius: 16)
        )
        .frame(height: 300)
        .padding(.horizontal, 16)
    }
}
