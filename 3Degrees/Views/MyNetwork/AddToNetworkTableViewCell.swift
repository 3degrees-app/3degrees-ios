//
//  AddToNetworkTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/13/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class AddToNetworkTableViewCell: UITableViewCell, TableCellProtocol {
    typealias T = AddToNetworkViewModel
    private var viewModel: AddToNetworkViewModel? = nil

    @IBOutlet weak var addToNetworkLabel: UILabel!

    func configure(cellViewModel: T) {
        viewModel = cellViewModel
        addToNetworkLabel.bnd_text.next(cellViewModel.actionTitle)
        addToNetworkLabel.textColor = Constants.MyNetwork.InfoLabelColor
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: viewModel,
            action: #selector(cellViewModel.tapped)
        )
        contentView.addGestureRecognizer(tapGestureRecognizer)
        contentView.backgroundColor = Constants.ViewOnBackground.Color
    }
}
