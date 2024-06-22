//
//  Extensions.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 21/06/24.
//

import Foundation
import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        
        gradientLayer.locations = [0.6, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func shadowUIView(offset:CGSize, opacity:Float, radius:CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func dismissLeftRight(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = .none
        transition.type = .reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.window!.layer.add(transition, forKey: nil)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
        }
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func toFormattedDate(format: String) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format

        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        } else {
            return nil
        }
    }
}

extension String? {
    var isNilOrEmpty:Bool{
        return self==nil || self==""
    }
}

extension UIViewController{
    func showToast(message : String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 15
        toastLabel.clipsToBounds = true
        
        let maxSize = CGSize(width: self.view.frame.width / 2, height: CGFloat.greatestFiniteMagnitude)
        let textSize = toastLabel.sizeThatFits(maxSize)
        
        let width = self.view.frame.width / 2
        let height = textSize.height + 20
        let x = self.view.frame.width / 4
        let y = self.view.frame.size.height - 150
        
        toastLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.5, delay: 2.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showLoading(_ active:Bool){
        self.view.isUserInteractionEnabled = !active
        self.view.layer.opacity = active ? 0.5 : 1
        if active {
            // Start loading
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = CGPoint(x:  self.view.bounds.midX, y:  self.view.bounds.midY)
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            activityIndicator.tag = 1000 // Assign a tag to easily find and remove later
            self.view.addSubview(activityIndicator)
        } else {
            // Finish loading
            if let activityIndicator =  self.view.viewWithTag(1000) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}

extension UIButton{
    func setFont(size: CGFloat, weight: UIFont.Weight){
        self.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer{ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: size, weight: weight)
            return outgoing
        }
    }
}
