//
//  PlayerViewController.swift
//  SmoothTennis
//
//  Created by shakespeare on 2022/10/18.
//

import Foundation
import UIKit
import AVFoundation

/**
 两种初始化方法
 let url = URL()
 let playVC = PlayerViewController(url: url)
  
 let urls:Array<URL> = []
 let playVC = PlayerViewController(videoName: "VideoName", urls: urls, preferred: 0)
  
 self.navigationController?.pushViewController(playVC, animated: true)

 */
 
class PlayerViewController: UIViewController {
    private var videoName = "未知视频"
    //播放源队列
    private var videoQueue:Array<URL> = []
    //播放控制
    private var avPlayer = AVPlayer()
    //访问资源信息等
    private var playItem:AVPlayerItem!
    //控制视频内容在UI上的显示
    var playerLayer = AVPlayerLayer(player: AVPlayer())
    //用于监听播放进度
    private var playTimeObserver:Any?
    
    //UI控件
    private var videoView = UIView()
    private let progressView = UISlider()
    private let timeLabel = UILabel()
    private let playButton = UIButton()
    //底部控制栏
    private let controllView = UIView()
    //自定义顶部导航栏
    private let navigationView = UIView()
    
    //存储当前视频的最大时长
    private var maxTime = "--:--"
    
    //标志当前视频在播放队列中的位置
    private var currentIndex = 0
    //标志进度是否被拖动
    private var isSliding = false
    //标志用户的触摸状态
    private var isTouching = false
    //标志手指在屏幕上开始移动的坐标
    private var startPoint:CGPoint = CGPoint(x: 0, y: 0)
    //标志手指上次触摸位置的坐标
    private var lastPoint:CGPoint = CGPoint(x: 0, y: 0)
    
 
    /*
     初始化参数 url:URL
     描述 该模式下不显示下个视屏按钮
     **/
    init(videoName:String, url: URL) {
        self.init()
        self.videoName = videoName
        self.videoQueue.append(url)
    }
    
    /*
    初始化参数 urls:[URL]
    描述 可以动态切换播放源
    **/
    init(videoName:String, urls:[URL], preferred:Int) {
        self.init()
        self.videoName = videoName
        self.videoQueue = urls
        //设置默认播放源
        if self.videoQueue.count <= 0 {return}
        switchPlayBackSource(url: videoQueue[preferred])
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setUI()
    }
    
    //监听播放准备是否就绪
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
             //获取更改后的状态
            guard let ch = change else { return }
            
