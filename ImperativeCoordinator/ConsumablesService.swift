//
//  ConsumablesService.swift
//  ConsumablesService
//
//  Created by Joshua Homann on 9/11/21.
//

import Foundation

final class ConsumablesService {
    @Published private(set) var ordinalNumberConsumable = 1
    func consumeOrdinalNumber() {
        ordinalNumberConsumable = max(0, ordinalNumberConsumable - 1)
    }
    func purchaseOrdinalNumber(quantity: Int) {
        ordinalNumberConsumable += quantity
    }
}
