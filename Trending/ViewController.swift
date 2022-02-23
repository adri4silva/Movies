import UIKit
import RxSwift

final class ViewController: UIViewController {
    private enum Section {
        case main
    }
    // MARK: Content View
    private let contentView: TrendingView
    // MARK: ViewModel
    private let viewModel: ViewModel
    // MARK: Properties
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<Section, TrendingResponse.Trending>!
    // MARK: Layout
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.list(
            using: UICollectionLayoutListConfiguration(
                appearance: .insetGrouped
            )
        )
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    // MARK: Initializer
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.contentView = TrendingView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellRegistration = UICollectionView.CellRegistration<CollectionViewCell, TrendingResponse.Trending> { cell, index, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
        }

        self.dataSource = UICollectionViewDiffableDataSource<Section, TrendingResponse.Trending>(collectionView: collectionView) { collection, index, identifier in
            return collection.dequeueConfiguredReusableCell(using: cellRegistration, for: index, item: identifier)
        }

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        bindViewModel()
    }
}

private extension ViewController {
    func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
            .asDriver(onErrorJustReturn: ())

        let input = ViewModel.Input(trigger: viewWillAppear)

        let outputs = viewModel.transform(input: input)

        outputs.movies
            .map { trending in
                var snapshot = NSDiffableDataSourceSnapshot<Section, TrendingResponse.Trending>()
                snapshot.appendSections([.main])
                snapshot.appendItems(trending)
                return snapshot
            }
            .drive(
                onNext: { [dataSource] snapshot in
                    dataSource?.apply(snapshot)
                }
            )
            .disposed(by: disposeBag)
    }
}

final class TrendingView: UIView {

}

final class CollectionViewCell: UICollectionViewListCell {
    static let identifier = "TrendingCell"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
