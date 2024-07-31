//
//  CalendarViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI

final class CalendarViewModel: ObservableObject {
    @Published var daysSlider: [DayOfWeek] = []
    @Published var currentWeekIndex: Int = 0
    @Published var selectedDate: Date
    @Published var completedDays: Set<Date> = []
    
    @Published var allHabitsCompletedDays: Set<Date> = []
    @Published var individualHabitCompletedDays: Set<Date> = []
    
    func updateAllHabitsCompletedDays(_ days: Set<Date>) {
        self.allHabitsCompletedDays = days
    }
    
    func updateIndividualHabitCompletedDays(_ days: Set<Date>) {
        self.individualHabitCompletedDays = days
    }
    
    func isCompletedDay(_ date: Date, forAllHabits: Bool) -> Bool {
        let completedDays = forAllHabits ? allHabitsCompletedDays : individualHabitCompletedDays
        return completedDays.contains(Calendar.current.startOfDay(for: date))
    }
    
    func updateCompletedDays(_ days: Set<Date>) {
        self.completedDays = days
    }

    func isCompletedDay(_ date: Date) -> Bool {
        return completedDays.contains(Calendar.current.startOfDay(for: date))
    }

    init(selectedDate: Date = .now) {
//        self.daysSlider = fetchDayOfWeek(for: .now)
        self.selectedDate = selectedDate
    }
    
//    func selectDate(_ date: Date) {
//        self.currentDate = date
//        self.selectedDate = date
//    }
    
    func isFutureDate(_ date: Date) -> Bool {
        return date > Date()
    }
    
    func circleTextColor(currentDate: Date) -> Color {
        if isFutureDate(currentDate) {
            return Color.secondary.opacity(0.6)
        } else if isCurrentDateSame(with: currentDate) && isToday(compareWith: currentDate) {
            return Color.accentColor
        } else {
            return Color.primary
        }
    }
    
    func dateTextColor(currentDate: Date) -> Color {
        if isFutureDate(currentDate) {
            return Color.secondary.opacity(0.5)
        } else if isCurrentDateSame(with: currentDate) && isToday(compareWith: currentDate) {
            return Color(.systemBackground)
        } else if isToday(compareWith: currentDate) {
            return Color.accentColor
        } else if isCurrentDateSame(with: currentDate) {
            return Color(.systemBackground)
        } else {
            return Color.primary
        }
    }
    
    func isToday(compareWith date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func isCurrentDateSame(with date: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    func switchToNextWeek() {
        selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate)!
        daysSlider = fetchDayOfWeek(for: selectedDate)
    }
    
    func switchToCurrentWeek() {
        selectedDate = .now
        daysSlider = fetchDayOfWeek(for: selectedDate)
    }
    
    func switchToPreviousWeek() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate)!
        daysSlider = fetchDayOfWeek(for: selectedDate)
    }
    
    func fetchDayOfWeek(for startDate: Date) -> [DayOfWeek] {
        let calendar = Calendar.current
        
        // Find the Sunday of the current week
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startDate)
        components.weekday = calendar.firstWeekday // Adjusting to the first day of the week as per calendar settings
        let sunday = calendar.date(from: components)!
        
        var days: [DayOfWeek] = []
        
        // Loop through 0 to 6 to get each day from Sunday to Saturday.
        for index in 0..<7 {
            if let weekDay = calendar.date(byAdding: .day, value: index, to: sunday) {
                days.append(DayOfWeek(date: weekDay))
            }
        }
        
        return days
    }
    
    func getDateOfDay(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
    
    func getFirstCharacterOfDay(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        let dayString = dateFormatter.string(from: date)
        return String(dayString.prefix(1))
        
    }
}