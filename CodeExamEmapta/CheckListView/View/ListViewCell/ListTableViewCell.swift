//
//  ListTableViewCell.swift
//  CodeExamEmapta
//
//  Created by Michael San Diego on 5/6/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    let kChildNodeViewCell = "ChildNodeViewCell"
    @IBOutlet weak var tblListLevel2: UITableView!
    
    var viewModel: CheckListViewModel!
    
    var node: ListNode!
    var node2 = [ListNode]()
    
    var hasChildNode: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tblListLevel2.delegate = self
        tblListLevel2.dataSource = self
        
        let nib = UINib(nibName: kChildNodeViewCell, bundle: nil)
        tblListLevel2.register(nib, forCellReuseIdentifier: kChildNodeViewCell)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(parentNode: ListNode){
        node = parentNode
        node2 = viewModel.dataFilter(parentId:node.id)
    }
}

extension ListTableViewCell: CheckBoxDelegate {
    func didTapView(at model: CheckBoxModel) {
        
    }
    
    func didTapCheckBox(at model: CheckBoxModel) {
        viewModel.toggleCheckBox(with: model)
    }
}

extension ListTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))

        let checkBox = CheckBox(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width-20, height: 50))
        checkBox.delegate = self
        
        let model = CheckBoxModel(id: node.id, type: .full, state: node.state, label: node.label, level: node.level)
        checkBox.configure(with: model)
        checkBox.contentView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        checkBox.lblTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        view.addSubview(checkBox)

        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return node2.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: kChildNodeViewCell, for: indexPath) as! ChildNodeViewCell

        cell.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50)
        
        let checkBox = CheckBox(frame: CGRect(x: 40, y: 0, width: UIScreen.main.bounds.width-40, height: 50))
        checkBox.delegate = self
        
        let item = node2[indexPath.row]
        
        let model = CheckBoxModel(id: item.id, type: .semi, state: item.state, label: item.label, level: item.level)
        checkBox.configure(with: model)
        
        checkBox.contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        checkBox.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        cell.addSubview(checkBox)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
