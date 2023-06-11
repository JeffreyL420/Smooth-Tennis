//
//  CoachComment.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/11/8.
//

import Foundation

struct CoachComment: Codable {
    let username: String
    let comment: String
    let dateString: String
    let usernameProfilePhoto: URL
    let topResponse: Bool
    let thePostImage: String
    let thePostVideo: String
    let thePostID: String
    let thePostOwner: String
    //newly added to fit post
    var likers: [String]
    let caption: String
    let tag: String
    let dateCheck: String
    let openStatus: Bool
    let dateCheckTrack: String
    
    
    
    var date: Date {
        let date = dateString.toDateTime()
//        guard let date = DateFormatter.formatter.date(from: postedDate) else { fatalError() }
        return date
//        guard let date = DateFormatter.formatter.date(from: dateString) else { fatalError() }
//        return date
    }

    var storageReference: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil }
        return "\(username)/ratings/\(dateString).png"
    }
}

struct PlayerComment: Codable {
    let username: String
    let dateString: String
    let thePostImage: String
    let thePostVideo: String
    let thePostID: String
    let thePostOwner: String
    //newly added to fit post
    var likers: [String]
    let caption: String
    let tag: String
    let dateCheck: String
    let whoSelected: [String]
    let dateCheckTrack: String
    
    
    
    var date: Date {
        let date = dateString.toDateTime()
//        guard let date = DateFormatter.formatter.date(from: postedDate) else { fatalError() }
        return date
//        guard let date = DateFormatter.formatter.date(from: dateString) else { fatalError() }
//        return date
    }

    var storageReference: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil }
        return "\(username)/ratings/\(dateString).png"
    }
}
