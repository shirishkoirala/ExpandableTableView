//
//  Data.swift
//  ExpandableTableView
//
//  Created by Shirish Koirala on 28/10/2024.
//

struct ExpandableCellModel {
    let heading: String
    let title: String
    let description: String
    let footer: String
    let numbers: [String]?
    var isExpanded: Bool = false
}
