//
//  SelectValueCellViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/7/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

protocol SelectValueCellViewModelProtocol: ViewModelProtocol {
    var valueName: String { get }
}

struct SelectValueCellViewModel: SelectValueCellViewModelProtocol {
    var router: RoutingProtocol? = nil
    let value: String

    init(value: String) {
        self.value = value
    }

    var valueName: String {
        return value
    }
}
