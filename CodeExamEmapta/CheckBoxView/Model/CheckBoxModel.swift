//
//  CheckBoxModel.swift
//  CodeExamEmapta
//
//  Created by Michael San Diego on 5/5/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import Foundation

enum CheckBoxState {
    case unchecked
    case indeterminate
    case checked
}

enum CheckBoxType {
    case full
    case semi
}

struct CheckBoxModel {
    var id: String
    var type: CheckBoxType
    var state: CheckBoxState
    var label: String
    var level: NodeLevel
}
