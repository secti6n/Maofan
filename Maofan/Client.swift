//
//  Client.swift
//  Maofan
//
//  Created by Catt Liu on 2016/11/15.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import OAuthSwift

class Client {
    
    static let sharedInstance = Client()
    var client: OAuthSwiftClient = OAuthSwiftClient(consumerKey: FanfouConsumer.key, consumerSecret: FanfouConsumer.secret)
    
    private init () {}

}


