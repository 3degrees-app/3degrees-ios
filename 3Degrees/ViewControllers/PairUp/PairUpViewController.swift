//
//  PairUpViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/20/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class PairUpViewController: UITableViewController, ViewProtocol, RootTabBarViewControllerProtocol {
    private lazy var viewModel: PairUpViewModel = {[unowned self] in
        let viewModel = PairUpViewModel(
            appNavigator: self,
            tableView: self.tableView,
            superTableViewDataSource: self
        )
        return viewModel
    }()

    @IBOutlet weak var mySingleCollectionView: ProposedPeopleCollectionView!
    @IBOutlet weak var proposedSinglesCollectionView: ProposedPeopleCollectionView!

    @IBOutlet weak var pairUpButton: UIButton!
    @IBOutlet weak var matchmakerName: UILabel!
    @IBOutlet weak var whoseMatchmaker: UILabel!
    @IBOutlet weak var placeOfWork: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var bio: UILabel!

    private var filterButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRightFilterButton()
        applyDefaultStyle()
        configureBindings()
        setUpLeftMenuButton()
        title = "Explore Singles"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        viewModel.prepareForSegue(segue)
    }

    func applyDefaultStyle() {
        view.backgroundColor = Constants.ViewOnBackground.Color
        tableView.tableFooterView = UIView()
        mySingleCollectionView.backgroundColor = .clearColor()
        mySingleCollectionView.clipsToBounds = false
        mySingleCollectionView.layer.masksToBounds = false
        proposedSinglesCollectionView.backgroundColor = .clearColor()
        proposedSinglesCollectionView.clipsToBounds = false
        proposedSinglesCollectionView.layer.masksToBounds = false
        pairUpButton.setTitleColor(.whiteColor(), forState: .Normal)
    }

    func configureBindings() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.emptyDataSetSource = viewModel
        tableView.emptyDataSetDelegate = viewModel

        mySingleCollectionView.configure(viewModel.mySinglesViewModel)
        proposedSinglesCollectionView.configure(viewModel.proposedSinglesViewModel)
        viewModel.pairUpButton.bindTo(pairUpButton.bnd_title)
        viewModel.pairUpButtonHidden.bindTo(pairUpButton.bnd_hidden)
        viewModel.matchmakerName.bindTo(matchmakerName.bnd_text)
        viewModel.whoseMatchmaker.bindTo(whoseMatchmaker.bnd_text)
        viewModel.placeOfWork.bindTo(placeOfWork.bnd_text)
        viewModel.jobTitle.bindTo(jobTitle.bnd_text)
        viewModel.degree.bindTo(degree.bnd_text)
        viewModel.school.bindTo(school.bnd_text)
        viewModel.bio.bindTo(bio.bnd_text)

        pairUpButton.bnd_tap.observeNew(viewModel.handlePairUpRequest)

        guard let tabBarController = self.tabBarController as? TabBarViewController else { return }
        tabBarController.matchingDelegate = viewModel
    }

    func setUpRightFilterButton() {
        filterButton.setImage(UIImage(named: "filterPage"), forState: .Normal)
        filterButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        filterButton.bnd_tap.observe {[unowned self] in
            self.viewModel.openFiltersPage()
        }
        let barButton = UIBarButtonItem(customView: filterButton)
        navigationItem.rightBarButtonItem = barButton
    }
}
