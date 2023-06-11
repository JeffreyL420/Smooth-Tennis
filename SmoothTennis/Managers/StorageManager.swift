//
//  StorageManager.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import Foundation
import FirebaseStorage

/// Object to interface with firebase storage
final class StorageManager {
    static let shared = StorageManager()

    private init() {}

    private let storage = Storage.storage().reference()

    /// Upload post image
    /// - Parameters:
    ///   - data: Image data
    ///   - id: New post id
    ///   - completion: Result callback
    public func uploadPost(
        imageData: Data?,
        id: String,
        completion: @escaping (URL?) -> Void
    ) {
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let data1 = imageData
        else {
            return
        }
        let ref = storage.child("\(username)/posts/\(id).png")
        ref.putData(data1, metadata: nil) { _, error in
            ref.downloadURL { url, _ in
                completion(url)
            }
        }
        
    }

    public func downloadURL(for post: Post, completion: @escaping (URL?) -> Void) {
        guard let ref = post.storageReference else {
            completion(nil)
            return
        }
        
        storage.child(ref).downloadURL { url, _ in
            completion(url)
        }
    }

    public func profilePictureURL(for username: String, completion: @escaping (URL?) -> Void) {
        storage.child("\(username)/profile_picture.png").downloadURL { url, _ in
            completion(url)
        }
    }
    
    public func certificatePictureURL(for username: String, completion: @escaping (URL?) -> Void) {
        storage.child("\(username)/certificate_picture.png").downloadURL { url, _ in
            completion(url)
        }
    }
    

    public func uploadProfilePicture(
        username: String,
        data: Data?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let data = data else {
            return
        }
        storage.child("\(username)/profile_picture.png").putData(data, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
    
    public func uploadCertificatePicture(
        username: String,
        data: Data?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let data = data else {
            return
        }
        storage.child("\(username)/certificate_picture.png").putData(data, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
    public func uploadVideo(
        id: String,
        data: URL,
        completion: @escaping (URL?) -> Void
    ) {
//        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
           do {
               let data = try Data(contentsOf: data)
               
               let storageRef =
           Storage.storage().reference().child("\(username)/posts/\(id).mov")
               if let uploadData = data as Data? {
                   let metaData = StorageMetadata()
                   metaData.contentType = "video/mov"
                   let uploadTask = storageRef.putData(uploadData, metadata: metaData
                                      , completion: { (metadata, error) in
                                       if let error = error {
                                           print(error.localizedDescription)
                                           return
                                       }else{
                                           storageRef.downloadURL { (url, error) in
                                               guard let downloadURL = url else {
                                                   //print(error?.localizedDescription)
                                                   return
                                               }
                                               //print("downloadURL + " + downloadURL.absoluteString)
                                               completion(downloadURL)
                                           }
                                       }
                                      })
                   uploadTask.observe(.progress) { (snapshot) in
                       if let completeUnitCount = snapshot.progress?.completedUnitCount {
                           //can assign the percentage of video loading to a label
                       }
                   }
                   uploadTask.observe(.success) { (snapshot) in
                       //can assign the normal title back to the thing
                   }
               }
           }catch let error {
               //print(error.localizedDescription)
           }
    }
    
    
}

