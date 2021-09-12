//
//  DetailView.swift
//  DetailView
//
//  Created by Josh Homann on 9/10/21.
//

import SwiftUI

final class DetailViewModel: ObservableObject {
    let text: String
    init(
        number: Int,
        formatService: FormatService
    ) {
        text = formatService.string(for: number)
    }
}

struct DetailView: View {
    @StateObject var viewModel: DetailViewModel
    var body: some View {
        Text(viewModel.text).font(.largeTitle)
    }
}
