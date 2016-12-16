//
//  Login.swift
//  Maofan
//
//  Created by Catt Liu on 2016/11/15.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import OAuthSwift

class Login {
    
    class func xauth(username: String, password: String) {
        let oauthSwift = OAuth1Swift(mf_consumerKey: FanfouConsumer.key, mf_consumerSecret: FanfouConsumer.secret)
        oauthSwift.mf_xauthorizeWithUsername(username: username, password: password, success: {  (credential, response, parameters) in
            Service.reloadSharedInstance()
            Service.sharedInstance.client = oauthSwift.client
            }, failure:{ (error) in
                Misc.handleError(error)
        })
    }
    
}
