//
//  ProposedPeopleViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/20/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import ThreeDegreesClient
import DZNEmptyDataSet

protocol ProposedPeopleDelegate {
    func personDisplayed(user: UserInfo, mode: ProposedPeopleCollectionViewModel.Own)
    func loadMore(type: ProposedPeopleCollectionViewModel.Own)
}

extension ProposedPeopleCollectionViewModel: DZNEmptyDataSetSource {
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: Constants.Fonts.DefaultThin,
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]

        let attributedString = NSAttributedString(
            string: R.string.localizable.emptyProposedSinglesMessage(),
            attributes: attributes)
        return attributedString
    }
}

extension ProposedPeopleCollectionViewModel: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldFadeIn(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return isEmpty() && type == .Alian
    }
}

extension ProposedPeopleCollectionViewModel: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellId = ProposedPersonCollectionCell.identifier
        let typelessCell = collectionView.dequeueReusableCellWithReuseIdentifier(
            cellId,
            forIndexPath: indexPath)
        guard let cell = typelessCell as? ProposedPersonCollectionCell else { return typelessCell }
        let person = people[indexPath.item]
        let viewModel = ProposedPersonCellViewModel(person: person)
        cell.configure(viewModel)
        if indexPath.item == people.count - 1 {
            self.delegate?.loadMore(type)
        }

        return cell
    }
}

extension ProposedPeopleCollectionViewModel: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        guard !people.isEmpty else {
            collectionView?.reloadData()
            return
        }
        if let person = people.first where people.count == 1 {
            delegate?.personDisplayed(person, mode: type)
        } else {
            guard let width = collectionView?.frame.width, offset = collectionView?.contentOffset.x
                else { return }
            let currentItem = Int(ceil(offset / width))
            guard currentItem < people.count else { return }
            delegate?.personDisplayed(people[currentItem], mode: type)
        }
    }
}

extension ProposedPeopleCollectionViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath
        indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
}

class ProposedPeopleCollectionViewModel: NSObject, ViewModelProtocol {
    var people: [UserInfo] = []
    var appNavigator: AppNavigator?
    var delegate: ProposedPeopleDelegate? = nil
    let type: Own
    var collectionView: UICollectionView? = nil

    init(appNavigator: AppNavigator, type: Own) {
        self.appNavigator = appNavigator
        self.type = type
    }

    func removePerson(user: UserInfo) {
        guard let indexOfPerson = people.indexOf({ $0.username == user.username }) else { return }
        people.removeAtIndex(indexOfPerson)
        collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: indexOfPerson, inSection: 0)])
        guard let scrollView = collectionView else { return }
        scrollViewDidEndDecelerating(scrollView)
    }


    func isEmpty() -> Bool {
        return people.isEmpty
    }

    func loadNewData(users: [UserInfo]) {
        if people.isEmpty {
            people = users
            collectionView?.reloadData()
            if !people.isEmpty {
                guard let firstUser = people.first else { return }
                delegate?.personDisplayed(firstUser, mode: type)
            }
            return
        }
        users.forEach {[unowned self] (user) in
            let ip = NSIndexPath(forItem: self.people.count, inSection: 0)
            self.people.append(user)
            self.collectionView?.insertItemsAtIndexPaths([ip])
        }
    }

    func nextAfter(user: UserInfo) {
        guard let indexOfPerson = people.indexOf({ $0.username == user.username }) else { return }
        if indexOfPerson != people.count - 1 {
            showUser(people[indexOfPerson + 1])
        }
    }

    func reset() {
        people = []
        collectionView?.reloadData()
    }

    func showUser(user: UserInfo) {
        guard let indexOfUser = people.indexOf({ $0.username == user.username }) else { return }
        collectionView?.scrollToItemAtIndexPath(
            NSIndexPath(forItem: indexOfUser, inSection: 0),
            atScrollPosition: .CenteredHorizontally,
            animated: true)
        delegate?.personDisplayed(people[indexOfUser], mode: type)
    }

    enum Own {
        case Mine
        case Alian
    }
}
