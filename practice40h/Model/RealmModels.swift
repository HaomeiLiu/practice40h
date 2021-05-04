//
//  RealmModels.swift
//  practice40h
//
//  Created by 刘昊嵋 on 2021/5/5.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _partition: String = ""
    @objc dynamic var name: String = ""
    override static func primaryKey() -> String? {
        return "_id"
    }}
