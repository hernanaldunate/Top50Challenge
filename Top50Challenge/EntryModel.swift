//
//  EntryModel.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 27/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import Foundation

struct EntryModel {
    let read: Bool
    let author: String
    let date: Date
    let title: String
    let pictureURL: String?
    let comments: Int
}
