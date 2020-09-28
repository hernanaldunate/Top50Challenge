//
//  DetailViewController.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 27/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.isHidden = true
        loadingLabel.isHidden = false
    }
}

extension EntryDetailViewController: EntrySelectionDelegate {
    func setupWithEntry(author: String, picture: UIImage?, title: String) {
        loadViewIfNeeded()

        scrollView.isHidden = false
        loadingLabel.isHidden = true
        
        authorLabel.text = author
        pictureImageView.image = picture
        pictureImageView.isHidden = picture == nil
        titleLabel.text = title
    }
}
