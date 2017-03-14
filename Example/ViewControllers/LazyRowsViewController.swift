//
//  LazyRowsViewController.swift
//  DataSource
//
//  Created by Matthias Buchetics on 08/03/2017.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource

// MARK: - View Controller

class LazyRowsViewController: UITableViewController {
    
    let count = 1000
    var cachedRows = [Int: LazyRowType]()
    
    lazy var dataSource: DataSource = {
        DataSource([
            CellDescriptor<String, TitleCell>()
                .configure { (title, cell, indexPath) in
                    let fraction = Double(indexPath.row) / Double(self.count)
                    
                    cell.textLabel?.text = title
                    cell.backgroundColor = UIColor.interpolate(from: UIColor.white, to: UIColor.red, fraction: fraction)
                }
                .didSelect { (title, indexPath) in
                    print("selected: \(title)")
                    return .deselect
            }
        ])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.sections = [
            LazySection(key: "lazy", count: { self.count }) { (index) in
                return self.cachedRow(at: index)
            }
            .header {
                let view = self.createSectionHeaderView()
                return .view(view)
            }
        ]
        
        tableView.estimatedRowHeight = 44.0
        tableView.sectionHeaderHeight = 40.0
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    func cachedRow(at index: Int) -> LazyRowType {
        if let row = cachedRows[index] {
            print("cached row: \(index)")
            return row
        } else {
            print("create row: \(index)")
            let row = LazyRow<String>({
                return "\(index)"
            })
            cachedRows[index] = row
            return row
        }
    }
    
    func createSectionHeaderView() -> UIView {
        let label = UILabel()
        label.backgroundColor = UIColor.darkGray
        label.textAlignment = .center
        label.text = "Lazy Rows"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        return label
    }
}
