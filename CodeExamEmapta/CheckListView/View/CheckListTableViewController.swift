//
//  CheckListTableViewController.swift
//  CodeExamEmapta
//
//  Created by Michael San Diego on 5/5/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class CheckListTableViewController: UITableViewController {

    var viewModel = CheckListViewModel()
    var data = [ListNode]()
    var childData = [ListNode]()
    
    let kListTableViewCell = "ListTableViewCell"
    var cellHeight:CGFloat = 0
    var kTopParentId = "-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupObservables()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    private func setupView() {
        let nib = UINib(nibName: kListTableViewCell, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: kListTableViewCell)
        
        viewModel.loadInitialData()
        data = viewModel.dataFilter(parentId: kTopParentId)
    }
    
    private func setupObservables() {
        viewModel.onDataChanged = {
            self.data = self.viewModel.dataFilter(parentId: self.kTopParentId)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let checkBox = CheckBox()
        checkBox.delegate = self
        //this is for Level 0
        let item = data[section]
        let model = CheckBoxModel(id: item.id, type: .full, state: item.state, label: item.label, level: item.level)
        checkBox.configure(with: model)
//        checkBox.btnView.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        checkBox.btnView.tag = section
        checkBox.contentView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        checkBox.lblTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return checkBox
    }
    
    @objc func handleExpandClose(btn: UIButton) {
        let section = btn.tag
        
        if data[btn.tag].isExpanded == true {
            data[btn.tag].isExpanded = false
        }
        else {
            data[btn.tag].isExpanded = true
        }
        
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
//        self.tableView.beginUpdates()
//        let sections = IndexSet.init(integer: btn.tag)
//        self.tableView.reloadSections(sections, with: .none)
////        self.tableView.reloadData()
//        self.tableView.endUpdates()
        
//        var indexPaths = [IndexPath]()
//        let sections = IndexSet.init(integer: btn.tag)
//        for row in data {
//            indexPaths.append(IndexPath(row: <#T##Int#>, section: 0))
//        }
        
//        if data[section].isExpanded {
//           tableView.deleteRows(at: indexPaths, with: .fade)
//        } else {
//           tableView.insertRows(at: indexPaths, with: .fade)
//        }
        
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if data[section].isExpanded {
        return viewModel.numberOfRows(parentId: data[section].id)
//        }
//        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        let CellIdentifier = "Cell"
//        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        
//        cell?.selectionStyle = .none
        
//        if data[indexPath.section].isExpanded {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kListTableViewCell, for: indexPath) as! ListTableViewCell
            cell.viewModel = viewModel

            let parentNodes = data[indexPath.section]
            let childNodes = viewModel.dataFilter(parentId: parentNodes.id)
            
            let childNode = childNodes[indexPath.row]
            cell.configure(parentNode: childNode)
            
            cell.tblListLevel2.layoutIfNeeded()
            cellHeight = cell.tblListLevel2.contentSize.height
            cell.tblListLevel2.reloadData()
            return cell
//        }
        
//        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if data[indexPath.section].isExpanded == true {
            return cellHeight
//        }
//        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt - \(indexPath)")
        if data[indexPath.section].isExpanded == true {
            data[indexPath.section].isExpanded = false
            let sections = IndexSet.init(integer: indexPath.section)
            self.tableView.reloadSections(sections, with: .none)
        }
        else {
            data[indexPath.section].isExpanded = true
        }
    }
}

extension CheckListTableViewController: CheckBoxDelegate {
    func didTapView(at model: CheckBoxModel) {

//        if var data: ListNode = viewModel.model.first(where: { $0.id == model.id })
//        {
//            if data.isExpanded == true {
//                data.isExpanded = false
//                let sections = IndexSet.init(integer: indexPath.section)
//                self.tableView.reloadSections(sections, with: .none)
//            }
//            else {
//                data.isExpanded = true
//            }
//        }
    }
    
    func didTapCheckBox(at model: CheckBoxModel) {
        viewModel.toggleCheckBox(with: model)
    }
}
