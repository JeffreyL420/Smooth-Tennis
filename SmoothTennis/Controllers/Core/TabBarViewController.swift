//
//  TabBarViewController.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import UIKit

/// Primary tab controller for core app UI
final class TabBarViewController: UITabBarController {

    // MARK: - Lifecycle

    var email1: String = "";
    var username: String = "";
    var playerType: String = "";
    var playerLevel: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
        self.tabBarController?.tabBar.isTranslucent = false
    }

    /// Sets up tab bar controllers
    private func setUpControllers() {
    
//        if UserDefaults.standard.string(forKey: "playerType") != nil{
//            guard var email = UserDefaults.standard.string(forKey: "email") else {
//                return
//            }
//            //            DatabaseManager.shared.findUser(with: email) { [weak self] user in
//                UserDefaults.standard.setValue(user?.username, forKey: "username")
//                UserDefaults.standard.setValue(user?.playerType, forKey: "playerType")
//                UserDefaults.standard.setValue(user?.playerLevel, forKey: "playerLevel")
//                self?.email1 = UserDefaults.standard.string(forKey: "email")!
//                self?.username = UserDefaults.standard.string(forKey: "username")!
//                self?.playerType = UserDefaults.standard.string(forKey: "playerType")!
//                self?.playerLevel = UserDefaults.standard.string(forKey: "playerLevel")!
//            }
//        }
//        else {
            email1 = UserDefaults.standard.string(forKey: "email")!
            username = UserDefaults.standard.string(forKey: "username")!
            playerType = UserDefaults.standard.string(forKey: "playerType")!
            playerLevel = UserDefaults.standard.string(forKey: "playerLevel")!
        //}
        
        
        //        guard let email = UserDefaults.standard.string(forKey: "email"),
        //              let username = UserDefaults.standard.string(forKey: "username"),
        //              let playerType = UserDefaults.standard.string(forKey: "playerType"),
        //              var playerLevel = UserDefaults.standard.string(forKey: "playerLevel")
        //        else {
        //            return
        //        }
        
//        let email = "hoof@gmail.com"
//        let username = "Hoof"
//        let playerType = "Player"
//        var playerLevel = "Intermediate"
        
        
        setUpControllersPart2(username: username, playerLevel: playerLevel, email1: email1, playerType: playerType)
    }
    private func setUpControllersPart2(username: String, playerLevel: String, email1: String, playerType: String) {
        var topComments = UserDefaults.standard.integer(forKey: "topComments")
        DatabaseManager.shared.getCoachCommentAmount(username: username) { amount in
            
            topComments = amount
        }
//        DatabaseManager.shared.getPlayerLevel(username: username) { result in
//
//            playerLevel = result
//        }
//        guard let playerLevel = UserDefaults.standard.string(forKey: "playerLevel") else {
//            return
//        }
    
      


        let currentUser = User(
            username: username,
            email: email1,
            playerType: playerType,
            topComments: topComments,
            playerLevel: playerLevel
        )
        


        // Define VCs
        let home = HomeViewController()
        //let explore = ExploreViewController()
        let explore = ExploreV2ViewController()
        let camera = CameraV2ViewController()
        let activity = NotificationsViewController()
        let profile = ProfileViewController(user: currentUser)
        let trackingCoach = TrackingCoachViewController()
        let trackingPlayer = TrackingPlayerViewController()
        //let purchase = PurchaseViewController()

        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: camera)
        let nav4 = UINavigationController(rootViewController: activity)
        let nav5 = UINavigationController(rootViewController: profile)
        let nav6 = UINavigationController(rootViewController: trackingCoach)
        let nav7 = UINavigationController(rootViewController: trackingPlayer)
        //let nav8 = UINavigationController(rootViewController: purchase)

        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        nav5.navigationBar.tintColor = .label
        nav6.navigationBar.tintColor = .label
        nav7.navigationBar.tintColor = .label
        //nav8.navigationBar.tintColor = .label

        if #available(iOS 14.0, *) {
            home.navigationItem.backButtonDisplayMode = .minimal
            explore.navigationItem.backButtonDisplayMode = .minimal
            camera.navigationItem.backButtonDisplayMode = .minimal
            activity.navigationItem.backButtonDisplayMode = .minimal
            profile.navigationItem.backButtonDisplayMode = .minimal
            //purchase.navigationItem.backButtonDisplayMode = .minimal
        } else {
            nav1.navigationItem.backButtonTitle = ""
            nav2.navigationItem.backButtonTitle = ""
            nav3.navigationItem.backButtonTitle = ""
            nav4.navigationItem.backButtonTitle = ""
            nav5.navigationItem.backButtonTitle = ""
            nav7.navigationItem.backButtonTitle = ""
        }

        // Define tab items
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "All Posts", image: UIImage(systemName: "safari"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Post", image: UIImage(systemName: "arrowtriangle.up.circle"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: 1)
        nav5.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        nav6.tabBarItem = UITabBarItem(title: "Tracking", image: UIImage(systemName: "plus"), tag: 1)
        nav7.tabBarItem = UITabBarItem(title: "Tracking", image: UIImage(systemName: "plus"), tag: 1)
        //nav8.tabBarItem = UITabBarItem(title: "Purchase", image: UIImage(systemName: "purchased.circle"), tag: 1)

        // Set controllers
        if playerType == "Coach" {
            self.setViewControllers(
                [nav2, nav5, nav6],
                animated: false
            )
        }
        else if playerType == "Player" {
            self.setViewControllers(
                [nav2, nav3, nav5, nav7],
                animated: false
            )
        }
    }
    
}
