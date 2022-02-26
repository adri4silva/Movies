import SwiftUI
import Kingfisher
import NukeUI

public struct View: SwiftUI.View {
    private let detailNavigator: DetailNavigatorProtocol
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel, detailNavigator: DetailNavigatorProtocol) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.detailNavigator = detailNavigator
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
            if let _ = movie {
                detailNavigator.navigate(to: $viewModel.selectedMovie)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct Trending_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        View(viewModel: .init(repository: MockRepository()), detailNavigator: DetailNavigator())
    }
}
