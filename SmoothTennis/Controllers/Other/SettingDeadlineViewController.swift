//
//  SettingDeadlineViewController.swift
//  Instagram
//
//  Created by Jeffrey Liang on 2022/8/2.
//

import UIKit

class SettingDeadlineViewController: UIViewController {

    var timerCounting: Bool = false
    
    var startTime: Date?
    
    var stopTime: Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"

    
    private let timerLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var scheduledTimer: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        view.addSubview(resetButton)
        startButton.addTarget(self, action: #selector(startStopAction), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        
        if timerCounting {
            startTimer()
        }
        else {
            stopTimer()
            if let start = startTime {
                if let stop = stopTime {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                     setTimeLabel(Int(diff))
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timerLabel.frame = CGRect(x: 150, y: 50, width: 500, height: 100)
    }
    
    @objc func startStopAction() {
        if timerCounting {
            setStopTime(date: Date())
            stopTimer()
        }
        else {
            
            if let stop = stopTime {
                let restartTime  = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            }
            else {
                setStartTime(date: Date())
            }
                
            startTimer()
        }
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    func stopTimer() {
        if scheduledTimer != nil {
            scheduledTimer.invalidate()
        }
        setTimerCounting(false)
        startButton.setTitle("START", for: .normal)
        startButton.setTitleColor(UIColor.red, for: .normal)
    }
    
    func startTimer() {
        
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        startButton.setTitle("STOP", for: .normal)
        startButton.setTitleColor(UIColor.red, for: .normal)
    }
    
    @objc func refreshValue() {
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
        }
        else {
            stopTimer()
            setTimeLabel(0)
        }
    }
    
    func setTimeLabel(_ val: Int) {
        let time = secondsToHoursMinutesSecond(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timerLabel.text = timeString
    }
    
    func secondsToHoursMinutesSecond(_ ms: Int) -> (Int, Int, Int) {
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return(hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    @objc func resetAction() {
        setStopTime(date: nil)
        setStartTime(date: nil)
        timerLabel.text = makeTimeString(hour: 0, min: 0, sec: 0)
        stopTimer()
    }
    
    func setStartTime(date: Date?) {
        
        startTime = date
        userDefaults.set(date, forKey: START_TIME_KEY)
    }
          
    func setStopTime(date: Date?) {
        
        startTime = date
        userDefaults.set(date, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool) {
        
        timerCounting = val
        userDefaults.set(val, forKey: COUNTING_KEY)
    }

}
