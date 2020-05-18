//
//  CheckBoxWidgetViewController.swift
//  CheckBoxWidget
//
//  Created by Michael San Diego on 5/7/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit
import NotificationCenter

class CheckBoxWidgetViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var tblList: UITableView!
    
    var viewModel = CheckListViewModel()
    var data = [ListNode]()
    let kListTableViewCell = "ListTableViewCell"
    var cellHeight:CGFloat = 0
    var kTopParentId = "-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupObservables()
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tblList.reloadData()
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = CGSize()
        }
        else {
            let height = viewModel.model.count > 0 ? viewModel.model.count * 50 : 50
            self.preferredContentSize = CGSize(width: 0, height: height);
        }
        
    }
    
    private func setupView() {
        let nib = UINib(nibName: kListTableViewCell, bundle: nil)
        self.tblList.register(nib, forCellReuseIdentifier: kListTableViewCell)
        
        viewModel.loadInitialData()
        data = viewModel.dataFilter(parentId: kTopParentId)
    }
    
    private func setupObservables() {
        viewModel.onDataChanged = {
            self.data = self.viewModel.dataFilter(parentId: self.kTopParentId)
            self.tblList.reloadData()
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
        
    }
}

extension CheckBoxWidgetViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let checkBox = CheckBox()
        checkBox.delegate = self
        //this is for Level 0
        let item = data[section]
        let model = CheckBoxModel(id: item.id, type: .full, state: item.state, label: item.label, level: item.level)
        checkBox.configure(with: model)
        checkBox.contentView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        checkBox.lblTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return checkBox
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(parentId: data[section].id)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tblList.dequeueReusableCell(withIdentifier: kListTableViewCell, for: indexPath) as! ListTableViewCell

        cell.viewModel = viewModel

        let parentNodes = data[indexPath.section]
        let childNodes = viewModel.dataFilter(parentId: parentNodes.id)
        
        let childNode = childNodes[indexPath.row]
        cell.configure(parentNode: childNode)
        
        cell.tblListLevel2.layoutIfNeeded()
        cellHeight = cell.tblListLevel2.contentSize.height
        cell.tblListLevel2.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

extension CheckBoxWidgetViewController: CheckBoxDelegate {
    func didTapView(at model: CheckBoxModel) {
        
    }
    
    func didTapCheckBox(at model: CheckBoxModel) {
        viewModel.toggleCheckBox(with: model)
    }
}
