//
//  OAuthExtension.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/16.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import OAuthSwift

extension OAuthSwiftClient {
    
    func mf_xauthorizeWithUsername(username: String, password:String, success: @escaping OAuthSwift.TokenSuccessHandler, failure: OAuthSwift.FailureHandler?) {
        var parameters = Dictionary<String, Any>()
        parameters["x_auth_username"] = username
        parameters["x_auth_password"] = password
        parameters["x_auth_mode"] = "client_auth"
        self.post(
            FanfouConsumer.access_token_url, parameters: parameters,
            success: { [weak self] response in
                guard let this = self else { return }
                let parameters = response.string?.parametersFromQueryString ?? [:]
                if let oauthToken = parameters["oauth_token"] {
                    this.credential.oauthToken = oauthToken
                }
                if let oauthTokenSecret = parameters["oauth_token_secret"] {
                    this.credential.oauthTokenSecret = oauthTokenSecret
                }
                success(this.credential, response, parameters)
            }, failure: failure
        )
    }
    
}

extension OAuthSwiftClient {
    
    func mf_postImage(name: String, urlString: String, parameters: OAuthSwift.Parameters, image: Data, success: OAuthSwiftHTTPRequest.SuccessHandler?, failure: OAuthSwiftHTTPRequest.FailureHandler?) {
        let multiparts = [ OAuthSwiftMultipartData(name: name, data: image, fileName: "file", mimeType: "image/jpeg") ]
        let boundary = "AS-boundary-\(arc4random())-\(arc4random())"
        let kHTTPHeaderContentType = "Content-Type"
        let type = "multipart/form-data; boundary=\(boundary)"
        let body = self.multiDataFromObject(parameters, multiparts: multiparts, boundary: boundary)
        let headers = [kHTTPHeaderContentType: type]
        request(urlString, method: .POST, headers: headers, body: body, success: success, failure: failure)
    }
    
    func multiDataFromObject(_ object: OAuthSwift.Parameters, multiparts: Array<OAuthSwiftMultipartData>, boundary: String) -> Data {
        let encoding: String.Encoding = .utf8
        var data = Data()
        let prefixString = "--\(boundary)\r\n"
        let prefixData = prefixString.data(using: encoding)!
        let separatorString = "\r\n"
        let separatorData = separatorString.data(using: encoding)!
        let endingString = "--\(boundary)--\r\n"
        let endingData = endingString.data(using: encoding)!
        
        for (key, value) in object {
            let valueData = "\(value)".data(using: encoding)!
            data.append(prefixData)
            let multipartData = OAuthSwiftMultipartData(name: key, data: valueData, fileName: nil, mimeType: nil)
            data.append(multipartData, encoding: encoding, separatorData: separatorData)
        }
        for multipart in multiparts {
            data.append(prefixData)
            data.append(multipart, encoding: encoding, separatorData: separatorData)
        }
        data.append(endingData)
        
        return data
    }
    
}

extension String {
    
    var parametersFromQueryString: [String: String] {
        return dictionaryBySplitting(elementSeparator: "&", keyValueSeparator: "=")
    }
    
    func dictionaryBySplitting(elementSeparator: String, keyValueSeparator: String) -> [String: String] {
        var parameters: [String: String] = [ : ]
        let scanner = Scanner(string: self)
        while !scanner.isAtEnd {
            var key: NSString? = nil
            var value: NSString? = nil
            scanner.scanUpTo(keyValueSeparator, into: &key)
            scanner.scanString(keyValueSeparator, into: nil)
            scanner.scanUpTo(elementSeparator, into: &value)
            scanner.scanString(elementSeparator, into: nil)
            if let key = key as String?, let value = value as String? {
                parameters.updateValue(value, forKey: key)
            }
        }
        return parameters
    }
    
}
