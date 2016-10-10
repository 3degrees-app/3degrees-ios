//
//  UserModeViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/5/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class ModeViewController: UIViewController, ViewProtocol {
    private lazy var viewModel: ModeViewModelProtocol = {
        return ModeViewModel()
    }()

    @IBOutlet weak var singleButton: UIButton!

    @IBOutlet weak var matchmakerButton: UIButton!

    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var logoLabel: UILabel!

    @IBOutlet weak var backgroundImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultStyle()
        configureBindings()
    }

    func applyDefaultStyle() {
        singleButton.applyModeButtonStyles()
        matchmakerButton.applyModeButtonStyles()

        infoLabel.applyModeInfoLabelStyles()
        logoLabel.applyModeLogoLabelStyles()

        backgroundImageView.image = UIImage(named: Constants.Mode.BackgroundImageName)
    }

    func configureBindings() {
        singleButton.bnd_tap.observe(self.viewModel.handleSingleSelected)

        matchmakerButton.bnd_tap.observe(self.viewModel.handleMatchmakerSelected)
    }
}
