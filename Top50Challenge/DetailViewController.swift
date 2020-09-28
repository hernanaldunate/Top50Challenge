//
//  DetailViewController.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 27/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var author: String!
    var picture: UIImage?
    var titleText: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        authorLabel.text = author
        pictureImageView.image = picture
        pictureImageView.isHidden = picture == nil
        titleLabel.text = titleText
    }

    func setupWith(author: String, picture: UIImage?, title: String) {
        self.author = author
        self.picture = picture
        self.titleText = title
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
