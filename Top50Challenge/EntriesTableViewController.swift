//
//  ViewController.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 23/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import UIKit
import Foundation

protocol EntrySelectionDelegate: class {
    func setupWithEntry(author: String, picture: UIImage?, title: String)
}

class EntriesTableViewController: UITableViewController {
    var data = [EntryModel]()
    weak var delegate: EntrySelectionDelegate?
}

extension EntriesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = data[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryTableViewCell
        cell.setupWithEntry(read: model.read, author: model.author, timestamp: model.timestamp, title: model.title, picture: UIImage(named: "googleLogo"), comments: model.comments)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = data[indexPath.row]
        delegate?.setupWithEntry(author: entry.author, picture: UIImage(named: "googleLogo"), title: entry.title)

        if let detailViewController = delegate as? EntryDetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
}
