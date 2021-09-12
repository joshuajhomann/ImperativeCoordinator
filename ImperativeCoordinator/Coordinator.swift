//
//  Coordinator.swift
//  Coordinator
//
//  Created by Joshua Homann on 9/11/21.
//

import UIKit
import SwiftUI

protocol Coordinator {
    associatedtype Action
    func handle(_ action: Action)
}

final class ListCoordinator: Coordinator {
    typealias NavigationAction = Action
    enum Action {
        case showList, showDetail(number: Int), show(actionSheet: UIAlertController.ActionSheetViewModel)
    }

    private let navigationController = UINavigationController()
    private let window: UIWindow
    private let services: Services

    init(
        window: UIWindow,
        services: Services
    ) {
        self.window = window
        self.services = services
    }

    func handle(_ action: Action) {
        switch action {
        case .showList:
            let listViewController = ListViewController(
                viewModel: .init(
                    coordinator: self,
                    consumablesService: services.consumablesService
                )
            )
            navigationController.viewControllers = [listViewController]
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        case let .showDetail(number):
            let detailViewController = UIHostingController(
                rootView: DetailView(
                    viewModel: DetailViewModel(
                        number: number,
                        formatService: self.services.formatService
                    )
                )
            )
            navigationController.pushViewController(detailViewController, animated: true)
        case let .show(actionSheet):
            navigationController.present(UIAlertController(viewModel: actionSheet), animated: true)
        }
    }
}
