//
//  AppDelegate.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import Firebase
import UIKit
import Appirater

var noticeAppeared = false
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var list = [Post]()

    var scheduledTimer: Timer!
           
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = UIColor.systemGreen
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGreen
        appearance.titleTextAttributes = [.font:
        UIFont.boldSystemFont(ofSize: 20.0),
                                      .foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        //get rid of black bar undereneath nav bar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        NotificationCenter.default.addObserver(self, selector: #selector(Hi), name: Notification.Name("NotificationIdentifier1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshValue), name: Notification.Name("NotificationIdentifier2"), object: nil)
        // if user login
        
        
        //Hi()
        //else
        // non
        ///see if the user logged in, if they are logged in, then run this
        
//        let hi = TryingViewController()
//        
//        if hi.oTime == hi.targetTime {
//            hi.alertTime()
//        }

        
//        Appirater.appLaunched(true)
//        Appirater.setAppId("3182731283")
//        Appirater.setDebug(false)
//        Appirater.setDaysUntilPrompt(3)

        FirebaseApp.configure()
        
        //UserDefaults.standard.setValue(false, forKey: "Transported")
        
        if AuthManager.shared.isSignedIn {
            if UserDefaults.standard.string(forKey: "playerType") == "Player" {
                refreshValue()
                Hi()
            }
            //refreshValue()
        }
        
        
//        if AuthManager.shared.isSignedOut {
//            scheduledTimer.invalidate()
          //refreshValue()
//        }
        
        // Add dummy notification for current user
//        let id = NotificationsManager.newIdentifier()
//        let model = IGNotification(
//            identifer: id,
//            notificationType: 3,
//            profilePictureUrl: "https://iosacademy.io/assets/images/brand/icon.jpg",
//            username: "joebiden",
//            dateString: String.date(from: Date()) ?? "Now",
//            isFollowing: false,
//            postId: nil,
//            postUrl: nil
//        )
//        NotificationsManager.shared.create(notification: model, for: "iosacademy")
        return true
    }
    
    @objc func Hi() {
        NSLog("timer click")
        scheduledTimer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
            //refreshValue()
        
        // start timer
        // when there is a post, make a new timer
        // will need an array of many posts,
        
    }
    
    @objc func refreshValue() {
        //make sure this only runs for players, no need for a coach to run this
        if AuthManager.shared.isSignedOut {
            if scheduledTimer != nil{
                scheduledTimer.invalidate()
            }
        }
        #warning("test")
        let tVC = UIApplication.shared.topMostViewController()
        
        //let topMostViewController = UIApplication.shared.topMostViewController() as? UITabBarController
        //print(topMostViewController)
        //let tVC: UINavigationController = topMostViewController?.selectedViewController as! UINavigationController
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
    //        let group = DispatchGroup()
    //        group.enter()
    //        DispatchQueue.global(qos: .default).async {
    //            <#code#>
    //        }
    //        for i in postDate {
    //            let date = i.post.dateCheck
    //            print(date)
    //            let targetDate = dateFormatter.date(from: date)!
    //            let vc = PostViewController(post: i.post, owner: i.user.username)
    //            //let targetDate = dateFormatter.date(from: "2022-10-12")!
    //            let dayz = daysFromTargetDate(targetDate: targetDate)
    //            //print(wantedDate)
    //            print(dayz)
            
            //list = UserDefaults.standard.object(forKey: "Post") as! [Post]
        
///           Add it back real quick
            DatabaseManager.shared.explorePosts { [self] post in
                for i in post {
                    if i.post.openStatus == true {
                        let date = i.post.dateCheck
                        let targetDate = dateFormatter.date(from: date)!
                        let vc = PostViewController(post: i.post, owner: UserDefaults.standard.string(forKey: "username")!)
                        //let targetDate = dateFormatter.date(from: "2022-10-12")!
                        let dayz = daysFromTargetDate(targetDate: targetDate)
                        if dayz >= 7 {
                            if noticeAppeared == true{
                                return
                            }
                            ////first if it's being run, should wait a bit, wait until the user finishes this one before suggesting the next one, maybe doing something like group.wait would be good
                            let sheet = UIAlertController(
                                title: "Post Time!",
                                message: "It's been a week! You have a post awaiting you to review!",
                                preferredStyle: .alert
                            )
                            sheet.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: { [weak self] _ in

                                //let vc = ProfileViewController(user: User(username: UserDefaults.standard.string(forKey: "username")!, email: UserDefaults.standard.string(forKey: "email")!, playerType: playerType))
                                tVC?.navigationController?.pushViewController(vc, animated: true)
                                UserDefaults.standard.setValue(true, forKey: "Transported")

                                //            self?.navigationController?.pushViewController(vc, animated: true)
                                //            let dc = CameraViewController()
                                //UserDefaults.standard.setValue(false, forKey: "nextResponse")
                                //transported = true
                    //            self?.findthePost(x: realID)
                    //            self?.navigationController?.pushViewController(vc, animated: true)
                            }))
                            tVC!.present(sheet, animated: true)
                            noticeAppeared = true
                            //get rain to check this problem
                        }
            //            print("-----------------days:",days)

                    }
                }
        }
        ///stop here
        
