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
    var timerData: TimerData = TimerData(time:20, paused: true, done: false)
    var today = ""
    var begin = Date()
    var end = Date()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var displayLabel: UILabel!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var riView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short

        today = dateFormatter.string(from: date)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
//        self.viewDidLoad()
        super.viewWillAppear(animated)
        timerData.paused = true
        timerData.done = false
        timerData.time = 1
        datePicker.isHidden = false
        startButton.isHidden = false
        skipButton.isHidden = true
        
    }
    
    @IBSegueAction func addTimerRingView(_ coder: NSCoder) -> UIViewController? {
        let timerRingExample = TimerRingExample(data:timerData)
        return UIHostingController(coder: coder, rootView: timerRingExample)
    }
    
    @IBAction func userDidTappedStart(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        datePicker.isHidden = true
        timerData.time = duration
        timerData.paused = false
        timerData.done = false
        begin = Date()
        print("start time: \(begin)")
        startButton.isHidden = true
        skipButton.isHidden = false
    }
    
    @IBAction func userDidTappedReset(_ sender: UIButton) {
        timer?.invalidate()
        datePicker.isHidden = false
        timerData.paused = true
        timerData.done = true
        timerData.time = 0
        end = Date()
        
        startButton.isHidden = false
        skipButton.isHidden = true
        
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
            displayLabel.text = "You have practiced \( existToday.first?.total_duration ?? 0) minutes today."
        }
        
        let alert = UIAlertController(title: "Practice Completed!", message: "You have practiced \(existToday.first?.total_duration ?? 0) minutes. Share your effort to Instagram?", preferredStyle: .actionSheet)
        
        let shareToIns = UIAlertAction(title: "Yes!", style: .default){
            action in
            self.performSegue(withIdentifier: "toShare", sender: self)
        }
        let cancel = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
        alert.addAction(shareToIns)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
 
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
