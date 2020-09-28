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

    var data = [
        EntryModel(read: false, author: "Pepe", date: Date(), title: "Título 1", pictureURL: nil, comments: 5),
        EntryModel(read: false, author: "Jorge", date: Date(), title: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised", pictureURL: nil, comments: 0),
        EntryModel(read: true, author: "María", date: Date(), title: "Título 3", pictureURL: nil, comments: 48),
        EntryModel(read: false, author: "Diego", date: Date(), title: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard", pictureURL: nil, comments: 1),
        EntryModel(read: true, author: "Hernán", date: Date(), title: "Título 5", pictureURL: nil, comments: 20),
        EntryModel(read: true, author: "Nacho", date: Date(), title: "Título 6", pictureURL: nil, comments: 3),
        EntryModel(read: false, author: "Marisa", date: Date(), title: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", pictureURL: nil, comments: 70000),
        EntryModel(read: false, author: "Ayelén", date: Date(), title: "Título 8", pictureURL: nil, comments: 123),
        EntryModel(read: true, author: "Sebastián", date: Date(), title: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard", pictureURL: nil, comments: 8989)
    ]

    weak var delegate: EntrySelectionDelegate?
}

extension EntriesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = data[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryTableViewCell
        cell.setupWithEntry(read: model.read, author: model.author, date: model.date, title: model.title, picture: UIImage(named: "googleLogo"), comments: model.comments)

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
