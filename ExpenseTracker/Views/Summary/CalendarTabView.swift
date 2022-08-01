//
//  CalendarTabView.swift
//  ExpenseTracker
//
//  Created by Klaudyna Marciniak on 7/31/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct CalendarTabView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @State var categoriesSum: [CategorySum]?
    @State private var sortType = SortType.date
    @State private var sortOrder = SortOrder.descending
    @State private var searchText = ""
    @State var selectedCategories: Set<Category> = Set()
    
    @State var selectedItemStart: Int? = nil
    @State var selectedItemEnd: Int? = nil
    
    var selectedInterval: DateInterval {
        selectedDateInterval(
            startMonth: selectedItemStart,
            endMonth: selectedItemEnd) ?? DateInterval(start: Date(), end: Date())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Text("Choose start and end date").padding(.bottom)
                    .font(.headline)
            }
            
            CalendarView(selectedItemStart: $selectedItemStart, selectedItemEnd: $selectedItemEnd)
            
            Divider()
                
            LogListView(
                predicate: ExpenseLog.predicate(
                    with: selectedInterval
                ), sortDescriptor: ExpenseLogSort(sortType: sortType, sortOrder: sortOrder).sortDescriptor)
            
            
        }
        .padding(.top)
    }
    
    func selectedDateInterval(startMonth: Int?, endMonth: Int?) -> DateInterval? {
        
        guard let startMonth, let endMonth else {
            return nil
        }
        
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2022, month:startMonth+1, day:1))
        
        let firstDayOfEndMonth = calendar.date(from: DateComponents(year: 2022, month:endMonth+1, day:1))
        
        guard let firstDayOfEndMonth else {
            return nil
        }
        
        let endDate = calendar.date(byAdding: DateComponents(month:1), to: firstDayOfEndMonth)
        
        guard let startDate, let endDate else {
            return nil
        }
        
        return DateInterval(start: startDate, end: endDate)
    }
}

