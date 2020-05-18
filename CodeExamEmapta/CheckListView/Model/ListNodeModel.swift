//
//  ListNodeModel.swift
//  CodeExamEmapta
//
//  Created by Michael San Diego on 5/6/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import Foundation

struct ListNode {
    var id: String
    var label: String
    var level: NodeLevel
    var state: CheckBoxState
    var parentId: String
    var childNodes: [ListNode]?
    
    //for expanding cells
    var isExpanded: Bool = true
}

enum NodeLevel {
    case topLevel
    case midLevel
    case lowLevel
}