//        for i in list {
//            let date = i.dateCheck
//            print(date)
//            let targetDate = dateFormatter.date(from: date)!
//            let vc = PostViewController(post: i, owner: UserDefaults.standard.string(forKey: "username")!)
//            //let targetDate = dateFormatter.date(from: "2022-10-12")!
//            let dayz = daysFromTargetDate(targetDate: targetDate)
//            //print(wantedDate)
//            print(dayz)
//            if dayz >= 0 {
//                ////first if it's being run, should wait a bit, wait until the user finishes this one before suggesting the next one, maybe doing something like group.wait would be good
//                let sheet = UIAlertController(
//                    title: "Post Time!",
//                    message: "Please select 3 of the best coach responses!",
//                    preferredStyle: .alert
//                )
//                sheet.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: { [weak self] _ in
//                    guard let username = UserDefaults.standard.string(forKey: "username") else {
//                        return
//                    }
//                    //let vc = ProfileViewController(user: User(username: UserDefaults.standard.string(forKey: "username")!, email: UserDefaults.standard.string(forKey: "email")!, playerType: playerType))
//                    tVC.pushViewController(vc, animated: true)
//
//
//                    //            self?.navigationController?.pushViewController(vc, animated: true)
//                    //            let dc = CameraViewController()
//                    UserDefaults.standard.setValue(true, forKey: "Transported")
//                    //UserDefaults.standard.setValue(false, forKey: "nextResponse")
//                    //transported = true
//        //            self?.findthePost(x: realID)
//        //            self?.navigationController?.pushViewController(vc, animated: true)
//                }))
//                topMostViewController!.present(sheet, animated: true) //get rain to check this problem
//            }
////            print("-----------------days:",days)
//
//        }

//            if dayz >= 0 {
//                ////first if it's being run, should wait a bit, wait until the user finishes this one before suggesting the next one, maybe doing something like group.wait would be good
//                let sheet = UIAlertController(
//                    title: "Post Time!",
//                    message: "Please select 3 of the best coach responses!",
//                    preferredStyle: .alert
//                )
//                sheet.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: { [weak self] _ in
//                    guard let username = UserDefaults.standard.string(forKey: "username") else {
//                        return
//                    }
//                    //let vc = ProfileViewController(user: User(username: UserDefaults.standard.string(forKey: "username")!, email: UserDefaults.standard.string(forKey: "email")!, playerType: playerType))
//                    tVC.pushViewController(vc, animated: true)
//
//
//                    //            self?.navigationController?.pushViewController(vc, animated: true)
//                    //            let dc = CameraViewController()
//                    UserDefaults.standard.setValue(true, forKey: "Transported")
//                    //UserDefaults.standard.setValue(false, forKey: "nextResponse")
//                    //transported = true
//        //            self?.findthePost(x: realID)
//        //            self?.navigationController?.pushViewController(vc, animated: true)
//                }))
//                topMostViewController!.present(sheet, animated: true) //get rain to check this problem
//            }
////            print("-----------------days:",days)
//        }
//        let targetDate = dateFormatter.date(from: "2022-10-12")!
//        let days = daysFromTargetDate(targetDate: targetDate)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Appirater.appEnteredForeground(true)
            //        scheduledTimer.invalidate()
            //        resetAction()
            //        let sheet = UIAlertController(
            //            title: "Post Times !",
            //            message: "Please use the 50 BALLS you used to post to select the top 3 coach comments! You can not post again until BALLS have been fairly given to coaches",
            //            preferredStyle: .alert
            //        )

            //        sheet.addAction(UIAlertAction(title: "Got it", style: .cancel, handler: nil))
            //        present(sheet, animated: true)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
#warning("demo")
    func daysFromTargetDate(targetDate: Date) -> Int {
        let now: Date = Date.now
        let tCalendar: Calendar = Calendar.current
        let diff:DateComponents = tCalendar.dateComponents([.day], from: targetDate, to: now)
        return diff.day!
    }
    
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
            
        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
//        return UIApplication.shared.key.filter { $0.isKeyWindow }.first?.rootViewController?.topMostViewController()
        return UIApplication.shared.keyWindow?.rootViewController?.topMostViewController()
    }
}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}



