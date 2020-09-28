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
    case noImage
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
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, let self = self else {
                DispatchQueue.main.async {
                    failure(ApiError.noData)
                }

                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let jsonData = json["data"] as? [String: Any], let children = jsonData["children"] as? [Any] {
                        var models = [EntryModel]()

                        let entriesGroup = DispatchGroup()
                        for entry in children {
                            entriesGroup.enter()
                            if let entryDictionary = entry as? [String: Any],
                                let entryData = entryDictionary["data"] as? [String: Any],
                                let author = entryData["author"] as? String,
                                let timestamp = entryData["created"] as? Int,
                                let title = entryData["title"] as? String,
                                let comments = entryData["num_comments"] as? Int {

                                let imagesGroup = DispatchGroup()
                                var thumbnail: UIImage?
                                if let thumbnailURL = entryData["thumbnail"] as? String {
                                    imagesGroup.enter()
                                    let _ = self.getImage(from: thumbnailURL, completion: { image in
                                        thumbnail = image
                                        imagesGroup.leave()
                                    }, failure: { error in
                                        imagesGroup.leave()
                                        print(error)
                                    })
                                }

                                imagesGroup.notify(queue: .main) {
                                    let model = EntryModel(read: false, author: author, timestamp: timestamp, title: title, thumbnail: thumbnail, pictureURL: entryData["url_overridden_by_dest"] as? String, comments: comments)
                                    models.append(model)
                                    entriesGroup.leave()
                                }
                            } else {
                                entriesGroup.leave()
                            }
                        }

                        entriesGroup.notify(queue: .main) {
                            models.sort { $0.timestamp > $1.timestamp }

                            DispatchQueue.main.async {
                                completion(models)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            failure(ApiError.noData)
                        }
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }.resume()
    }

    func getImage(from path: String, completion: @escaping (UIImage) -> (), failure: @escaping (Error) -> ()) -> URLSessionDataTask? {
        guard let url = URL(string: path) else {
            failure(ApiError.badUrl)
            return nil
        }

        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    failure(ApiError.noImage)
                }

                return
            }

            DispatchQueue.main.async {
                completion(image)
            }
        }

        dataTask.resume()

        return dataTask
    }
}
