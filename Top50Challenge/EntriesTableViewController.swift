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
    var isFetching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView() //To prevent showing separators between empty cells
        tableView.register(EntriesTableViewFooter.nib, forHeaderFooterViewReuseIdentifier: "entriesFooter")
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
    }

    @objc func refresh(_ sender: UIRefreshControl) {
        guard !isFetching else {
            return
        }

        isFetching = true
        ApiClient.shared.getEntries(isRefreshing: true, completion: { [weak self] models in
            guard let self = self else {
                return
            }

            self.refreshControl?.endRefreshing()
            self.data = models
            self.tableView.reloadData()
            self.isFetching = false
        }, failure: { [weak self] error in
            guard let self = self else {
                return
            }

            self.refreshControl?.endRefreshing()
            self.isFetching = false
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

extension EntriesTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isFetching else {
            return
        }

        let bottomEdge = scrollView.contentOffset.y + scrollView.bounds.size.height
        if bottomEdge >= scrollView.contentSize.height {
            let quantity = min(ApiClient.shared.maxEntriesCount - self.data.count, ApiClient.shared.entriesPerPage)
            guard quantity > 0 else {
                return
            }

            isFetching = true
            ApiClient.shared.getEntries(quantity: quantity, completion: { [weak self] models in
                guard let self = self else {
                    return
                }

                self.data += models

                var indexPaths = [IndexPath]()
                for (index, _) in self.data.enumerated() {
                    if index >= self.data.count - models.count {
                        indexPaths.append(IndexPath(row: index, section: 0))
                    }
                }

                self.tableView.insertRows(at: indexPaths, with: .none)
                self.isFetching = false
            }, failure: { [weak self] error in
                self?.isFetching = false
                print(error.localizedDescription)
            })
        }
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
