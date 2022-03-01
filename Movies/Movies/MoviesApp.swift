import SwiftUI

@main
struct MoviesApp: App {
    private let assembly = AppAssembly()
    
    var body: some Scene {
        WindowGroup {
            assembly.trendingAssembly.view()
        }
    }
}
