import Core
import Foundation
import UIKit

public final class Assembly {
    private let coreAssembly: Core.Assembly

    public init(coreAssembly: Core.Assembly) {
        self.coreAssembly = coreAssembly
    }

    public func viewController() -> UIViewController {
        ViewController(viewModel: viewModel())
    }

    func viewModel() -> ViewModel {
        ViewModel(repository: repository())
    }

    func repository() -> RepositoryProtocol {
        Repository(client: coreAssembly.client)
    }
}
