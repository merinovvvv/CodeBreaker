//
//  TimerView.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 20.07.2026.
//

import SwiftUI

struct TimerView: View {
    // MARK: Data In
    let startDate: Date
    let endDate: Date?
    
    // MARK: - Body
    
    var body: some View {
        if let endDate {
            Text(endDate, format: .offset(to: startDate, allowedFields: [.minute, .second]))
        } else {
            Text(TimeDataSource<Date>.currentDate, format: .offset(to: startDate, allowedFields: [.minute, .second]))
        }
    }
}

//#Preview {
//    TimerView()
//}
