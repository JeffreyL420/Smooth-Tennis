//
//  CameraViewController.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import AVFoundation
import UIKit
import MobileCoreServices

/// Controller to handle taking pictures or choosing from Library
final class CameraViewController: UIViewController {

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

    private let photoPickerButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)),
                        for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Camera"
        previewLayer.backgroundColor = UIColor.systemRed.cgColor
        view.addSubview(cameraView)
        view.addSubview(shutterButton)
        view.addSubview(photoPickerButton)
        setUpNavBar()
        checkCameraPermission()
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        photoPickerButton.addTarget(self, action: #selector(didTapPickPhoto), for: .touchUpInside)

    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        if let session = captureSession, !session.isRunning {
            session.startRunning()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
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
            width: buttonSize,
            height: buttonSize
        )
        shutterButton.layer.cornerRadius = buttonSize/2

        photoPickerButton.frame = CGRect(x: (shutterButton.left - (buttonSize/1.5))/2,
                                         y: shutterButton.top + ((buttonSize/1.5)/2),
                                         width: buttonSize/1.5,
                                         height: buttonSize/1.5)
    }

    @objc func didTapPickPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        //picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPresetHEVC1920x1080
        picker.videoMaximumDuration = 300 //duration in seconds
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(),
                            delegate: self)
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .authorized:
            setUpCamera()
        case .restricted, .denied:
            break
        @unknown default:
            break
        }
    }

    private func setUpCamera() {
        let captureSession = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
                if captureSession.canAddOutput(output) {
                    captureSession.addOutput(output)
                }
                
                previewLayer.session = captureSession
                previewLayer.videoGravity = .resizeAspectFill
                
                captureSession.startRunning()
                self.captureSession = captureSession
            }
            catch {
                
            }

            

            // Layer
//            previewLayer.session = captureSession
//            previewLayer.videoGravity = .resizeAspectFill
//            cameraView.layer.addSublayer(previewLayer)
//
//            captureSession.startRunning()
        }
    }

    @objc func didTapClose() {
        tabBarController?.selectedIndex = 0
        tabBarController?.tabBar.isHidden = false
    }

    private func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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

//extension CameraViewController: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let data = photo.fileDataRepresentation(),
//              let image = UIImage(data: data) else {
//            return
//        }
//        captureSession?.stopRunning()
//        showEditPhoto(image: image)
//    }
//
//    private func showEditPhoto(image: UIImage) {
//        guard let resizedImage = image.sd_resizedImage(
//            with: CGSize(width: 640, height: 640),
//            scaleMode: .aspectFill
//        ) else {
//            return
//        }
//
//        let vc = PostEditViewController(image: resizedImage)
//        if #available(iOS 14.0, *) {
//            vc.navigationItem.backButtonDisplayMode = .minimal
//        }
//        navigationController?.pushViewController(vc, animated: false)
//
//    }
//}
