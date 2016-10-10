//
//  TabsViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/13/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

struct TabsViewModel: ViewModelProtocol {
    var router: RoutingProtocol? = nil

    typealias TabChangedType = (MyNetworkTab) -> ()

    var firstTabName: String {
        return MyNetworkTab.First.name
    }

    var secondTabName: String {
        return MyNetworkTab.Second.name
    }

    let tabChangedAction: TabChangedType

    init(tabChangedAction: TabChangedType) {
        self.tabChangedAction = tabChangedAction
    }

    func tabChanged(tab: MyNetworkTab) {
        tabChangedAction(tab)
    }
}
