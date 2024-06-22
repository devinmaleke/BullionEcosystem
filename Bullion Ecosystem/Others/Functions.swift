//
//  Functions.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation
import UIKit
import CryptoKit

class Functions: UIViewController{
    static func hash(data: Data) -> String {
        let digest = SHA256.hash(data: data)
        let hashString = digest
            .compactMap { String(format: "%02x", $0) }
            .joined()
        return hashString
    }
    
    static func getISOString(from date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
    
    static func securedField(textField: UITextField, sender: UIButton){
        textField.isSecureTextEntry.toggle()
        if textField.isSecureTextEntry == true{
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    static func convertImageToUTF64(img: UIImage) -> String{
        return img.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
    }
    
   
    static func convertUTF64ToImage(stringIMG: String) -> UIImage{
        let imageData = Data(base64Encoded: stringIMG)
        let image = UIImage(data: imageData!)
        return image ?? UIImage(named: "EmptyImage")!
    }
    
    static func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    static func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter.date(from: dateString)
    }

}
