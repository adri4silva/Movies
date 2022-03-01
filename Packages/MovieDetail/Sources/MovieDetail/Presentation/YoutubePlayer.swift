import SwiftUI
import Core
import YouTubeiOSPlayerHelper

struct YoutubePlayer: UIViewRepresentable {
    let videoKey: String
    private var state: Binding<State>?

    init(videoKey: String, state: Binding<State>? = nil) {
        self.videoKey = videoKey
        self.state = state
    }

    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()

        playerView.isOpaque = false
        playerView.backgroundColor = .clear
        playerView.delegate = context.coordinator
        playerView.load(withVideoId: videoKey)

        return playerView
    }

    func updateUIView(_ uiView: YTPlayerView, context: Context) {}
}

extension YoutubePlayer {
    final class Coordinator: NSObject, YTPlayerViewDelegate {
        let parent: YoutubePlayer

        init(_ parent: YoutubePlayer) {
            self.parent = parent
        }

        func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
            self.parent.state?.wrappedValue = state.toYoutubePlayerState()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension YoutubePlayer {
    enum State {
        case playing
        case paused
        case buffering
        case unknown
    }
}

extension YTPlayerState {
    func toYoutubePlayerState() -> YoutubePlayer.State {
        switch self {
        case .paused, .unstarted, .ended, .cued: return .paused
        case .playing: return .playing
        case .unknown: return .unknown
        case .buffering: return .buffering
        @unknown default:
            return .unknown
        }
    }
}
