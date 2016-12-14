//
//  MFOAuthSwiftExtension.swift
//  Pods
//
//  Created by Catt Liu on 2016/12/14.
//
//

import Foundation

extension OAuthSwiftClient {
    
    public func mf_postImage(name: String, urlString: String, parameters: OAuthSwift.Parameters, image: Data, success: OAuthSwiftHTTPRequest.SuccessHandler?, failure: OAuthSwiftHTTPRequest.FailureHandler?) {
        let multiparts = [ OAuthSwiftMultipartData(name: name, data: image, fileName: "file", mimeType: "image/jpeg") ]
        let boundary = "AS-boundary-\(arc4random())-\(arc4random())"
        let type = "multipart/form-data; boundary=\(boundary)"
        let body = self.multiDataFromObject(parameters, multiparts: multiparts, boundary: boundary)
        var finalHeaders = [kHTTPHeaderContentType: type]
        if let request = makeRequest(urlString, method: .POST, headers: finalHeaders, body: body) {
            request.successHandler = success
            request.failureHandler = failure
            request.start()
        }
    }
    
}
