//
//  DetailViewController.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 27/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

extension EntryDetailViewController: EntrySelectionDelegate {
    func setupWithEntry(author: String, picture: UIImage?, title: String) {
        loadViewIfNeeded()

        authorLabel.text = author
        pictureImageView.image = picture
        pictureImageView.isHidden = picture == nil
        titleLabel.text = title
    }
}
