//
//  Misc.swift
//  Maofan
//
//  Created by Catt Liu on 2016/11/12.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import OAuthSwift
import YYWebImage
import AudioToolbox

class Sound {
    
    static var soundPaths: [String] = [
        "bubble_1",
        "bubble_2",
        ]
    
    static var soundIDs: [SystemSoundID] = []
    
    static func configSound() {
        soundIDs = []
        var soundID: SystemSoundID = 0
        for path in soundPaths {
            let fileURL = Bundle.main.url(forResource: path, withExtension: "wav")
            AudioServicesCreateSystemSoundID(fileURL as! CFURL, &soundID)
            soundIDs.append(soundID)
        }
    }
    
    static func playsound() {
        AudioServicesPlaySystemSound(soundIDs.randomItem())
    }
}

class Misc {
    
    static func handleError(_ error: OAuthSwiftError) {
        let error = error.underlyingError as! NSError
        print(error)
    }
    
    static func handleError(_ error: NSError) {
        print(error)
    }
    
    static func handleError(_ error: Error) {
        print(error)
    }
    
    static var timeMark = Date() {
        didSet {
            print(timeMark.timeIntervalSince1970 - oldValue.timeIntervalSince1970)
        }
    }
    
    static func markTime() {
        timeMark = Date()
    }

}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) == 6) {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: 1.0)
        } else {
            self.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        }
    }
    
    func alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
}

extension Array {
    
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
}

extension UIView {
    
    @discardableResult
    func findSubView(_ handle: (UIView) -> Bool) -> UIView? {
        for view in subviews {
            if handle(view) {
                return view
            } else if let view = view.findSubView(handle) {
                return view
            }
        }
        return nil
    }
    
    func blurBarStylize(_ color: UIColor? = nil) {
        findSubView({ (view) -> Bool in
            if view is UIImageView {
                view.isHidden = true
                return true
            }
            return false
        })
        guard let _UIVisualEffectFilterView = NSClassFromString("_UIVisualEffectFilterView") else { return }
        findSubView({ (view) -> Bool in
            if view.isKind(of: _UIVisualEffectFilterView) {
                view.backgroundColor = (color ?? Style.backgroundColor).alpha(0.75)
                return true
            }
            return false
        })
    }
    
}

extension UIImage {
    
    func imageWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        color.setFill()
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

extension YYWebImageManager {
    
    func preDownload(url: URL?) {
        if let url = url {
            YYWebImageManager.shared().requestImage(with: url, options: [.ignoreImageDecoding],progress: nil, transform: nil)
        }
    }
    
}
