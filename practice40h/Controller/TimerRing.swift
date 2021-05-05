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
        formatter.unitsStyle = .brief
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()

    var body: some View {
        VStack {
            TimerRing(
                time: .minutes(data.time),
                delay: .seconds(0.5),
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
            
        }
    }
}

class TimerData: ObservableObject{
    @Published var time: Double
    @Published var paused: Bool
    @Published var done: Bool
    init(time: Double, paused: Bool, done: Bool){
        self.time = time
        self.paused = paused
        self.done = done
    }
    
}
