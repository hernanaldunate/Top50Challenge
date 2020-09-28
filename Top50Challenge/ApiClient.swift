//
//  ApiClient.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 28/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import UIKit

enum ApiError: Error {
    case badUrl
    case noData
}

class ApiClient: NSObject {
    static let shared = ApiClient()

    override private init() {}

    func getEntries(completion: @escaping ([EntryModel]) -> (), failure: @escaping (Error) -> ()) {
        guard let url = URL(string: "https://www.reddit.com/r/popular/top.json?limit=10") else {
            failure(ApiError.badUrl)
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                failure(ApiError.noData)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let jsonData = json["data"] as? [String: Any], let children = jsonData["children"] as? [Any] {
                        var models = [EntryModel]()

                        for entry in children {
                            if let entryDictionary = entry as? [String: Any],
                                let entryData = entryDictionary["data"] as? [String: Any],
                                let author = entryData["author"] as? String,
                                let title = entryData["title"] as? String,
                                let timestamp = entryData["created"] as? Int,
                                let comments = entryData["num_comments"] as? Int {
                                let model = EntryModel(read: false, author: author, timestamp: timestamp, title: title, pictureURL: nil, comments: comments)
                                models.append(model)
                            }
                        }

                        models.sort { $0.timestamp > $1.timestamp }

                        DispatchQueue.main.async {
                            completion(models)
                        }
                    } else {
                        failure(ApiError.noData)
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }.resume()
    }
}
