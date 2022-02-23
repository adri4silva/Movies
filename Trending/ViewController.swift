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
        func createLayout() -> UICollectionViewLayout {
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                subitem: item,
                count: 1
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 12
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
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
            cell.backgroundImage.kf.setImage(
                with: URL(string: "https://image.tmdb.org/t/p/original\(item.posterPath)"),
                options: [
                    .loadDiskFileSynchronously,
                    .cacheOriginalImage,
                    .transition(.fade(0.25)),
                ]
            )
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

import Kingfisher

final class CollectionViewCell: UICollectionViewCell {
    static let identifier = "TrendingCell"

    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])


    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
