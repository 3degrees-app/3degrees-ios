//
//  MatchmakersCollectionView.swift
//  3Degrees
//
//  Created by Gigster Developer on 7/26/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

class MatchmakersCollectionView: UICollectionView, ViewProtocol {

    let sizeOfItem = CGSize(width: UIScreen.mainScreen().bounds.width, height: 90)

    func applyDefaultStyle() {
        backgroundColor = UIColor.clearColor()
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.itemSize = sizeOfItem
        pagingEnabled = true
        collectionViewLayout = flowLayout
    }

    func configureBindings() { }
}
