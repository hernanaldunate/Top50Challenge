//
//  SceneDelegate.swift
//  Top50Challenge
//
//  Created by Hernan Aldunate on 23/09/2020.
//  Copyright © 2020 Hernan Aldunate. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        guard let splitViewController = window?.rootViewController as? UISplitViewController, let navigationController = splitViewController.viewControllers.first
            as? UINavigationController, let entriesTableViewController = navigationController.viewControllers.first
            as? EntriesTableViewController, let detailViewController = splitViewController.viewControllers.last
            as? EntryDetailViewController else { fatalError() }

        entriesTableViewController.delegate = detailViewController

        guard let url = URL(string: "https://www.reddit.com/r/popular/top.json?limit=10") else {
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
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
                            if let firstEntry = models.first {
                                detailViewController.setupWithEntry(author: firstEntry.author, picture: UIImage(named: "googleLogo"), title: firstEntry.title)
                            }

                            entriesTableViewController.data = models
                            entriesTableViewController.tableView.reloadData()
                        }
                    }
                }
            } catch let error {
                print("Failed to load: \(error.localizedDescription)")
            }
        }.resume()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

