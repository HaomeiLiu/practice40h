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

class DayItem: Object {
    @objc dynamic var date = ""
    @objc dynamic var total_duration = 0.0
    @objc dynamic var total_count = 0
    let sessions = List<Session>()
    var dayHadPracticed: Bool{
        return sessions.count > 0
    }
    convenience init(_ date : String, _ total_duration : Double, _ total_count : Int) {
        self.init()
        self.date = date
        self.total_duration = total_duration
        self.total_count = total_count
    }
}

class Session: Object{
    @objc dynamic var duration: Double = 0.0
    @objc dynamic var begin = Date()
    @objc dynamic var end = Date()
    @objc dynamic var mood = ""
    convenience init(_ duration: Double, _ begin : Date, _ end: Date, _ mood: String) {
        self.init()
        self.duration = duration
        self.begin = begin
        self.end = end
        self.mood = mood
    }
}
