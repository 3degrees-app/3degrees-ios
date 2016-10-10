//
//  UITableViewCell+Configure.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/29/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

protocol TableCellProtocol {
    associatedtype T
    func configure(cellViewModel: T)
}
