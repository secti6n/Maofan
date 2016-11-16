//
//  CoreDataTool.swift
//  Maofan
//
//  Created by Catt Liu on 2016/11/16.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit
import CoreData

class CoreDataTool {
    
    static let sharedInstance = CoreDataTool()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    func save(jsonData: NSData, token: String, secret: String) {
        let done = update(jsonData: jsonData)
        if !done {
            insert(jsonData: jsonData, token: token, secret: secret)
        }
    }
    
    func fetch() -> [Account] {
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        return try! context.fetch(request)
    }
    
    func insert(jsonData: NSData, token: String, secret: String) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Account", into: context) as! Account
        entity.jsonData = jsonData
        entity.token = token
        entity.secret = secret
        entity.unique_id = JSON(data: jsonData as Data)["unique_id"].stringValue
        try! context.save()
    }
    
    func delete(unique_id: String) {
        let array = fetch()
        for account in array {
            if unique_id == account.unique_id {
                context.delete(account)
                try! context.save()
                break
            }
        }
    }
    
    func delete(forEntityName: String) {
        let array = fetch()
        for account in array {
            context.delete(account)
            try! context.save()
        }
    }
    
    func update(jsonData: NSData) -> Bool {
        let array = fetch()
        let unique_id = JSON(data: jsonData as Data)["unique_id"].stringValue
        for account in array {
            if unique_id == account.unique_id {
                account.jsonData = jsonData
                try! context.save()
                return true
            }
        }
        return false
    }
    
}
