//
//  Comment.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/25/21.
//

import Foundation

struct Comment: Codable {
    let username: String
    let comment: String
    let dateString: String
    let usernameProfilePhoto: URL
    let topResponse: Bool
    
    var date: Date {
        guard let date = DateFormatter.formatter.date(from: dateString) else { fatalError() }
        return date
    }

    var storageReference: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil }
        return "\(username)/ratings/\(dateString).png"
    }
}

struct Comment2: Codable {
    let username: String
    let comment: String
    let dateString: String
    let usernameProfilePhoto: URL
    let topResponse: Bool
    let amountTopComments: Int
    let dateCheckTrack: String
    
    var date: Date {
        guard let date = DateFormatter.formatter.date(from: dateString) else { fatalError() }
        return date
    }

    var storageReference: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil }
        return "\(username)/ratings/\(dateString).png"
    }
}
