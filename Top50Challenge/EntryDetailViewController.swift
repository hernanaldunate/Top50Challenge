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
    @IBOutlet weak var pictureWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pictureHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!

    private var dataTask: URLSessionDataTask?
    private var originalImageSize: CGSize?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.isHidden = true
        loadingLabel.isHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if pictureImageView.image != nil {
            resizeImage(for: scrollView.bounds.width)
        }
    }

    private func setImage(_ image: UIImage) {
        pictureImageView.isHidden = false
        pictureImageView.image = image
        resizeImage(for: scrollView.bounds.width)
    }

    private func resetImage() {
        pictureImageView.isHidden = true
        pictureImageView.image = nil
        pictureHeightConstraint.constant = 0
    }

    private func resizeImage(for containerWidth: CGFloat) {
        let imageClippedSize = contentClippingRect(for: containerWidth)
        pictureWidthConstraint.constant = imageClippedSize.width
        pictureHeightConstraint.constant = imageClippedSize.height
    }

    private func contentClippingRect(for containerWidth: CGFloat) -> CGRect {
        guard let originalImageSize = originalImageSize, originalImageSize.width > 0 && originalImageSize.height > 0 else {
            return CGRect.zero
        }

        let scale = min(containerWidth / originalImageSize.width, 1)

        let newSize = CGSize(width: originalImageSize.width * scale, height: originalImageSize.height * scale)
        let x = (containerWidth - newSize.width) * 0.5

        return CGRect(x: x, y: 0, width: newSize.width, height: newSize.height)
    }
}

extension EntryDetailViewController: EntrySelectionDelegate {
    func setupWithEntry(author: String, pictureURL: String?, thumbnail: UIImage?, title: String) {
        loadViewIfNeeded()

        scrollView.isHidden = false
        loadingLabel.isHidden = true
        authorLabel.text = author
        titleLabel.text = title
        resetImage()

        dataTask?.suspend()
        if let pictureURL = pictureURL {
            dataTask = ApiClient.shared.getImage(from: pictureURL, completion: { [weak self] image in
                guard let self = self else {
                    return
                }

                self.originalImageSize = image.size
                self.setImage(image)
            }, failure: { [weak self] error in
                guard let self = self else {
                    return
                }

                if let thumbnail = thumbnail {
                    self.originalImageSize = thumbnail.size
                    self.setImage(thumbnail)
                } else {
                    self.resetImage()
                }
            })
        } else {
            if let thumbnail = thumbnail {
                originalImageSize = thumbnail.size
                setImage(thumbnail)
            } else {
                resetImage()
            }
        }
    }
}
