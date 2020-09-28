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
    func setupWithEntry(author: String, pictureURL: String?, thumbnail: UIImage?, title: String)
}

class EntriesTableViewController: UITableViewController {
    var data = [EntryModel]()
    weak var delegate: EntrySelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(EntriesTableViewFooter.nib, forHeaderFooterViewReuseIdentifier: "entriesFooter")
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
    }

    @objc func refresh(_ sender: UIRefreshControl) {
        ApiClient.shared.getEntries(completion: { [weak self] models in
            guard let self = self else {
                return
            }

            self.refreshControl?.endRefreshing()
            self.data = models
            self.tableView.reloadData()
        }, failure: { [weak self] error in
            self?.refreshControl?.endRefreshing()
            print(error.localizedDescription)
        })
    }
}

extension EntriesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = data[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryTableViewCell
        cell.setupWithEntry(read: model.read, author: model.author, timestamp: model.timestamp, title: model.title, thumbnail: model.thumbnail, comments: model.comments)
        cell.delegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = delegate as? EntryDetailViewController else {
            return
        }

        let entry = data[indexPath.row]
        delegate?.setupWithEntry(author: entry.author, pictureURL: entry.pictureURL, thumbnail: entry.thumbnail, title: entry.title)
        splitViewController?.showDetailViewController(detailViewController, sender: nil)

//        if let detailViewController = delegate as? EntryDetailViewController {
//            splitViewController?.showDetailViewController(detailViewController, sender: nil)
//        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "entriesFooter") as? EntriesTableViewFooter else {
            return nil
        }

        footerView.delegate = self

        return footerView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return data.isEmpty ? 0 : 50
    }
}

extension EntriesTableViewController: EntryCellDelegate {
    func deleteEntry(cell: EntryTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func readEntry(cell: EntryTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            data[indexPath.row].markAsRead()
            tableView.reloadRows(at:[indexPath], with: .none)
        }
    }
}

extension EntriesTableViewController: EntriesFooterDelegate {
    func deleteAllEntries() {
        let indexPaths = data.enumerated().map { IndexPath(row: $0.offset, section: 0) }
        data.removeAll()
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
}
