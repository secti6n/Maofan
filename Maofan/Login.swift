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
        let oauthSwift = OAuth1Swift(consumerKey: FanfouConsumer.key, consumerSecret: FanfouConsumer.secret, requestTokenUrl: "", authorizeUrl: "", accessTokenUrl: "")
        
        oauthSwift.xauthorizeWithUsername(accessTokenUrl: FanfouConsumer.url, username: username, password: password, success: {  (credential, response, parameters) in
            Service.reloadSharedInstance()
            Service.sharedInstance.client = oauthSwift.client
            Service.sharedInstance.verify_credentials(parameters: [:], success: { (response) in
                CoreDataTool.sharedInstance.save(jsonData: response.data as NSData, token: credential.oauthToken, secret: credential.oauthTokenSecret)
                print("account saved, token: \(credential.oauthToken) secret: \(credential.oauthTokenSecret)")
            }, failure: { (error) in
                Misc.handleError(error)
            })
        }, failure:{ (error) in
            Misc.handleError(error)
        })
    }
    
}

extension OAuth1Swift {
    
    public func xauthorizeWithUsername(accessTokenUrl: String, username: String, password:String, success: @escaping TokenSuccessHandler, failure: FailureHandler?) {
        var parameters = Dictionary<String, Any>()
        parameters["x_auth_username"] = username
        parameters["x_auth_password"] = password
        parameters["x_auth_mode"] = "client_auth"
        let _ = self.client.post(
            accessTokenUrl, parameters: parameters,
            success: { [weak self] response in
                guard let this = self else { return }
                let parameters = response.string?.parametersFromQueryString ?? [:]
                if let oauthToken = parameters["oauth_token"], let oauthTokenSecret = parameters["oauth_token_secret"] {
                    this.client.credential.oauthToken = oauthToken
                    this.client.credential.oauthTokenSecret = oauthTokenSecret
                }
                success(this.client.credential, response, parameters)
            }, failure: failure
        )
    }
    
}

extension String {
    
    var parametersFromQueryString: [String: String] {
        let elementSeparator = "&"
        let keyValueSeparator = "="
        var string = self
        if(hasPrefix(elementSeparator)) {
            string = String(characters.dropFirst(1))
        }
        
        var parameters = Dictionary<String, String>()
        
        let scanner = Scanner(string: string)
        
        var key: NSString?
        var value: NSString?
        
        while !scanner.isAtEnd {
            key = nil
            scanner.scanUpTo(keyValueSeparator, into: &key)
            scanner.scanString(keyValueSeparator, into: nil)
            
            value = nil
            scanner.scanUpTo(elementSeparator, into: &value)
            scanner.scanString(elementSeparator, into: nil)
            
            if let key = key as? String, let value = value as? String {
                parameters.updateValue(value, forKey: key)
            }
        }
        
        return parameters
    }
    
}
