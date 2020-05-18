//
//  CheckListViewModel.swift
//  CodeExamEmapta
//
//  Created by Michael San Diego on 5/6/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import Foundation

class CheckListViewModel {
    
    var onDataChanged:(() -> Void)?
    
    var model = [ListNode]()
    
    var checkBoxes = [CheckBoxModel]()
    
    func loadInitialData() {
        //Level 0
        model.append(ListNode(id: "0", label: "Foods and Drinks", level: .topLevel, state: .unchecked, parentId: "-1"))
        model.append(ListNode(id: "9", label: "Vehicles", level: .topLevel, state: .unchecked, parentId: "-1"))
        
        //Level 1 of parentId 0
        model.append(ListNode(id: "1", label: "Foods", level: .midLevel, state: .unchecked, parentId: "0"))
        model.append(ListNode(id: "2", label: "Drinks", level: .midLevel, state: .unchecked, parentId: "0"))
        
        //Level 1 of parentId 9
        model.append(ListNode(id: "10", label: "Cars", level: .midLevel, state: .unchecked, parentId: "9"))
        model.append(ListNode(id: "11", label: "Motorbikes", level: .midLevel, state: .unchecked, parentId: "9"))
        model.append(ListNode(id: "12", label: "Planes", level: .midLevel, state: .unchecked, parentId: "9"))
        
        //Level 2 | parentId = 1
        model.append(ListNode(id: "3", label: "Chicken", level: .lowLevel, state: .unchecked, parentId: "1"))
        model.append(ListNode(id: "4", label: "Pork", level: .lowLevel, state: .unchecked, parentId: "1"))
        model.append(ListNode(id: "5", label: "Beef", level: .lowLevel, state: .unchecked, parentId: "1"))
        model.append(ListNode(id: "13", label: "Vegetables", level: .lowLevel, state: .unchecked, parentId: "1"))
        
        //Level 2 | parentId = 2
        model.append(ListNode(id: "6", label: "Softdrinks", level: .lowLevel, state: .unchecked, parentId: "2"))
        model.append(ListNode(id: "7", label: "Shakes", level: .lowLevel, state: .unchecked, parentId: "2"))
        model.append(ListNode(id: "8", label: "Beers", level: .lowLevel, state: .unchecked, parentId: "2"))
    }
    
    func numberOfRows(at data:ListNode) -> Int {
        if let count = data.childNodes?.count {
            return count
        }
        return 0
    }
    
    func childNode(at data:ListNode, at index: Int) -> ListNode {
        if let node = data.childNodes?[index] {
            return node
        }
        
        let node = ListNode(id: "", label: "", level: .lowLevel, state: .unchecked , parentId: "")
        return node
    }
    
    func dataFilter(parentId: String) -> [ListNode] {
        let filteredData = model.filter{ $0.parentId == parentId }
        return filteredData
    }
    
    func filterByLevel(with level:NodeLevel) -> [ListNode] {
        let filteredData = model.filter{ $0.level == level }
        return filteredData
    }
    
    
    func numberOfRows(parentId: String) -> Int {
        let filteredData = model.filter{ $0.parentId == parentId }
        return filteredData.count
    }
    
    func getNode(at index: Int, with id: String) -> ListNode {
        
        let nodes = dataFilter(parentId: id)
        return nodes[index]
    }
    
    
    func toggleCheckBox(with data: CheckBoxModel) {
        
        //get node in array
        if let node = model.firstIndex(where: { $0.id == data.id }) {
                
            if model[node].state == .unchecked || model[node].state == .indeterminate { model[node].state = .checked }
            else if model[node].state == .checked { model[node].state = .unchecked }
            
            checkNodes(with: model[node])

            onDataChanged?()
        }
    }
    
    private func checkNodes(with node: ListNode) {
        
        //check if has children
        let children = dataFilter(parentId: node.id)
        
        children.forEach{ child in
            if let index = model.firstIndex(where: { $0.id == child.id })  {
                if node.state == .unchecked { model[index].state = .unchecked }
                else if node.state == .checked { model[index].state = .checked }
            }
            
            let subChildren = dataFilter(parentId: child.id)
            subChildren.forEach{ subChild in
                if let index = model.firstIndex(where: { $0.id == subChild.id })  {
                    if node.state == .unchecked { model[index].state = .unchecked }
                    else if node.state == .checked { model[index].state = .checked }
                }
            }
        }
        
        //check if has parents
        var parent: ListNode? = model.first{ $0.id == node.parentId }
        while(parent != nil){
            
            let children = dataFilter(parentId: parent!.id)
            let checkStatus = children.map{ $0.state }
            
            var statusForParent: CheckBoxState = .indeterminate
            
            if checkStatus.allSatisfy({$0 == .checked}){ statusForParent = .checked }
            else if checkStatus.allSatisfy({$0 == .unchecked}){ statusForParent = .unchecked }
            
            if let index = model.firstIndex(where: { $0.id == parent!.id })  {
                model[index].state = statusForParent
            }
            parent = model.first{ $0.id == parent?.parentId }
        }
    }
}
