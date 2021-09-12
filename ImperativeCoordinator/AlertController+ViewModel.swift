//
//  AlertController+ViewModel.swift
//  AlertController+ViewModel
//
//  Created by Josh Homann on 9/10/21.
//

import UIKit

extension UIAlertController {
    struct ActionSheetViewModel {
        var title: String?
        var message: String?
        var actions: [(title: String, handler: () -> Void)]
    }
    convenience init(viewModel: ActionSheetViewModel) {
        self.init(title: viewModel.title, message: viewModel.message, preferredStyle: .actionSheet)
        viewModel.actions.forEach { (title, handler) in
            self.addAction(.init(title: title, style: .default, handler: { _ in handler() }))
        }
    }
}

extension UIAlertController.ActionSheetViewModel {
    static func makePurchaseOrdinalNumberConsumable(from service: ConsumablesService) -> Self {
        .init(
            title: "Purchase Ordinal Number",
            message: "You are out of consumables.  Please buy more",
            actions: [
                (title: "Buy 1 for $4.99", handler: { service.purchaseOrdinalNumber(quantity: 1)}),
                (title: "Buy 3 for $12.99", handler: { service.purchaseOrdinalNumber(quantity: 3)}),
                (title: "Buy 5 for $19.99", handler: { service.purchaseOrdinalNumber(quantity: 5)}),
                (title: "Cancel", handler: { }),
            ])
    }
}
