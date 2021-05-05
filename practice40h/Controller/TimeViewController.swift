//
//  TimeViewController.swift
//  practice40h
//
//  Created by 刘昊嵋 on 2021/5/4.
//

import UIKit
import SwiftUI
import UICircularProgressRing
import RealmSwift

class TimeViewController: UIViewController {
    var duration: Double = 60
    var timer: Timer?
    var timerData: TimerData = TimerData(duration:60, paused: true, done: false)
    var today = ""
    var begin = Date()
    var end = Date()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short

        today = dateFormatter.string(from: date)
    }
    
    @IBSegueAction func addTimerRingView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: TimerRingExample(data:timerData))
    }
    
    @IBAction func userDidTappedStart(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        datePicker.isHidden = true
        timerData.duration = duration
        timerData.paused = false
        timerData.done = false
        begin = Date()
        print("start time: \(begin)")
    }
    
    @IBAction func userDidTappedReset(_ sender: UIButton) {
        timer?.invalidate()
        datePicker.isHidden = false
        timerData.paused = true
        timerData.done = true
        end = Date()
        
        let realm = try! Realm()
//        let predicate = NSPredicate(format: "date >= %@ && date < %@", today.addingTimeInterval(-60*60*24) as NSDate, today.addingTimeInterval(60*60*24) as NSDate)
        let existToday = realm.objects(DayItem.self).filter("date == '\(today)'")
        print(existToday)
        let newSession = Session(duration, begin, end, "")
        try! realm.write{
            realm.add(newSession)
        }
        if existToday.count == 0 {
            print("today does not exist")
            let newDay = DayItem(today, duration, 1)
            newDay.sessions.append(newSession)
            try! realm.write{
                realm.add(newDay)
            }
            displayLabel.text = "You have practiced \(duration) minutes today."
        }
        else{
            print("today exists")
            try! realm.write{
                existToday.first?.sessions.append(newSession)
                existToday.first?.total_count += 1
                existToday.first?.total_duration += duration
            }
            displayLabel.text = "You have practiced \(String(describing: existToday.first?.total_duration)) minutes today."
        }
        
        
        
        
    }
    
    @IBAction func userDidChangedDuration(_ sender: UIDatePicker) {
        duration = datePicker.countDownDuration/60
        print(datePicker.countDownDuration)
    }
    
    @objc func step(){
        if duration > 0{
            duration -= 1
        }
        else{
            timer?.invalidate()
            duration = 0
        }
    }
    
    

}
