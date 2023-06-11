//
//  Extensions.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/21/21.
//

import Foundation
import UIKit

extension UIView {
    var top: CGFloat {
        frame.origin.y
    }

    var bottom: CGFloat {
        frame.origin.y+height
    }

    var left: CGFloat {
        frame.origin.x
    }

    var right: CGFloat {
        frame.origin.x+width
    }

    var width: CGFloat {
        frame.size.width
    }

    var height: CGFloat {
        frame.size.height
    }
}

extension Decodable {
    /// Create model with dictionary
    /// - Parameter dictionary: Firestore data
    init?(with dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: .prettyPrinted
        ) else {
            return nil
        }
        guard let result = try? JSONDecoder().decode(
            Self.self,
            from: data
        ) else {
            return nil
        }
        self = result
    }
}

extension Encodable {
    /// Convert model to dictionary
    /// - Returns: Optional dictionary representation
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        let json = try? JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        ) as? [String: Any]
        return json
    }
}

extension DateFormatter {
    /// Static date formatter
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateFormat = "MMM dd, yyyy 'at' h:mm a"
        return formatter
    }()
}

extension String {
    /// Convert string from Date
    /// - Parameter date: Source date
    /// - Returns: String representation
    static func date(from date: Date) -> String? {
        let formatter = DateFormatter.formatter
        let string = formatter.string(from: date)
        return string
    }
}

extension Notification.Name {
    /// Notification to inform of new post
    static let didPostNotification = Notification.Name("didPostNotification")
}


extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIView {
    class func getAllSubviews<T: UIView>(from parentView: UIView) -> [T] {
     
        return parentView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }
     class func getAllSubviews(from parentView: UIView, types: [UIView.Type]) -> [UIView] {
          
         return parentView.subviews.flatMap { subView -> [UIView] in
             var result = getAllSubviews(from: subView) as [UIView]
             for type in types {
                 if subView.classForCoder == type {
                     result.append(subView)
                     return result
                 }
             }
             return result
         }
     }
     func getAllSubviews<T: UIView>() -> [T] {
          return UIView.getAllSubviews(from: self) as [T]
     }
     
     func get<T: UIView>(all type: T.Type) -> [T] {
          return UIView.getAllSubviews(from: self) as [T]
     }
     
     func get(all type: UIView.Type) -> [UIView] {
          return UIView.getAllSubviews(from: self)
     }
}

extension String {

func toDateTime() -> Date {
//    var dateFormatter = DateFormatter()
//    dateFormatter.calendar = Calendar(identifier: .iso8601)
//    dateFormatter.timeZone = .current
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//    guard let date = dateFormatter.date(from: self) else {
//        fatalError()
//    }
//    return date
    
    guard let date = DateFormatter.formatter.date(from: self) else {
        fatalError()
    }
    
    

    return date
    }
    

}
