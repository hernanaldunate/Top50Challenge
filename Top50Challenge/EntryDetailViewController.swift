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

    var dataTask: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.isHidden = true
        loadingLabel.isHidden = false
    }
}

extension EntryDetailViewController: EntrySelectionDelegate {
    func setupWithEntry(author: String, pictureURL: String?, thumbnail: UIImage?, title: String) {
        loadViewIfNeeded()

        scrollView.isHidden = false
        loadingLabel.isHidden = true
        authorLabel.text = author
        titleLabel.text = title
        pictureImageView.image = nil
        pictureImageView.isHidden = true

        dataTask?.suspend()
        if let pictureURL = pictureURL {
            dataTask = ApiClient.shared.getImage(from: pictureURL, completion: { [weak self] image in
                guard let self = self else {
                    return
                }

                self.pictureImageView.isHidden = false
                self.pictureImageView.image = image
            }, failure: { [weak self] error in
                self?.pictureImageView.isHidden = thumbnail == nil
                self?.pictureImageView.image = thumbnail
                print(error)
            })
        } else {
            pictureImageView.isHidden = thumbnail == nil
            pictureImageView.image = thumbnail
        }
    }
}
