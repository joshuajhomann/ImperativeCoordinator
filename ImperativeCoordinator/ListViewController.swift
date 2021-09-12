//
//  ViewController.swift
//  ImperativeCoordinator
//
//  Created by Josh Homann on 9/10/21.
//

import Combine
import UIKit
import SwiftUI


final class ListViewModel {

    private enum Constant {
        static let colors: [UIColor] = [ #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
        static let symbols: [String] = ["bolt","book","desktopcomputer","eyeglasses","film","heart","hexagon"]
    }
    @Published private(set) var items: [Item] = []

    struct Item: Hashable {
        var number: Int
        var imageName: String
        var color: UIColor
    }

    let onSelect: (Item) -> Void

    init<SomeCoordinator: Coordinator>(
        coordinator: SomeCoordinator,
        consumablesService: ConsumablesService
    ) where SomeCoordinator.Action == ListCoordinator.Action {
        items = Array(0..<100).map { number in
            Item(
                number: number,
                imageName: Constant.symbols[number % Constant.symbols.count],
                color: Constant.colors[number % Constant.colors.count]
            )
        }
        onSelect = { item in
            if consumablesService.ordinalNumberConsumable > 0 {
                consumablesService.consumeOrdinalNumber()
                coordinator.handle(.showDetail(number: item.number))
            } else {
                coordinator.handle(.show(actionSheet: .makePurchaseOrdinalNumberConsumable(from: consumablesService)))
            }

        }
    }
}

final class ListViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    
    private enum Section: Hashable, CaseIterable {
        case numbers
    }
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ListViewModel.Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ListViewModel.Item>
    private typealias Registration = UICollectionView.CellRegistration<UICollectionViewListCell, ListViewModel.Item>
    private let viewModel: ListViewModel
    private let selectionSubject = PassthroughSubject<Int, Never>()

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        
        navigationItem.title = "Numbers"
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let cellRegistration = Registration { cell, indexPath, cellViewModel in
            var content = cell.defaultContentConfiguration()
            content.text = String(describing: cellViewModel.number)

            content.image = UIImage(systemName: cellViewModel.imageName)
            content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)

            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
            cell.tintColor = cellViewModel.color
        }
        
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, number) in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: number)
            })
        
        viewModel.$items
            .sink(receiveValue: { items in
                var snapshot = Snapshot()
                snapshot.appendSections(Section.allCases)
                snapshot.appendItems(items, toSection: .numbers)
                dataSource.apply(snapshot, animatingDifferences: true)
            })
            .store(in: &subscriptions)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.onSelect(viewModel.items[indexPath.row])
    }
}