            for value in ch.values {
                let status:Int = value as! Int
                switch status {
                case 0:
                    print("AVPlayerStatusFailed")
                case 1:
                    print("AVPlayerStatusReadyToPlay")
                    //获取全部时间
                    //CMTime value表示帧数，TimeScale是帧率。value/TimeScale就是时间
                    let duration = self.playItem.duration
                    //当前视频的最大帧数
                    let value = duration.value
                    //当前视频的帧率
                    let timescale = duration.timescale
                    //最大时间作为进度条的最大值
                    self.progressView.maximumValue = Float(value)/Float(timescale)
                    //把最大时间转换成字符形式在UI显示
                    self.maxTime = "\(transToHourMinSec(time: Float(CMTimeGetSeconds(duration).rounded())))"
                    //开始监听播放进度
                    monitoringProgress(timescale: timescale)
                default:
                    print("AVPlayerStatusUnknown")
                }
            }
            
        }
    }
    
    //屏幕将要旋转监控
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let width = videoView.bounds.height
        let height = videoView.bounds.width
        UIView.animate(withDuration: 0.4) {
            self.playerLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
    
    /******************** 屏幕手势监测 **********************/
    //开始触摸
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = true
        showControll()
        avPlayerPause()
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            startPoint = t.location(in: self.view)
        }
    }
 
    //手指移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        avPlayerPause()
        isTouching = true
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            let point = t.location(in: self.view)
            startPoint = lastPoint
            lastPoint = point
            let operating = getOperating()
            let value = operating.1
            switch operating.0 {
            case .brightness:
                break
            case .volume:
                break
            case .progress:
                isSliding = true
                let newValue = self.progressView.maximumValue * value
                self.progressView.value = self.progressView.value + newValue
                print("newValue = \(newValue)")
                playerSliderValueChanged(sender: self.progressView)
            case .unknown:
                break
            }
        }
    }
    //手指离开屏幕
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = CGPoint.zero
        lastPoint = CGPoint.zero
        isTouching = false
        isSliding = false
        hiddenControll()
        avPlayerPlay()
    }
    
    enum Operating {
        case volume
        case brightness
        case progress
        case unknown
    }
    
    //该手势类别，不必要的手势就抛弃
    func getOperating() -> (Operating,Float) {
        var operating = Operating.unknown
        var value:Float = 0
//        if startPoint.x <= videoView.bounds.width/2 {
//            operating = Operating.brightness
//        } else {
//            operating = Operating.volume
//        }
//        value = (lastPoint.y - startPoint.y) / videoView.bounds.height * 1.5
        if startPoint.y > videoView.bounds.height * 0.3 && startPoint.y < videoView.bounds.height * 0.7 {
            operating = Operating.progress
            value = Float((lastPoint.x - startPoint.x) / videoView.bounds.width)
        }
        
        print("operating = \(operating),value = \(value)")
        return (operating,value)
        
    }
    
    //检测有没有产生循环引用
    deinit {
        avPlayer = AVPlayer()
        print("== PlayerViewController 释放 ==")
    }
    
    /************************UI相关方法***********************************/
    //设置UI
    private func setUI(){
//        self.frame = rect
        videoView.frame = self.view.bounds
//        self.addSubview(videoView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.backgroundColor = UIColor.black
        self.view.addSubview(videoView)
        let videoViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[View]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":videoView])
        let videoViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[View]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":videoView])
        self.view.addConstraints(videoViewH)
        self.view.addConstraints(videoViewV)
 
        //自定义导航栏
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.backgroundColor = UIColor.init(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0.25)
        self.view.addSubview(navigationView)
        let navigationViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[View]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":navigationView])
        let navigationViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[View(80)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":navigationView])
        self.view.addConstraints(navigationViewH)
        self.view.addConstraints(navigationViewV)
        
        //left
        //返回按钮
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addSubview(backButton)
        let backButtonH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[View(30)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":backButton])
        let backButtonV = NSLayoutConstraint.constraints(withVisualFormat: "V:[View(30)]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":backButton])
        navigationView.addConstraints(backButtonH)
        navigationView.addConstraints(backButtonV)
        backButton.setImage(UIImage(named: "chevron-left"), for: UIControl.State.normal)
        backButton.addTarget(self, action: #selector(self.backBtnClick), for: UIControl.Event.touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addSubview(titleLabel)
        let titleLabelH = NSLayoutConstraint.constraints(withVisualFormat: "H:[Left]-20-[View(200)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":titleLabel,"Left":backButton])
        let titleLabelV = NSLayoutConstraint.constraints(withVisualFormat: "V:[View(30)]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":titleLabel])
        navigationView.addConstraints(titleLabelH)
        navigationView.addConstraints(titleLabelV)
        titleLabel.text = videoName
        
        //right
        let cropButton = UIButton()
        cropButton.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addSubview(cropButton)
        let cropButtonH = NSLayoutConstraint.constraints(withVisualFormat: "H:[View(100)]-25-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":cropButton])
        let cropButtonV = NSLayoutConstraint.constraints(withVisualFormat: "V:[View(30)]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":cropButton])
        navigationView.addConstraints(cropButtonH)
        navigationView.addConstraints(cropButtonV)
        cropButton.setTitle("切换为填充", for: UIControl.State.normal)
        cropButton.setTitle("切换为等比", for: UIControl.State.selected)
        cropButton.addTarget(self, action: #selector(self.cropBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        
        //底部控制栏
        controllView.translatesAutoresizingMaskIntoConstraints = false
        controllView.backgroundColor = UIColor.init(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0.25)
        self.view.addSubview(controllView)
        let controllViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[View]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":controllView])
        let controllViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:[View(100)]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":controllView])
        self.view.addConstraints(controllViewH)
        self.view.addConstraints(controllViewV)
        
        let controllStack = UIStackView()
        controllStack.translatesAutoresizingMaskIntoConstraints = false
        controllView.addSubview(controllStack)
        let controllStackH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[View]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":controllStack])
        let controllStackV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[View]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":controllStack])
        controllView.addConstraints(controllStackH)
        controllView.addConstraints(controllStackV)
        
        controllStack.axis = .vertical
        controllStack.alignment = .fill
        controllStack.distribution = .fill
 
        //进度条
        progressView.value = 0.0
        progressView.tintColor = UIColor.red
        progressView.addTarget(self, action: #selector(self.playerSliderValueChanged(sender:)), for: UIControl.Event.valueChanged)
        progressView.addTarget(self, action: #selector(self.playerSliderTouchDown(sender:)), for: UIControl.Event.touchDown)
        progressView.addTarget(self, action: #selector(self.playerSliderTouchUpInside(sender:)), for: UIControl.Event.touchUpInside)
        
        controllStack.addArrangedSubview(progressView)
        
        //进度条下方的按钮等
        let ctrBtnView = UIView()
        ctrBtnView.backgroundColor = UIColor.clear
        ctrBtnView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        controllStack.addArrangedSubview(ctrBtnView)
        //left
        //播放暂停按钮
        playButton.translatesAutoresizingMaskIntoConstraints = false
        ctrBtnView.addSubview(playButton)
        let playButtonH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[View(30)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":playButton])
        let playButtonV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[View]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":playButton])
        ctrBtnView.addConstraints(playButtonH)
        ctrBtnView.addConstraints(playButtonV)
        playButton.setImage(UIImage(named: "Play"), for: UIControl.State.normal)
        playButton.setImage(UIImage(named: "Pause"), for: UIControl.State.selected)
        playButton.addTarget(self, action: #selector(self.playOrPauseBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        //下个视频按钮 预留功能支持接收URL数组实现动态切换播放源
        if videoQueue.count > 1 {
            let nextButton = UIButton()
            nextButton.translatesAutoresizingMaskIntoConstraints = false
            ctrBtnView.addSubview(nextButton)
            let nextButtonH = NSLayoutConstraint.constraints(withVisualFormat: "H:[Left]-20-[View(30)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":nextButton,"Left":playButton])
            let nextButtonV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[View]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":nextButton])
            ctrBtnView.addConstraints(nextButtonH)
            ctrBtnView.addConstraints(nextButtonV)
            nextButton.setImage(UIImage(named: "forward"), for: UIControl.State.normal)
            nextButton.addTarget(self, action: #selector(self.nextBtnClick), for: UIControl.Event.touchUpInside)
        }
        
        //right
        //视频播放时间
        timeLabel.text = "--:--:--/--:--:--"
        timeLabel.font = UIFont(name: timeLabel.font.fontName, size: 14)
        timeLabel.textAlignment = .right
        timeLabel.textColor = UIColor.white
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        ctrBtnView.addSubview(timeLabel)
        let timeLabelH = NSLayoutConstraint.constraints(withVisualFormat: "H:[View(105)]-25-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":timeLabel])
        let timeLabelV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[View]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":timeLabel])
        ctrBtnView.addConstraints(timeLabelH)
        ctrBtnView.addConstraints(timeLabelV)
        //全屏切换按钮
        let fullScreenBtn = UIButton()
        fullScreenBtn.translatesAutoresizingMaskIntoConstraints = false
        ctrBtnView.addSubview(fullScreenBtn)
        let fullScreenBtnH = NSLayoutConstraint.constraints(withVisualFormat: "H:[View(30)]-20-[Right]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":fullScreenBtn,"Right":timeLabel])
        let fullScreenBtnV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[View]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["View":fullScreenBtn])
        ctrBtnView.addConstraints(fullScreenBtnH)
        ctrBtnView.addConstraints(fullScreenBtnV)
        fullScreenBtn.setImage(UIImage(named: "quxiaoquanping"), for: UIControl.State.normal)
        fullScreenBtn.addTarget(self, action: #selector(self.fullScreenBtnClick), for: UIControl.Event.touchUpInside)
        
        //底部做机型适配用的小部件
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.clear
        bottomView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        controllStack.addArrangedSubview(bottomView)
        
        //默认隐藏导航栏和控制栏
        self.navigationView.alpha = 0
        self.controllView.alpha = 0
        
        //设置视屏frame
        playerLayer.frame = videoView.frame
    }
    
    //显示控制栏
    private func showControll(){
        UIView.animate(withDuration: 0.3) {
            self.controllView.alpha = 1
            self.navigationView.alpha = 1
        }
    }
    
    //隐藏控制栏
    private func hiddenControll(){
        weak var WeakSelf = self
        if self.isTouching == true { return }
        //延时四秒 隐藏控制器
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            UIView.animate(withDuration: 0.4, animations: {
                guard let weakSelf = WeakSelf else { return }
                if weakSelf.isTouching == true { return }
                weakSelf.controllView.alpha = 0
                weakSelf.navigationView.alpha = 0
            }) { (finshed) in
                if finshed == true {
 
                }
            }
        }
    }
    
    /******************主要控件的触摸事件*******************/
    //进度条被触摸
    @objc private func playerSliderTouchDown(sender:UISlider) {
        print("正在拖动进度条")
        isSliding = true
    }
    //拖动进度条
    @objc private func playerSliderValueChanged(sender:UISlider) {
        isSliding = true
        self.avPlayerPause()
        // 跳转到拖拽秒处
        let changedTime = CMTimeMakeWithSeconds(Float64(sender.value), preferredTimescale: Int32(1.0))
        print("changedTime.timescale2 =\(changedTime.timescale)")
        avPlayer.seek(to: changedTime, toleranceBefore: CMTimeMakeWithSeconds(1, preferredTimescale: 1000), toleranceAfter: CMTimeMakeWithSeconds(1, preferredTimescale: 1000)) { (finished) in
            //跳转完成之后
            if finished == true {
                self.avPlayerPlay()
            }
        }
    }
    //手指松开进度条
    @objc private func playerSliderTouchUpInside(sender:UISlider) {
        print("松开进度条")
        isSliding = false
        print("self.progressView.value = \(self.progressView.value)")
    }
    
    //返回
    @objc private func backBtnClick(){
        self.navigationController?.popViewController(animated: true)
    }
 
    //控制视频的填充方式
    @objc private func cropBtnClick(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            self.playerLayer.videoGravity = .resizeAspectFill
        } else {
            self.playerLayer.videoGravity = .resizeAspect
        }
    }
    
    //播放/暂停按钮事件
    @objc private func playOrPauseBtnClick(sender:UIButton) {
        print("按钮被点击了")
        if playButton.isSelected == true {
            avPlayerPause()
        } else {
            avPlayerPlay()
        }
    }
    
    //下一个视屏按钮事件
    @objc private func nextBtnClick(){
        currentIndex = currentIndex + 1
        if currentIndex >= videoQueue.count {
            currentIndex = 0
        }
        switchPlayBackSource(url: videoQueue[currentIndex])
    }
    
    //全屏按钮事件（目前担任返回）
    @objc private func fullScreenBtnClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*************** 基础方法 ********************** */
    //切换播放源
    private func switchPlayBackSource(url:URL) {
        playItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: playItem)
        // 观察status属性，
        playItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        if videoView.layer.sublayers != nil && videoView.layer.sublayers!.count > 0 {
            videoView.layer.sublayers!.removeAll()
        }
        videoView.layer.addSublayer(playerLayer)
        avPlayerPlay()
    }
 
    //播放
    public func avPlayerPlay() {
        avPlayer.play()
        playButton.isSelected = true
    }
    
    //暂停
    public func avPlayerPause() {
        avPlayer.pause()
        playButton.isSelected = false
    }
 
    //监听进度
    private func monitoringProgress(timescale:CMTimeScale) {
        weak var WeakSelf = self
        playTimeObserver = self.avPlayer.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: timescale/1000), queue: DispatchQueue.global()) { (time) in
            DispatchQueue.main.async {
                guard let weakSelf = WeakSelf else { return }
                let currentime:Float = Float(time.value)/Float(time.timescale)
                let timeStr = weakSelf.transToHourMinSec(time: currentime)
                weakSelf.timeLabel.text = timeStr + "/" + weakSelf.maxTime
                if weakSelf.isSliding == false {
                    weakSelf.progressView.value = Float(time.value)/Float(time.timescale)
                }
            }
        }
    }
    
    //把时间转换为00:00:00的格式
    private func transToHourMinSec(time: Float) -> String {
        let allTime: Int = Int(time)
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = allTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
 
        return "\(hoursText):\(minutesText):\(secondsText)"
    }
}
