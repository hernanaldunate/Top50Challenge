//
//  EntryTableViewCell.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 27/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import UIKit

protocol EntryCellDelegate: class {
    func deleteEntry(cell: EntryTableViewCell)
    func readEntry(cell: EntryTableViewCell)
}

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!

    weak var delegate: EntryCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        statusView.layer.cornerRadius = statusView.bounds.width * 0.5
    }

    func setupWithEntry(read: Bool, author: String, timestamp: Int, title: String, thumbnail: UIImage?, comments: Int) {
        statusView.isHidden = read
        authorLabel.text = author
        titleLabel.text = title
        commentsLabel.text = String(comments)
        pictureImageView.isHidden = thumbnail == nil
        pictureImageView.image = thumbnail

        let interval = TimeInterval(timestamp)
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateLabel.text = dateFormatter.string(from: date)
    }

    @IBAction func deleteEntry(_ sender: UIButton) {
        delegate?.deleteEntry(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            delegate?.readEntry(cell: self)
        }
    }
}
