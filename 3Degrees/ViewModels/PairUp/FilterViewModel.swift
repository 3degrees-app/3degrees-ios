//
//  FilterViewModel.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/24/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation
import Bond

protocol FilteringProtocol {
    func filtersSelected(filter: FilterModel)
}

extension FilterViewModel: ContactSelectDelegate {
    func selected(contact: UserInfo) {
        matchmaker = contact
        observableMatchmakerNameValue.next(contact.fullName)
        self.searchController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension FilterViewModel: UISearchControllerDelegate {
    func willDismissSearchController(searchController: UISearchController) {
        if !searchController.isBeingDismissed() {
            searchController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}


extension FilterViewModel: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if !(textField.inputView is UIPickerView) {
            if !textField.isAskingCanBecomeFirstResponder {
                handleMatchmaker()
                return false
            }
        }
        return true
    }
}

class FilterViewModel: NSObject, ViewModelProtocol {
    var router: RoutingProtocol?
    var delegate: FilteringProtocol?

    init(router: RoutingProtocol, delegate: FilteringProtocol?, prevFilter: FilterModel?) {
        self.router = router
        self.delegate = delegate
        observableAgeLeftValue.next(prevFilter?.ageFrom)
        observableAgeRightValue.next(prevFilter?.ageTo)
        observableGenderValue.next(prevFilter?.gender)
        observableMatchmakerNameValue.next(prevFilter?.matchmaker?.fullName)
        matchmaker = prevFilter?.matchmaker
    }

    private lazy var searchController: UISearchController? = {[unowned self] in
        let storyboard = R.storyboard.myNetworkScene
        guard let viewController = storyboard.contactSearchTableViewController()
            else { return nil }
        viewController.userType.next(.Matchmakers)
        viewController.mode = .Select
        viewController.selectionDelegate = self
        let searchController = UISearchController(searchResultsController: viewController)
        searchController.searchResultsUpdater = viewController.searchResultsUpdater
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search For Matchmakers"
        return searchController
    }()

    let observableAgeLeftValue: Observable<Int?> = Observable(nil)
    let observableAgeRightValue: Observable<Int?> = Observable(nil)
    let observableGenderValue: Observable<FilterGender?> = Observable(nil)
    let observableMatchmakerNameValue: Observable<String?> = Observable("")
    var matchmaker: UserInfo? = nil


    func apply() {
        let filter = FilterModel(matchmaker: matchmaker,
                                 ageFrom: observableAgeLeftValue.value,
                                 ageTo: observableAgeRightValue.value,
                                 gender: observableGenderValue.value)
        delegate?.filtersSelected(filter)
        self.router?.popAction()
    }

    func handleMatchmaker() {
        guard let controller = searchController else { return }
        self.router?.presentVcAction(vc: controller)
    }

    func resetFilters() {
        observableAgeLeftValue.next(nil)
        observableAgeRightValue.next(nil)
        observableGenderValue.next(nil)
        observableMatchmakerNameValue.next(nil)
        matchmaker = nil
    }
}
