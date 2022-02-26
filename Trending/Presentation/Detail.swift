import Core
import NukeUI
import SwiftUI

struct Detail: SwiftUI.View {
    @Binding private var movie: TrendingResponse.Trending?
    @ObservedObject private var viewModel: DetailViewModel

    init(
        movie: Binding<TrendingResponse.Trending?>,
        viewModel: DetailViewModel
    ) {
        self._movie = movie
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some SwiftUI.View {
        GeometryReader { proxy in
            if let movie = movie {
                ZStack {
                    backdropImage(movie: movie, proxy: proxy)

                    ScrollView {
                        VStack {
                            posterImage(movie: movie, proxy: proxy)
                            description(movie: movie)
                            cast(movie: movie)
                            Rectangle()
                                .fill(.clear)
                                .frame(height: 100)
                        }
                    }
                    .ignoresSafeArea()

                    closeButton
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

private extension Detail {
    func backdropImage(movie: TrendingResponse.Trending, proxy: GeometryProxy) -> some SwiftUI.View {
        LazyImage(source: movie.backdropComposed, resizingMode: .aspectFill)
            .ignoresSafeArea()
            .frame(width: proxy.size.width, height: proxy.size.height)
            .overlay(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            )
    }

    func posterImage(movie: TrendingResponse.Trending, proxy: GeometryProxy) -> some SwiftUI.View {
        GeometryReader { reader in
            let minY = reader.frame(in: .global).minY

            LazyImage(source: movie.posterComposed, resizingMode: .aspectFill)
                .offset(y: -minY)
                .scaleEffect(minY > 0 ? minY / 1000 + 1 : 1)
                .blur(radius: minY > 0 ? minY / 50 : 0)
        }
        .frame(width: proxy.size.width, height: proxy.size.height / 1.5)
    }

    func description(movie: TrendingResponse.Trending) -> some SwiftUI.View {
        VStack(spacing: 8) {
            Text(movie.titleName)
                .font(.title).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)

            Text("Average Rating - \(String(format: "%.1f", movie.voteAverage))".uppercased())
                .font(.footnote).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white.opacity(0.7))

            Text(movie.overview)
                .font(.footnote)
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

    var closeButton: some SwiftUI.View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        self.movie = nil
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
                
                Spacer()
            }

            Spacer()
        }
        .padding(.horizontal, 16)
    }

    func cast(movie: TrendingResponse.Trending) -> some SwiftUI.View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.cast, id: \.id) { castActor in
                    VStack {
                        LazyImage(source: castActor.profileComposed, resizingMode: .aspectFill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(25)

                        Text(castActor.name)
                    }
                }
            }
        }
    }
}

struct Detail_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        Detail(
            movie: .constant(.movie),
            viewModel: .init(
                movie: .movie,
                repository: MockMovieRepository()
            )
        )
    }
}
