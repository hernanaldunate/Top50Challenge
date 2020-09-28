//
//  EntriesTableViewFooter.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 28/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import UIKit

protocol EntriesFooterDelegate: class {
    func deleteAllEntries()
}

class EntriesTableViewFooter: UITableViewHeaderFooterView {
    @IBOutlet weak var deleteButton: UIButton!

    weak var delegate: EntriesFooterDelegate?

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    @IBAction func deleteAllEntries(_ sender: UIButton) {
        delegate?.deleteAllEntries()
    }
}
