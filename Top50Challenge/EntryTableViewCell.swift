//
//  EntryTableViewCell.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 27/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupWith(read: Bool, author: String, date: Date, title: String, picture: UIImage?, comments: Int) {
        statusView.isHidden = read
        authorLabel.text = author
        titleLabel.text = title
        pictureImageView.image = picture
        pictureImageView.isHidden = picture == nil
        commentsLabel.text = String(comments)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateLabel.text = dateFormatter.string(from: date)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
