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
        let client = OAuthSwiftClient(consumerKey: FanfouConsumer.key, consumerSecret: FanfouConsumer.secret)
        client.mf_xauthorizeWithUsername(username: username, password: password, success: {  (credential, response, parameters) in
            Service.reloadSharedInstance()
            Service.sharedInstance.client = client
            save(credential: credential)
        }, failure:{ (error) in
            Misc.handleError(error)
        })
    }
    
    class func save(credential: OAuthSwiftCredential) {
        Service.sharedInstance.verify_credentials(parameters: [:], success: { (response) in
            CoreDataTool.sharedInstance.save(jsonData: response.data as NSData, token: credential.oauthToken, secret: credential.oauthTokenSecret)
            print("account saved, token: \(credential.oauthToken) secret: \(credential.oauthTokenSecret)")
        }, failure: { (error) in
            Misc.handleError(error)
        })
        
    }
    
}
