//
//  FormatService.swift
//  FormatService
//
//  Created by Joshua Homann on 9/11/21.
//

import Foundation

final class FormatService {
    private let formatter: NumberFormatter
    init() {
        formatter = .init()
        formatter.numberStyle = .ordinal
    }
    func string(for number: Int) -> String {
        formatter.string(for: number) ?? ""
    }
}
