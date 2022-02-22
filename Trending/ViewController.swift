import UIKit

final class ViewController: UIViewController {
    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

private extension ViewController {
    func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
            .asDriver(onErrorJustReturn: ())

        let input = ViewModel.Input(trigger: viewWillAppear)

        _ = viewModel.transform(input: input)
    }
}
