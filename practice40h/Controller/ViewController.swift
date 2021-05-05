//
//  ViewController.swift
//  practice40h
//
//  Created by 刘昊嵋 on 2021/4/27.
//

import UIKit
import FSCalendar
import ISTimeline
import RealmSwift

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    var calender: FSCalendar!
    var formatter = DateFormatter()
    var formatterDB = DateFormatter()
    var formatterDisplay = DateFormatter()
    
    @IBOutlet weak var timeline: ISTimeline!
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calender = FSCalendar(frame: CGRect(x: 0.0, y: 40.0, width: self.view.frame.size.width, height: 300.0))
        //calender.scope = .week
        //calender.locale = Locale(identifier: "ch")
        calender.scrollDirection = .horizontal
        self.view.addSubview(calender)
        
        calender.delegate = self
        calender.dataSource = self
        calender.allowsMultipleSelection = false
        
        formatterDB.timeStyle = DateFormatter.Style.none
        formatterDB.dateStyle = DateFormatter.Style.short
        
        formatterDisplay.timeStyle = DateFormatter.Style.short
        formatterDisplay.dateStyle = DateFormatter.Style.short
    }
    
    //Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        formatter.dateFormat = "dd-MMM-yyyy"
        
        //fetch data
        let realm = try! Realm()
        let existToday = realm.objects(DayItem.self).filter("date == '\(formatterDB.string(from: date))'")
        if existToday.count == 0{
            print("\(formatterDB.string(from: date)) has no entry")
            displayLabel.text = "No pratice record. Go practice!"
        }
        else{
            print("\(formatterDB.string(from: date)) has \(existToday.count) entries")
            let sessions = existToday.first?.sessions
            renderTimeline(sessions!)
            displayLabel.text = "You practiced \(String(describing: existToday.first?.total_duration))."
        }

        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        removeTimeline()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        formatter.dateFormat = "dd-MM-yyyy"
        guard let excludedDate = formatter.date(from: "23-07-2020")
        else{
            return true
        }
        if date.compare(excludedDate) == .orderedSame{
            return false
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    //Delegate Appearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //Same as shouldSelect
        return nil
    }
    
    //Data Source
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return Date()
//    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
//        return Date().addingTimeInterval((24*60*60)*5)
        return Date()
    }
    
    func renderTimeline(_ sessions: List<Session>){
        
        timeline.backgroundColor = .white
        timeline.bubbleColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        timeline.titleColor = .black
        timeline.descriptionColor = .darkText
        timeline.pointDiameter = 7.0
        timeline.lineWidth = 2.0
        timeline.bubbleRadius = 0.0
        timeline.clipsToBounds = false
        timeline.tag = 100
        
        self.view.addSubview(timeline)

        for i in 0..<sessions.count {
            let point = ISPoint(title: "\(formatterDisplay.string(from: sessions[i].begin))")
            point.description = "Practice Duration: \(sessions[i].duration)"
            point.lineColor = i % 2 == 0 ? .red : .green
            point.pointColor = point.lineColor
            point.touchUpInside =
                { (point:ISPoint) in
                    print(point.title)
            }

            timeline.points.append(point)
        }
    }
    
    func removeTimeline(){
        if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }else{
                print("Unable to remove")
            }
    }


}


