//
//  TabsTableViewCell.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/13/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class TabsView: UIView {
    var viewModel: TabsViewModel? = nil

    @IBOutlet weak var firstTab: UIButton!
    @IBOutlet weak var secondTab: UIButton!
    @IBOutlet weak var indicatorView: UIView!

    @IBOutlet weak var indicatorViewLeft: NSLayoutConstraint!

    func configure(cellViewModel: TabsViewModel) {
        firstTab.bnd_title.next(cellViewModel.firstTabName)
        secondTab.bnd_title.next(cellViewModel.secondTabName)
        indicatorView.backgroundColor = UIColor.blackColor()

        firstTab.bnd_tap.observe {() in
            self.tabChanged(MyNetworkTab.First)
        }
        secondTab.bnd_tap.observe {() in
            self.tabChanged(MyNetworkTab.Second)
        }
        viewModel = cellViewModel
        tabChanged(MyNetworkTab.First)
    }

    func tabChanged(selectedTab: MyNetworkTab) {
        guard let vm = viewModel else { return }
        self.updateStylesOnSelection(selectedTab)
        vm.tabChanged(selectedTab)
    }

    private func updateStylesOnSelection(selectedTab: MyNetworkTab) {
        switch selectedTab {
        case .First:
            secondTab.applyNotSelectedTabButtonStyle()
            firstTab.applySelectedTabButtonStyle()
            animateSelectingTab(firstTab.frame.minX)
        case .Second:
            firstTab.applyNotSelectedTabButtonStyle()
            secondTab.applySelectedTabButtonStyle()
            animateSelectingTab(secondTab.frame.minX)
        }
    }

    private func animateSelectingTab(padding: CGFloat) {
        UIView.animateWithDuration(4) {[unowned self] in
            self.indicatorViewLeft.constant = padding
        }
    }
}
