//
//  Post.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import Foundation

struct Post: Codable {
    let id: String
    let caption: String
    let postedDate: String
    let postImageUrlString: String
    //adding a new video Url String:
    let postVideoUrlString: String?
    var likers: [String]
    var dateCheck: String
    //adding a new tag element to be used to group and seperate posts
    var tag: String
    var openStatus: Bool
    var dateCheckTrack: String

    var date: Date {
        let date = postedDate.toDateTime()
//        guard let date = DateFormatter.formatter.date(from: postedDate) else { fatalError() }
        return date
    }

    var storageReference: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil }
        return "\(username)/posts/\(id).png"
    }
}
