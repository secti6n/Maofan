//
//  User.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/31.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import SwiftyJSON

class User {
    
    let json: JSON
    
    init(_ json: JSON) {
        self.json = json
    }
    
    var id: String {
        return json["id"].stringValue
    }
    
    var unique_id: String {
        return json["unique_id"].stringValue
    }
    
    var name: String {
        return json["name"].stringValue
    }
    
    var avatar: URL? {
        return json["profile_image_url_large"].URL
    }
    
}
