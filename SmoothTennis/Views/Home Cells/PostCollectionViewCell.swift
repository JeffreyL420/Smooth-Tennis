//
//  PostCollectionViewCell.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/21/21.
//

import SDWebImage
import UIKit
import AVFoundation

protocol PostCollectionViewCellDelegate: AnyObject {
    func postCollectionViewCellDidLike(_ cell: PostCollectionViewCell, index: Int)
}

class PostCollectionViewCell: UICollectionViewCell {
    static let identifer = "PostCollectionViewCell"
    
    var url: URL!
    
    var isPlaying = false
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()

    let activityIndicatorViewFix: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.isHidden = false
        return aiv
    }()
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        
        return button
    }()
    
    weak var delegate: PostCollectionViewCellDelegate?

    private var index = 0

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let heartImageView: UIImageView = {
        let image = UIImage(systemName: "suit.heart.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.isHidden = true
        imageView.alpha = 0
        return imageView
    }()

    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        //label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .systemGreen
        slider.maximumTrackTintColor = .systemYellow
        var ball = UIImage(named: "ball")
        ball = ball?.resized(to: CGSize(width: 35, height: 35))
        slider.setThumbImage(ball, for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
        //contentView.addSubview(imageView)
        //contentView.addSubview(heartImageView)
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapToLike))
        //tap.numberOfTapsRequired = 2
        //imageView.isUserInteractionEnabled = true
        //imageView.addGestureRecognizer(tap)
        //imageView.addSubview(controlsContainerView)
        //controlsContainerView.frame = bounds
        //setting x,y,w,h
        //controlsContainerView.addSubview(imageView)
        
        contentView.addSubview(imageView)
        imageView.frame = bounds
//        imageView.addSubview(activityIndicatorViewFix)
//        activityIndicatorViewFix.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        activityIndicatorViewFix.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        activityIndicatorViewFix.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        activityIndicatorViewFix.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //contentView.addSubview(controlsContainerView)
        
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    func setupPlayerView() {
        if url.absoluteString != "nil" {
            imageView.addSubview(activityIndicatorViewFix)
            activityIndicatorViewFix.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorViewFix.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            activityIndicatorViewFix.widthAnchor.constraint(equalToConstant: 50).isActive = true
            activityIndicatorViewFix.heightAnchor.constraint(equalToConstant: 50).isActive = true
            activityIndicatorViewFix.startAnimating()
            //imageView.isHidden = true
            //controlsContainerView.frame = bounds
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = imageView.bounds
            
            imageView.layer.addSublayer(playerLayer!)
            imageView.image = UIImage(named: "Black")
//            player?.pause()
            //activityIndicatorView.startAnimating()
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            //playPauseButton.isHidden = true
            
        
            //track player progress
            trackProgress()
            
        }
        else {
            controlsContainerView.isHidden = true
        }
    }
    
    func trackProgress() {
        let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsText = String(format: "%02d", Int(seconds) % 60)
            let minutesText = String(format: "%02d", Int(seconds)/60)
            
            self.currentTimeLabel.text = "\(minutesText):\(secondsText)"
            
            //lets move the slider thumb
            if let duration = self.player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                
                self.videoSlider.value = Float(seconds / durationSeconds)
                
            }
            if self.videoSlider.value == 1.0 {
                self.isPlaying = false
                self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            }
            
        })
    }
    
    @objc func handleSliderChange() {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //perhaps do something later here
            })
        }
        
        
    }

    @objc func handlePlay() {
        if isPlaying {
            player?.pause()
            playPauseButton.isHidden = false
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            isPlaying = !isPlaying
        } else {
            if self.videoSlider.value == 1.0 {
                self.videoSlider.value = Float(0)
                handleSliderChange()
                trackProgress()
            }
            player?.play()
            playPauseButton.isHidden = false
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            isPlaying = !isPlaying
        }
        
        

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorViewFix.stopAnimating()
            
            //controlsContainerView.frame = bounds
            imageView.addSubview(playPauseButton)
            playPauseButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: -self.width/2.4).isActive = true
            playPauseButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: self.height/3).isActive = true
            playPauseButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            playPauseButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
            imageView.addSubview(videoLengthLabel)
            videoLengthLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
            videoLengthLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
            videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            imageView.addSubview(currentTimeLabel)
            currentTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant:  8).isActive = true
            currentTimeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
            currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            imageView.addSubview(videoSlider)
            videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: -8).isActive = true
            videoSlider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
            videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
            videoSlider.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            
            setupGradientLayer()
            
            imageView.backgroundColor = .clear
            playPauseButton.isHidden = false
            //isPlaying = false
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                let minutesText = String(format: "%02d", Int(seconds)/60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.9, 1.2]
        
        imageView.layer.addSublayer(gradientLayer)
    }
 
    @objc func didDoubleTapToLike() {
        heartImageView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.heartImageView.alpha = 1
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.4) {
                    self.heartImageView.alpha = 0
                } completion: { done in
                    if done {
                        self.heartImageView.isHidden = true
                    }
                }
            }
        }

        delegate?.postCollectionViewCellDidLike(self, index: index)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        let size: CGFloat = contentView.width/5
        heartImageView.frame = CGRect(
            x: (contentView.width-size)/2,
            y: (contentView.height-size)/2,
            width: size,
            height: size)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        videoSlider.removeFromSuperview()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        playPauseButton.imageView?.image = nil
        playPauseButton.removeFromSuperview()
        currentTimeLabel.text = nil
        videoLengthLabel.text = nil
        //activityIndicatorView.stopAnimating()
    }

    func configure(with viewModel: PostCollectionViewCellViewModel, index: Int) {
        self.index = index
        //activityIndicatorView.startAnimating()
        url = viewModel.postVideoURL
        imageView.sd_setImage(with: viewModel.postImageUrl, completed: nil)
        setupPlayerView()
        
    }
}
