//
//  Misc.swift
//  Maofan
//
//  Created by Catt Liu on 2016/11/12.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import OAuthSwift
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
    
}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
