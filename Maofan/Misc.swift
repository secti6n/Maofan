//
//  Misc.swift
//  Maofan
//
//  Created by Catt Liu on 2016/11/12.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import Foundation
import OAuthSwift

class Misc {
    
    class func handleError(_ error: OAuthSwiftError) {
        let error = error.underlyingError as! NSError
        print(error)
    }
    
    class func handleError(_ error: NSError) {
        print(error)
    }
    
    class func handleError(_ error: Error) {
        print(error)
    }

}
