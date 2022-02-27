import Core
import NukeUI
import SwiftUI

struct Detail: SwiftUI.View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isNavigationActive: Bool = false
    @Binding private var movie: Movie?
    @ObservedObject private var viewModel: DetailViewModel
    private let detailFactory: DetailFactoryProtocol

    init(
        movie: Binding<Movie?>,
        viewModel: DetailViewModel,
        detailFactory: DetailFactoryProtocol
    ) {
        self._movie = movie
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.detailFactory = detailFactory
    }

    var body: some SwiftUI.View {
        GeometryReader { proxy in
            if let movie = movie {
                ZStack {
                    backdropImage(movie: movie, proxy: proxy)

                    ScrollView {
                        VStack {
                            posterImage(movie: movie, geometry: proxy)
                            description(movie: movie, geometry: proxy)

                            Rectangle()
                                .fill(.clear)
                                .frame(height: 50)
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
    func backdropImage(movie: Movie, proxy: GeometryProxy) -> some SwiftUI.View {
        LazyImage(source: movie.backdropComposed, resizingMode: .aspectFill)
            .ignoresSafeArea()
            .frame(width: proxy.size.width, height: proxy.size.height)
            .overlay(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            )
    }

    func posterImage(movie: Movie, geometry: GeometryProxy) -> some SwiftUI.View {
        GeometryReader { reader in
            let minY = reader.frame(in: .global).minY

            LazyImage(source: movie.posterComposed, resizingMode: .aspectFill)
                .offset(y: -minY)
                .scaleEffect(minY > 0 ? minY / 1000 + 1 : 1)
                .blur(radius: minY > 0 ? minY / 50 : 0)
        }
        .frame(width: geometry.size.width, height: geometry.size.height / 1.5)
    }

    func description(movie: Movie, geometry: GeometryProxy) -> some SwiftUI.View {
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

            if !viewModel.castNames.isEmpty {
                Text("Cast: \(viewModel.castNames)...")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white.opacity(0.7))
            }

            exploreSection(geometry: geometry)
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
                        presentationMode.wrappedValue.dismiss()
                        self.movie = nil
                    }
                } label: {
                    Image(systemName: viewModel.isPushed ? "chevron.left" : "xmark")
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

    func exploreSection(geometry: GeometryProxy) -> some SwiftUI.View {
        VStack {
            let width = (geometry.size.width - 16 * 3) / 3

            HStack(spacing: 8) {
                if !viewModel.similarMovies.isEmpty {
                    Button {
                        withAnimation {
                            viewModel.selectedSection = .similar
                        }
                    } label: {
                        Text("Similar")
                            .font(.footnote).bold()
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .overlay(
                        viewModel.selectedSection == .similar ?
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 4)
                            .offset(y: 4)
                        : nil,
                        alignment: .bottom
                    )
                }

                if !viewModel.videos.isEmpty {
                    Button {
                        withAnimation {
                            viewModel.selectedSection = .videos
                        }
                    } label: {
                        Text("Trailer")
                            .font(.footnote).bold()
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .overlay(
                        viewModel.selectedSection == .videos ?
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 4)
                            .offset(y: 4)
                        : nil,
                        alignment: .bottom
                    )
                }

                Spacer()
            }

            switch viewModel.selectedSection {
            case .similar:
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: 3),
                    spacing: 16
                ) {
                    ForEach(viewModel.similarMovies) { movie in
                        NavigationLink(isActive: $isNavigationActive) {
                            detailFactory.detail(using: .constant(movie), isPushed: true)
                                .navigationTitle("")
                                .navigationBarHidden(true)
                        } label: {
                            LazyImage(source: movie.posterComposed, resizingMode: .aspectFill)
                                .frame(width: width, height: width * 16 / 9)
                                .cornerRadius(8)
                        }
                    }
                }
            case .videos:
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: 1),
                    spacing: 16
                ) {
                    ForEach(viewModel.videos, id: \.id) { video in
                        VStack(spacing: 8) {
                            YoutubePlayer(videoKey: video.key)
                                .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) * 9 / 16)
                                .cornerRadius(8)

                            Text(video.name)
                                .font(.footnote).bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
            }
        }
        .padding(.top, 16)
    }
}

struct Detail_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        Detail(
            movie: .constant(.movie),
            viewModel: .init(
                movie: .movie,
                isPushed: false,
                repository: MockMovieRepository()
            ),
            detailFactory: DetailFactory(movieRepository: MockMovieRepository())
        )
    }
}
