//
//  TimerRing.swift
//  practice40h
//
//  Created by 刘昊嵋 on 2021/5/4.
//

import SwiftUI
import UICircularProgressRing

struct TimerRingExample: View {
    @ObservedObject var data: TimerData
    //private var timePassed : Double = 0

    private static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()

    var body: some View {
        VStack {
            TimerRing(
                time: .minutes(data.duration),
                delay: .seconds(0.5),
//                elapsedTime: data.done ? .minutes(data.duration) : .minutes(0),
                innerRingStyle: .init(
                    color: .color(.green),
                    strokeStyle: .init(lineWidth: 16, lineCap: .round, lineJoin: .round),
                    padding: 8
                ),
                isPaused: $data.paused,
                isDone: $data.done
            ) { currentTime in
                 
                Text("\(Self.timeFormatter.string(from: currentTime) ?? "NaN")")
                    .font(.title)
                    .bold()
            }
                .padding(.horizontal, 32)

            HStack {
                Button(action: { self.data.paused.toggle() }) {
                    Text(data.paused ? "Continue" : "Pause")
                }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)

                Text("Completed: \(data.done ? "✅" : "❌")")
                    .font(.headline)
            }
            
            Text("Duration: \(data.duration)")
        }
        .navigationBarTitle("Timer Ring")
    }
}

class TimerData: ObservableObject{
    @Published var duration: Double
    @Published var paused: Bool
    @Published var done: Bool
    init(duration: Double, paused: Bool, done: Bool){
        self.duration = duration
        self.paused = paused
        self.done = done
    }
    
}
