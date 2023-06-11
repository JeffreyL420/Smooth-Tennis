//
//  TryingViewController.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/8/13.
//

//import UIKit
//
//var targetTime: String = "00:00:30"
//
//var oTime: String = ""
//
//var neededPost: Any = ""
//
////var transported: Bool = false
//
//class TryingViewController: UIViewController {
//
//
////    private let user: User
//
////    private var isCurrentUser: Bool {
////        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
////    }
//
//    //MARK: INIT
////    init(user: User)
////        self.user = user
////        super.init(nibName: nil, bundle: nil)
////    }
////
////    required init?(coder: NSCoder) {
////        fatalError()
////    }
//
//    private var editPost: Post = Post(id: "", caption: "", postedDate: "", postUrlString: "", likers: [], dateCheck: "", tag: "", openStatus: true)
//
//    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//
//    var timerCounting: Bool = false
//
//    var startTime: Date?
//
//    var stopTime: Date?
//
////    var mySubstring1 = ""
////    var mySubstring2 = ""
////    var mySubstring3 = ""
//
//    let userDefaults = UserDefaults.standard
//    let START_TIME_KEY = "startTime"
//    let STOP_TIME_KEY = "stopTime"
//    let COUNTING_KEY = "countingKey"
//
//    var scheduledTimer: Timer!
//
//
//    public var hours: Int = 0
//    public var mins: Int = 0
//    public var secs: Int = 0
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//    func calcRestartTime(start: Date, stop: Date) -> Date
//    {
//        let diff = start.timeIntervalSince(stop)
//        return Date().addingTimeInterval(diff)
//    }
//
//    func callThisOneFirst(with post: Post) {
//        editPost = post
//        if timerCounting
//        {
//            setStopTime(date: Date())
//            stopTimer()
//        }
//        else
//        {
//            if let stop = stopTime
//            {
//                let restartTime = calcRestartTime(start: startTime!, stop: stop)
//                setStopTime(date: nil)
//                setStartTime(date: restartTime)
//            }
//            else
//            {
//                setStartTime(date: Date())
//            }
//
//            startTimer()
//        }
//    }
//
//    func startTimer()
//    {
//        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
//        setTimerCounting(true)
////        startStopButton.setTitle("STOP", for: .normal)
////        startStopButton.setTitleColor(UIColor.red, for: .normal)
//    }
//
//    @objc func refreshValue()
//    {
//        if let start = startTime
//        {
//            let diff = Date().timeIntervalSince(start)
//            setTimeLabel(Int(diff))
//        }
//        else
//        {
//            stopTimer()
//            setTimeLabel(0)
//        }
//    }
//
//    func setTimeLabel(_ val: Int)
//    {
//        let time = secondsToHoursMinutesSeconds(val)
//        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
//        //            timeLabel.text = timeString
//        oTime = timeString
//        if oTime == targetTime {
//            alertTime()
//        }
////        var compareTime = Substring(oTime)
////        let index1 = oTime.index(oTime.endIndex, offsetBy: -2)
////        let mySubstring1 = oTime[index1...]
////        let index2 = oTime.index(oTime.startIndex, offsetBy: 3)
////        let mySubstring3 = oTime[index2...]
////        let start = oTime.index(oTime.startIndex, offsetBy: 5)
////        let end = oTime.index(oTime.endIndex, offsetBy: -2)
////        let range = start..<end
////        let mySubstring2 = oTime[range]
//        var compareTime = Substring(oTime)
//        let index1 = oTime.index(oTime.endIndex, offsetBy: -2)
//        let mySubstring1 = oTime[index1...]
//        let index2 = oTime.index(oTime.startIndex, offsetBy: 2)
//        let mySubstring3 = oTime[..<index2]
//        let start = oTime.index(oTime.startIndex, offsetBy: 3)
//        let end = oTime.index(oTime.endIndex, offsetBy: -3)
//        let range = start..<end
//        let mySubstring2 = oTime[range]
//        let stringTogether = mySubstring3 + mySubstring2 + mySubstring1
//        if Int(stringTogether)! >= 000030 {
//            alertTime()
//        }
//        print(oTime)
//    }
//
//    func alertTime() {
//        scheduledTimer.invalidate()
//        resetAction()
//        let topMostViewController = UIApplication.shared.topMostViewController() as? UITabBarController
//        let tVC: UINavigationController = topMostViewController?.selectedViewController as! UINavigationController
//
//
//
//        let sheet = UIAlertController(
//            title: "Post Time!",
//            message: "Please use the 50 BALLS you used to post to select the top 3 coach comments! You can not post again until BALLS have been fairly given to coaches",
//            preferredStyle: .alert
//        )
//        sheet.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: { [weak self] _ in
//            guard let username = UserDefaults.standard.string(forKey: "username") else {
//                return
//            }
//            //let vc = ProfileViewController(user: User(username: UserDefaults.standard.string(forKey: "username")!, email: UserDefaults.standard.string(forKey: "email")!, playerType: playerType))
//            DatabaseManager.shared.findUser(username: username) { [weak self] user in
//                DispatchQueue.main.async {
//                    guard let user = user else {
//                        return
//                    }
//                    let vc = ProfileViewController(user: user)
//                    tVC.pushViewController(vc, animated: true)
//                }
//            }
////            self?.navigationController?.pushViewController(vc, animated: true)
////            let dc = CameraViewController()
//            UserDefaults.standard.setValue(true, forKey: "Transported")
//            //UserDefaults.standard.setValue(false, forKey: "nextResponse")
//            //transported = true
////            self?.findthePost(x: realID)
////            self?.navigationController?.pushViewController(vc, animated: true)
//        }))
//        topMostViewController!.present(sheet, animated: true) //get rain to check this problem
//    }
//
//
//    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int)
//    {
//        let hour = ms / 3600
//        let min = (ms % 3600) / 60
//        let sec = (ms % 3600) % 60
//        return (hour, min, sec)
//    }
//
//    func makeTimeString(hour: Int, min: Int, sec: Int) -> String
//    {
//        var timeString = ""
//        timeString += String(format: "%02d", hour)
//        timeString += ":"
//        timeString += String(format: "%02d", min)
//        timeString += ":"
//        timeString += String(format: "%02d", sec)
//        return timeString
//    }
//
//    func stopTimer()
//    {
//        if scheduledTimer != nil
//        {
//            scheduledTimer.invalidate()
//        }
//        setTimerCounting(false)
////        startStopButton.setTitle("START", for: .normal)
////        startStopButton.setTitleColor(UIColor.systemGreen, for: .normal)
//    }
//
//    func resetAction() {
//        setStopTime(date: nil)
//        setStartTime(date: nil)
//        oTime = makeTimeString(hour: 0, min: 0, sec: 0)
//        stopTimer()
//
//    }
//
//
//    //       @objc func resetAction(_ sender: Any)
//    //        {
//    //            setStopTime(date: nil)
//    //            setStartTime(date: nil)
//    //            timeLabel.text = makeTimeString(hour: 0, min: 0, sec: 0)
//    //            stopTimer()
//    //        }
//
//    func setStartTime(date: Date?)
//    {
//        startTime = date
//        userDefaults.set(startTime, forKey: START_TIME_KEY)
//    }
//
//    func setStopTime(date: Date?)
//    {
//        stopTime = date
//        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
//    }
//
//    func setTimerCounting(_ val: Bool)
//    {
//        timerCounting = val
//        if timerCounting == false && editPost.id != "" {
//            DatabaseManager.shared.editPostStatus(with: editPost) { success in
//                guard success else {
//                    return
//                }
//            }
//        }
//        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
//    }
//
//}
