//
//  Data.swift
//  ExpandableTableView
//
//  Created by Shirish Koirala on 28/10/2024.
//

class ExpandableCellModel {
    let title: String
    let description: String
    let isExpanded: Bool = false
    
    init(title: String, description: String) {
        self.description = description
        self.title = title
    }
}
