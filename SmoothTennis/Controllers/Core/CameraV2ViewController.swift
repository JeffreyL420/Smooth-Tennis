//
//  CameraV2ViewController.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/11/17.
//
import AVFoundation
import UIKit
import MobileCoreServices

final class CameraV2ViewController: UIViewController {

    var videoURL: NSURL?
    
    var image: UIImage?
    
    //to register videos
    private var output = AVCapturePhotoOutput()
    //Capture Session
    private var captureSession: AVCaptureSession?
    //Photo Output
    private var videoOutput = AVCaptureVideoDataOutput()
    private var photoOutput = AVCapturePhotoOutput()
    
    //Video Preview
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    private let cameraView = UIView()

    private let shutterButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.backgroundColor = nil
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cameraInstructions")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.label.cgColor
        return imageView
    }()

    private let photoPickerButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setTitle("Create Question Post", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let color = UIColor(hexString: "#1B9C85")
        button.backgroundColor = color
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
//        button.setImage(UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)),
//                        for: .normal)
        return button
    }()
    
    private let ruleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 4
        label.text = "You can only select ONE video/picture each post, pick the best! The video must be less than 180 seconds"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 4
        label.text = "Longer videos make take some time to compress."
        label.textAlignment = .center
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Post"
        previewLayer.backgroundColor = UIColor.systemRed.cgColor
        view.addSubview(cameraView)
        //view.addSubview(shutterButton)
        view.addSubview(photoPickerButton)
        view.addSubview(imageView)
        view.addSubview(ruleLabel)
        view.addSubview(warningLabel)
        //setUpNavBar()
        //checkCameraPermission()
        //shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        photoPickerButton.addTarget(self, action: #selector(didTapPickPhoto), for: .touchUpInside)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //tabBarController?.tabBar.isHidden = true
        let color = UIColor(hexString: "#1B9C85")
        photoPickerButton.backgroundColor = color
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        previewLayer.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )

        let buttonSize: CGFloat = view.width/5
        shutterButton.frame = CGRect(
            x: (view.width-buttonSize)/2,
            y: view.safeAreaInsets.top + view.width + 100,
            width: view.width,
            height: buttonSize
        )
//        shutterButton.layer.cornerRadius = buttonSize/2
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.height/1.7).isActive = true
        photoPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoPickerButton.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
        photoPickerButton.widthAnchor.constraint(equalToConstant: 4*view.width/5).isActive = true
        photoPickerButton.heightAnchor.constraint(equalToConstant: buttonSize/1.5).isActive = true
        
        let ruleLabelHeight = (estimateFrameForText(text: ruleLabel.text!)).height+15
        ruleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ruleLabel.centerYAnchor.constraint(equalTo: photoPickerButton.bottomAnchor, constant: 20).isActive = true
        ruleLabel.widthAnchor.constraint(equalToConstant: 5*view.width/6).isActive = true
        ruleLabel.heightAnchor.constraint(equalToConstant: ruleLabelHeight).isActive = true
        
        
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningLabel.centerYAnchor.constraint(equalTo: ruleLabel.bottomAnchor).isActive = true
        warningLabel.widthAnchor.constraint(equalToConstant: 5*view.width/6).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        photoPickerButton.frame = CGRect(x: ((view.width-buttonSize/1.5)/2),
//                                         y: (imageView.bottom + 40),
//                                         width: buttonSize*4,
//                                         height: buttonSize/1.5)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 5*view.width/6, height: 100000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], context: nil)
    }
    
    @objc func didTapPickPhoto() {
        let color = UIColor(hexString: "#C7F2A4")
        photoPickerButton.backgroundColor = color
        presentPhotoAlbum()
    }
    
    private func presentPhotoAlbum() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        //picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = [UTType.image.identifier as String, UTType.movie.identifier as String]
        picker.videoQuality = .typeMedium
        picker.videoExportPreset = AVAssetExportPresetHEVC1920x1080
        picker.videoMaximumDuration = 60 //duration in seconds
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
//
//    @objc func didTapClose() {
//        tabBarController?.selectedIndex = 0
//        tabBarController?.tabBar.isHidden = false
//    }
    
//    private func setUpNavBar() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            barButtonSystemItem: .close,
//            target: self,
//            action: #selector(didTapClose)
//        )
//    }

}

extension CameraV2ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let color = UIColor(hexString: "#1B9C85")
        photoPickerButton.backgroundColor = color
        picker.dismiss(animated: true, completion: nil)
    }

   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if info[UIImagePickerController.InfoKey.editedImage] as? UIImage != nil {
            //selected an image
            image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            let vc = CaptionViewController(image: image!, url: "nil")
            vc.title = "Add Caption"
            navigationController?.pushViewController(vc, animated: true)
            //AVMutableVideoCompositionInstruction
        }
        else {
            //selected a video
            //since I have the first image, the thought process is basically, upload to storage and render thath image as the view for now, but also have the videourl accessible, I think this works if I use the firebase create post with a videourl and if the url is nil it just doesn't do anything but if it isn't I do something
            videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
            image = previewImageFromVideo(url: videoURL!)!
            let vc = CaptionViewController(image: image!, url: (videoURL?.absoluteString)!)
            vc.title = "Add Caption"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func previewImageFromVideo(url: NSURL) -> UIImage? {
        let asset = AVAsset(url:url as URL)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
//        var time = asset.duration
//        time.value = min(time.value,2)
        
        
         
        do {
            let imageRef = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
    func createNewPostID() -> String? {
        let timeStamp = Date().timeIntervalSince1970
        let randomNumber = Int.random(in: 0...1000)
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return nil
        }
        
        return "\(username)_\(randomNumber)_\(timeStamp)"
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let data = photo.fileDataRepresentation(),
//              let image = UIImage(data: data) else {
//            return
//        }
//        //captureSession?.stopRunning()
//        showEditPhoto(image: image)
//    }

    private func showEditPhoto(image: UIImage) {
        guard let resizedImage = image.sd_resizedImage(
            with: CGSize(width: 640, height: 640),
            scaleMode: .aspectFill
        ) else {
            return
        }

        let vc = PostEditViewController(image: resizedImage)
        if #available(iOS 14.0, *) {
            vc.navigationItem.backButtonDisplayMode = .minimal
        }
        navigationController?.pushViewController(vc, animated: false)

    }
}

