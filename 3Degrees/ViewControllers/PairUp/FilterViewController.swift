//
//  FilterViewController.swift
//  3Degrees
//
//  Created by Gigster Developer on 5/24/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Bond

class FilterViewController: UITableViewController, ViewProtocol {
    private lazy var viewModel: FilterViewModel = {[unowned self] in
        return FilterViewModel(appNavigator: self, delegate: self.delegate, prevFilter: self.prevFilter)
    }()

    @IBOutlet var borderViews: [UIView]!

    @IBOutlet weak var ageRangeLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var matchmakerLabel: UILabel!

    @IBOutlet weak var ageRangeTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var matchmakerTextField: UITextField!
    @IBOutlet weak var resetAllFiltersButton: UIButton!

    var delegate: FilteringProtocol? = nil
    var prevFilter: FilterModel? = nil

    var rightBarButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 35))

    var agePickerDelegate: FilterAgeRangePickerDelegate? = nil
    var agePickerDataSource: FilterAgeRangePickerDataSource? = nil
    var sexPickerDelegate: FilterGenderPickerDelegate? = nil
    var sexPickerDataSource: FilterGenderPickerDataSource? = nil

    override func viewDidLoad() {
        applyDefaultStyle()
        setDefaultValues()
        configureBindings()
        createRightButton()
        self.definesPresentationContext = false
        title = "Filters"
    }

    func applyDefaultStyle() {
        tableView.backgroundColor = Constants.ViewOnBackground.Color
        tableView.separatorColor = Constants.Filter.BorderColor
        tableView.tableFooterView = UIView(
            frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 30)
        )

        borderViews.forEach { (view) in
            view.backgroundColor = Constants.Filter.BorderColor
        }

        ageRangeLabel.textColor = Constants.Filter.CategoryColor
        sexLabel.textColor = Constants.Filter.CategoryColor
        matchmakerLabel.textColor = Constants.Filter.CategoryColor

        ageRangeTextField.textColor = Constants.Filter.ValueColor
        sexTextField.textColor = Constants.Filter.ValueColor
        matchmakerTextField.textColor = Constants.Filter.ValueColor
    }

    func configureBindings() {
        combineLatest(
            viewModel.observableAgeLeftValue,
            viewModel.observableAgeRightValue).observe {[unowned self] (left, right) in
            let leftReadable = left == nil ? "" : FilterAgeRange.getReadableName(left!)
            let rightReadable = right == nil ?
                FilterAgeRange.getReadableName(100) :
                FilterAgeRange.getReadableName(right!)
            var text = ""
            if !leftReadable.isEmpty {
                text = leftReadable
                if !rightReadable.isEmpty {
                    text += " - " + rightReadable
                }
            }
            self.ageRangeTextField.text = text
        }
        agePickerDelegate = FilterAgeRangePickerDelegate(
            leftValue: viewModel.observableAgeLeftValue,
            rightValue: viewModel.observableAgeRightValue
        )
        agePickerDataSource = FilterAgeRangePickerDataSource()
        ageRangeTextField.configurePickerView(
            agePickerDelegate!,
            dataSource: agePickerDataSource!
        )

        viewModel.observableGenderValue.observe {[unowned self] gender in
            self.sexTextField.text = gender?.rawValue ?? ""
        }
        sexPickerDelegate = FilterGenderPickerDelegate(
            enumObservableValue: viewModel.observableGenderValue
        )
        sexPickerDataSource = FilterGenderPickerDataSource()
        sexTextField.configurePickerView(
            sexPickerDelegate!,
            dataSource: sexPickerDataSource!
        )

        matchmakerTextField.delegate = viewModel
        viewModel.observableMatchmakerNameValue.bindTo(matchmakerTextField.bnd_text)

        resetAllFiltersButton.bnd_tap.observe {[unowned self] in
            self.viewModel.resetFilters()
        }
    }

    func createRightButton() {
        var font = UIFont.systemFontOfSize(15, weight: UIFontWeightThin)
        if let f = UIFont(name: "HelveticaNeue-Thin", size: 15) {
            font = f
        }
        let attributes = NSAttributedString(
            string: "Apply",
            attributes: [
                NSForegroundColorAttributeName: Constants.NavBar.TintColor,
                NSFontAttributeName: font,
            ]
        )
        rightBarButton.contentHorizontalAlignment = .Right
        rightBarButton.setAttributedTitle(attributes, forState: .Normal)
        rightBarButton.setTitle("Apply", forState: .Normal)
        rightBarButton.bnd_tap.observe {[unowned self] in
            self.viewModel.apply()
        }
        let barButton = UIBarButtonItem(customView: rightBarButton)
        navigationItem.rightBarButtonItem = barButton
    }

    func setDefaultValues() {
        let anyValue = "Any"
        ageRangeLabel.text = "Age Range"
        ageRangeTextField.placeholder = "Age Range"
        ageRangeTextField.text = anyValue

        sexLabel.text = "Gender"
        sexTextField.placeholder = "Gender"
        sexTextField.text = anyValue

        matchmakerLabel.text = "Matchmaker"
        matchmakerTextField.placeholder = "Matchmaker"
        matchmakerTextField.text = anyValue
    }
}
