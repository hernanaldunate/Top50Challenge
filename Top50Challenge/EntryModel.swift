//
//  EntryModel.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 27/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import Foundation
import UIKit

struct EntryModel {
    var read: Bool
    let author: String
    let timestamp: Int
    let title: String
    let thumbnail: UIImage?
    let pictureURL: String?
    let comments: Int

    mutating func markAsRead() {
        self.read = true
    }
}
