//
//  Service.swift
//  Maofan
//
//  Created by Catt Liu on 16/9/26.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import OAuthSwift

class Service {
    
    static var sharedInstance = Service()
    
    static func reloadSharedInstance() {
        sharedInstance = Service()
    }
    
    var client = OAuthSwiftClient(consumerKey: FanfouConsumer.key, consumerSecret: FanfouConsumer.secret)
    
    typealias Success = OAuthSwiftHTTPRequest.SuccessHandler
    typealias Failure = OAuthSwiftHTTPRequest.FailureHandler
    
    private init () {
        if let account = CoreDataTool.sharedInstance.fetch().first {
            client = OAuthSwiftClient(consumerKey: FanfouConsumer.key, consumerSecret: FanfouConsumer.secret, oauthToken: account.token!, oauthTokenSecret: account.secret!, version: .oauth1)
        }
    }
    
    func apiPath(_ string: String) -> String {
        return FanfouConsumer.api_url + string + ".json"
    }
    
    // MARK: post feed
    
    func postText(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/statuses/update"), parameters: parameters, success: success, failure: failure)
    }
    
    func postImage(parameters: [String: String], image: Data, success: Success?, failure: Failure?) {
        client.mf_postImage(name: "photo", urlString: apiPath("/photos/upload"), parameters: parameters, image: image, success: success, failure: failure)
    }
    
    // MARK: statuses
    
    func home_timeline(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/statuses/home_timeline"), parameters: parameters, success: success, failure: failure)
    }
    
    func public_timeline(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/statuses/public_timeline"), parameters: parameters, success: success, failure: failure)
    }
    
    func user_timeline(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/statuses/user_timeline"), parameters: parameters, success: success, failure: failure)
    }
    
    func photos_user_timeline(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/photos/user_timeline"), parameters: parameters, success: success, failure: failure)
    }
    
    func mentions(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/statuses/mentions"), parameters: parameters, success: success, failure: failure)
    }
    
    func replies(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/statuses/replies"), parameters: parameters, success: success, failure: failure)
    }
    
    func show(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/statuses/show"), parameters: parameters, success: success, failure: failure)
    }
    
    func context_timeline(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/statuses/context_timeline"), parameters: parameters, success: success, failure: failure)
    }
    
    func destroy(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/statuses/destroy"), parameters: parameters, success: success, failure: failure)
    }
    
    // MARK: favorites
    
    func favorites(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/favorites"), parameters: parameters, success: success, failure: failure)
    }
    
    func favorites_create(parameters: [String: String], success: Success?, failure: Failure?) {
        guard let id = parameters["id"] else { return }
        client.post(apiPath("/favorites/create/\(id)"), parameters: parameters, success: success, failure: failure)
    }

    func favorites_destroy(parameters: [String: String], success: Success?, failure: Failure?) {
        guard let id = parameters["id"] else { return }
        client.post(apiPath("/favorites/destroy/\(id)"), parameters: parameters, success: success, failure: failure)
    }

    // MARK: search
    
    func search_public_timeline(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/search/public_timeline"), parameters: parameters, success: success, failure: failure)
    }
    
    func search_user_timeline(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/search/user_timeline"), parameters: parameters, success: success, failure: failure)
    }

    func search_users(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/search/users"), parameters: parameters, success: success, failure: failure)
    }
    
    func saved_searches_create(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/saved_searches/create"), parameters: parameters, success: success, failure: failure)
    }
    
    func saved_searches_destroy(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/saved_searches/destroy"), parameters: parameters, success: success, failure: failure)
    }
    
    func saved_searches_list(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/saved_searches/list"), parameters: parameters, success: success, failure: failure)
    }
    
    func trends_list(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/trends/list"), parameters: parameters, success: success, failure: failure)
    }
    
    // MARK: direct-messages
    
    func direct_messages_new(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/direct_messages/new"), parameters: parameters, success: success, failure: failure)
    }
    
    func direct_messages_destroy(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/direct_messages/destroy"), parameters: parameters, success: success, failure: failure)
    }
    
    func direct_messages_conversation_list(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/direct_messages/conversation_list"), parameters: parameters, success: success, failure: failure)
    }
    
    func direct_messages_conversation(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/direct_messages/conversation"), parameters: parameters, success: success, failure: failure)
    }
    
    // MARK: users
    
    func users_tagged(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/users/tagged"), parameters: parameters, success: success, failure: failure)
    }
    
    func users_show(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/users/show"), parameters: parameters, success: success, failure: failure)
    }
    
    func users_tag_list(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/users/tag_list"), parameters: parameters, success: success, failure: failure)
    }
    
    func users_followers(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/users/followers"), parameters: parameters, success: success, failure: failure)
    }
    
    func users_friends(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/users/friends"), parameters: parameters, success: success, failure: failure)
    }
    
    // MARK: account
    
    func verify_credentials(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/account/verify_credentials"), parameters: parameters, success: success, failure: failure)
    }
    
    func notification(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/account/notification"), parameters: parameters, success: success, failure: failure)
    }
    
    func update_profile_image(parameters: [String: String], image: Data, success: Success?, failure: Failure?) {
        client.mf_postImage(name: "image", urlString: apiPath("/account/update_profile_image"), parameters: parameters, image: image, success: success, failure: failure)
    }
    
    func update_profile(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/account/update_profile"), parameters: parameters, success: success, failure: failure)
    }
    
    func rate_limit_status(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/account/rate_limit_status"), parameters: parameters, success: success, failure: failure)
    }
    
    // MARK: friendships
    
    func friendships_requests(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/friendships/requests"), parameters: parameters, success: success, failure: failure)
    }
    
    func friendships_show(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/friendships/show"), parameters: parameters, success: success, failure: failure)
    }
    
    func friendships_create(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/friendships/create"), parameters: parameters, success: success, failure: failure)
    }
    
    func friendships_destroy(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/friendships/destroy"), parameters: parameters, success: success, failure: failure)
    }
    
    func friendships_deny(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/friendships/deny"), parameters: parameters, success: success, failure: failure)
    }
    
    func friendships_accept(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/friendships/accept"), parameters: parameters, success: success, failure: failure)
    }
    
    // MARK: blocks
    
    func blocks_blocking(parameters: [String: String], success: Success?, failure: Failure?) {
        client.get(apiPath("/blocks/blocking"), parameters: parameters, success: success, failure: failure)
    }
    
    func blocks_create(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/blocks/create"), parameters: parameters, success: success, failure: failure)
    }
    
    func blocks_destroy(parameters: [String: String], success: Success?, failure: Failure?) {
        client.post(apiPath("/blocks/destroy"), parameters: parameters, success: success, failure: failure)
    }
    
}
