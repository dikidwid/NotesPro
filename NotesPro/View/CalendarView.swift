//
//  CalendarView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @State var forAllHabits: Bool = true

    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.switchToPreviousWeek()
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                }
                
                Spacer()
                
                Text(viewModel.currentDate.formatted(date: .complete, time: .omitted))
                    .font(.system(.body, weight: .semibold))
                    .onTapGesture {
                        viewModel.switchToCurrentWeek()
                    }
                
                Spacer()
                
                Button {
                    viewModel.switchToNextWeek()
                } label: {
                    Image(systemName: "chevron.right")
                        .bold()
                }
            }
            .animation(.easeOut, value: viewModel.currentDate)
            .padding([.bottom, .horizontal])
            
            HStack {
                ForEach(viewModel.daysSlider) { day in
                    VStack {
                        Text(viewModel.getFirstCharacterOfDay(from: day.date))
                            .font(.system(.caption2, weight: .medium))
                        
                        Text(viewModel.getDateOfDay(from: day.date))
                            .font(.system(.title3, weight: viewModel.isCurrentDateSame(with: day.date) ? .bold : .regular))
                            .padding(.all, 6)
                            .foregroundStyle(viewModel.dateTextColor(currentDate: day.date))
                            .background {
                                if viewModel.isCurrentDateSame(with: day.date) {
                                    Circle()
                                        .fill(viewModel.circleTextColor(currentDate: day.date))
                                }
                            }
                            .frame(width: 46)
                        
                        Circle()
                            .fill(viewModel.isCompletedDay(day.date, forAllHabits: forAllHabits) ? Color.accentColor : Color.primary.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                    .onTapGesture {
                        if !viewModel.isFutureDate(day.date) {
                            viewModel.currentDate = day.date
                            viewModel.selectedDate = day.date
                        }
                    }
                    .opacity(viewModel.isFutureDate(day.date) ? 0.3 : 1.0)
                }
            }
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
}

#Preview {
    CalendarView(viewModel: CalendarViewModel())
}
