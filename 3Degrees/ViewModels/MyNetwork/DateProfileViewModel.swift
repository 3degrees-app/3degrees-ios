//
//  DateProfileViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Rswift

extension DateProfileViewModel: UITableViewDelegate {
    func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let descriptor = rowsDescriptors[indexPath.row]
        if descriptor == .MatchmakerCell {
            return 95
        }
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView,
                   estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
}

extension DateProfileViewModel: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return rowsDescriptors.count
    }

    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let descriptor = rowsDescriptors[indexPath.row]

        switch descriptor {
        case .HeaderCell:
            let avatarUrl = user.avatarUrl ?? ""
            return getHeaderCell(user.fullName, info: user.info, avatar: avatarUrl)
        case .MatchmakerCell:
            return getMatchmakersCell(user.userMatchmakers)
        case .OccupationCell:
            return getTwoFieldsCell(
                user.title,
                subtitle: user.placeOfWork,
                icon: R.image.occupationIcon.name)
        case .EducationCell:
            return getTwoFieldsCell(
                user.degree,
                subtitle: user.school,
                icon: R.image.educationIcon.name)
        case .BioCell:
            return getOneFieldCell(user.biography, icon: R.image.bioIcon.name)
        }
    }

    private func getTwoFieldsCell(
        title: String,
        subtitle: String,
        icon: String) -> UITableViewCell {
        let cellId = R.reuseIdentifier.twoFieldsCell.identifier
        let viewModel = TwoFieldsCellViewModel(icon: icon,
                                               title: title,
                                               subtitle: subtitle,
                                               appNavigator: nil)
        guard let cell: TwoFieldsTableViewCell = tableView.getCell(viewModel,
                                                                   cellIdentifier: cellId)
            else { return UITableViewCell() }
        return cell
    }

    private func getOneFieldCell(title: String,
                                 icon: String = "") -> UITableViewCell {
        let viewModel = OneFieldCellViewModel(icon: icon, title: title, appNavigator: nil)
        let cellId = R.reuseIdentifier.oneFieldCell.identifier
        guard let cell: OneFieldTableViewCell = tableView.getCell(viewModel,
                                                                  cellIdentifier: cellId)
            else { return UITableViewCell() }
        return cell
    }

    private func getHeaderCell(name: String,
                               info: String,
                               avatar: String) -> UITableViewCell {
        let viewModel = HeaderCellViewModel(
            avatar: avatar,
            name: name,
            info: info,
            chatButtonPressed: goToChat,
            matchButtonPressed: matchUser,
            appNavigator: appNavigator
        )
        let cellId = R.reuseIdentifier.headerCell.identifier
        guard let cell: HeaderTableViewCell = tableView.getCell(viewModel,
                                                                cellIdentifier: cellId)
            else { return UITableViewCell() }

        return cell
    }

    private func getMatchmakersCell(matchmakers: [UserInfo]) -> UITableViewCell {
        let viewModel = MatchmakersViewModel(matchmakers: matchmakers, appNavigator: appNavigator)
        let cellId = R.reuseIdentifier.matchmakerTableViewCell.identifier
        guard let cell: MatchmakerTableViewCell = tableView.getCell(viewModel,
                                                                    cellIdentifier: cellId)
            else { return UITableViewCell() }
        matchmakersViewModel = viewModel
        return cell
    }

    func goToChat() {
        let segueId = R.segue.dateProfileViewController.toChat.identifier
        appNavigator?.showAction(identifier: segueId)
        return
    }

    func matchUser() {
        if self.selectedTab.isSingles {
            matchingDelegate?.selectSingleForMatching(self.user)
        } else {
            matchingDelegate?.selectMatchmakerForMatching(self.user)
        }
        return
    }
}

class DateProfileViewModel: NSObject, ViewModelProtocol {
    var matchingDelegate: PersonForMatchingSelected? = nil
    let user: UserInfo
    let tableView: UITableView
    let selectedTab: MyNetworkTab
    var appNavigator: AppNavigator?
    var matchmakersViewModel: MatchmakersViewModel? = nil
    let rowsDescriptors: [TableRows]

    init(user: UserInfo, selectedTab: MyNetworkTab, tableView: UITableView, appNavigator: AppNavigator) {
        self.user = user
        self.tableView = tableView
        self.appNavigator = appNavigator
        self.selectedTab = selectedTab
        self.rowsDescriptors = TableRows.getRowsForUser(user, userType: selectedTab.tabKind)
    }

    func prepareForSegue(segue: UIStoryboardSegue) {
        let id = segue.identifier
        if id == R.segue.dateProfileViewController.toChat.identifier {
            guard let vc = segue.destinationViewController as? ChatViewController
                else { return }
            vc.interlocutor = user
        }
        if id == R.segue.dateProfileViewController.toChatWithMatchmaker.identifier {
            guard let vc = segue.destinationViewController as? ChatViewController
                else { return }
            vc.interlocutor = matchmakersViewModel?.getCurrentSelectedMatchmaker()
        }
    }

    enum TableRows {
        case HeaderCell
        case MatchmakerCell
        case OccupationCell
        case EducationCell
        case BioCell

        static let all: [TableRows] = [
            .HeaderCell, .OccupationCell, .EducationCell, .BioCell
        ]

        static let allForDate: [TableRows] = [
            .HeaderCell, .MatchmakerCell, .OccupationCell, .EducationCell, .BioCell
        ]

        static func getRowsForUser(user: UserInfo, userType: MyNetworkTab.UsersType) -> [TableRows] {
            var rows:[TableRows] = [.HeaderCell]
            if userType == .Dates {
                rows.append(.MatchmakerCell)
            }
            if !user.placeOfWork.isEmpty || !user.title.isEmpty {
                rows.append(.OccupationCell)
            }
            if !user.school.isEmpty || !user.degree.isEmpty {
                rows.append(.EducationCell)
            }
            if !user.biography.isEmpty {
                rows.append(.BioCell)
            }
            return rows
        }
    }
}
