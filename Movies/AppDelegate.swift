import SwiftUI
import Core
import Trending

@main
struct AppView: App {
    private let coreAssembly = Core.Assembly()

    var body: some Scene {
        WindowGroup {
            Trending.Assembly(coreAssembly: coreAssembly).view()
        }
    }
}
