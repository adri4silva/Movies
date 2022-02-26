import SwiftUI
import NukeUI
import Core

public struct View: SwiftUI.View {
    private let detailFactory: DetailFactoryProtocol
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel, detailFactory: DetailFactoryProtocol) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.detailFactory = detailFactory
    }

    public var body: some SwiftUI.View {
        ZStack {
            ScrollView {
                Text("Trending")
                    .foregroundStyle(.primary)
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)

                LazyVStack(spacing: 16) {
                    ForEach(viewModel.trendingMovies, id: \.id) { movie in
                        Cell(movie: movie)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectedMovie = movie
                                }
                            }
                    }
                }
            }
        }
        .fullScreenCover(item: $viewModel.selectedMovie) { movie in
            NavigationView {
                if let _ = movie {
                    detailFactory.detail(using: $viewModel.selectedMovie, isPushed: false)
                        .navigationTitle("")
                        .navigationBarHidden(true)
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct Trending_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        View(
            viewModel: .init(
                repository: MockRepository()
            ),
            detailFactory: DetailFactory(
                movieRepository: MockMovieRepository()
            )
        )
    }
}
