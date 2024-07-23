//
//  CalendarView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var forAllHabits: Bool = true

    var body: some View {
        VStack {
            HStack {
                Button {
                    calendarViewModel.switchToPreviousWeek()
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                }
                
                Spacer()
                
                Text(calendarViewModel.selectedDate.formatted(date: .complete, time: .omitted))
                    .font(.system(.body, weight: .semibold))
                    .onTapGesture {
                        calendarViewModel.switchToCurrentWeek()
                    }
                
                Spacer()
                
                Button {
                    calendarViewModel.switchToNextWeek()
                } label: {
                    Image(systemName: "chevron.right")
                        .bold()
                }
            }
            .animation(.easeOut, value: calendarViewModel.selectedDate)
            .padding([.bottom, .horizontal])
            
            HStack {
                ForEach(calendarViewModel.daysSlider) { day in
                    VStack {
                        Text(calendarViewModel.getFirstCharacterOfDay(from: day.date))
                            .font(.system(.caption2, weight: .medium))
                        
                        Text(calendarViewModel.getDateOfDay(from: day.date))
                            .font(.system(.title3, weight: calendarViewModel.isCurrentDateSame(with: day.date) ? .bold : .regular))
                            .padding(.all, 6)
                            .foregroundStyle(calendarViewModel.dateTextColor(currentDate: day.date))
                            .background {
                                if calendarViewModel.isCurrentDateSame(with: day.date) {
                                    Circle()
                                        .fill(calendarViewModel.circleTextColor(currentDate: day.date))
                                }
                            }
                            .frame(width: 46)
                        
                        Circle()
                            .fill(calendarViewModel.isCompletedDay(day.date, forAllHabits: forAllHabits) ? Color.accentColor : Color.primary.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                    .onTapGesture {
                        if !calendarViewModel.isFutureDate(day.date) {
                            calendarViewModel.selectedDate = day.date
                            calendarViewModel.selectedDate = day.date
                        }
                    }
                    .opacity(calendarViewModel.isFutureDate(day.date) ? 0.3 : 1.0)
                }
            }
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(.background)
    }
}

#Preview {
    CalendarView(calendarViewModel: CalendarViewModel())
}
