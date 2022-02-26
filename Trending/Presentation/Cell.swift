import Core
import NukeUI
import SwiftUI

struct Cell: SwiftUI.View {
    private let movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }

    var body: some SwiftUI.View {
        VStack {
            Spacer()
            content
        }
        .background(
            LazyImage(source: movie.posterComposed, resizingMode: .aspectFill)
        )
        .mask(
            RoundedRectangle(cornerRadius: 16)
        )
        .frame(height: 300)
        .padding(.horizontal, 16)
    }
}

private extension Cell {
    var content: some SwiftUI.View {
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
}

struct Cell_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        Cell(movie: .movie)
    }
}
