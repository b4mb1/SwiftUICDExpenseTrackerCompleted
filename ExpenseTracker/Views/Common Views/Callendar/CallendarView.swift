//
//  CallendarView.swift
//  ExpenseTracker
//
//  Created by Klaudyna Marciniak on 7/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation
import SwiftUI

public struct CalendarView: View {
    @Binding var selectedItemStart: Int?
    @Binding var selectedItemEnd: Int?
    
    let months = Calendar.current.shortMonthSymbols
    
    public var body: some View {
        
        Grid {
            GridRow {
                ForEach(0..<4, id: \.self) { i in
                    ZStack {
                        Capsule()
                            .fill(selectionToColor(itemIndex: i, offset: 0))
                            .frame(width: 60, height: 40)
                            .onTapGesture {
                                updateSelectedItems(itemIndex: i)
                            }
                        Text(months[i]).foregroundColor(.white)
                    }
                }
            }
            
            GridRow {
                ForEach(0..<4, id: \.self) { i in
                    ZStack {
                        Capsule()
                            .fill(selectionToColor(itemIndex: i, offset: 4))
                            .frame(width: 60, height: 40)
                            .onTapGesture {
                                updateSelectedItems(itemIndex: i+4)
                            }
                        Text(months[i + 4]).foregroundColor(.white)
                    }
                }
            }
            
            GridRow {
                ForEach(0..<4, id: \.self) { i in
                    ZStack {
                        Capsule()
                            .fill(selectionToColor(itemIndex: i, offset: 8))
                            .frame(width: 60, height: 40)
                            .onTapGesture {
                                updateSelectedItems(itemIndex: i+8)
                            }
                        Text(months[i + 8]).foregroundColor(.white)
                    }
                }
                
            }
            
        }.padding(20)
    }
    
   private func selectionToColor(itemIndex: Int, offset: Int) -> Color {
        if selectedItemEnd == nil && isMonthSelected(itemInedx: itemIndex, offset: offset) {
            return Color.red.opacity(0.75)
        } else if selectedItemEnd != nil {
            if isMonthSelected(itemInedx: itemIndex, offset: offset){
                return Color.red
            }
        }
        return Color.red.opacity(0.3)
    }
    
    private func isMonthSelected(itemInedx: Int, offset: Int) -> Bool {
        if let selectedItemStart {
            if let selectedItemEnd {
                return (itemInedx + offset) == selectedItemStart || (offset + itemInedx) == selectedItemEnd
            } else {
                return (itemInedx + offset) == selectedItemStart
            }
        } else {
            return false
        }
    }
    
    // first tap sets value for selectedItemStart
    // second tap sets value for selectedItemEnd and makes sure that selectedItemEnd > selectedItemStart
    // third tap will reset state for both selectedItemStart and selectedItemEnd
    
    private func updateSelectedItems(itemIndex: Int) {
        if selectedItemStart == nil {
            selectedItemStart = itemIndex
        } else if selectedItemEnd == nil {
            if itemIndex >= selectedItemStart! {
                selectedItemEnd = itemIndex
            } else {
                selectedItemEnd = selectedItemStart
                selectedItemStart = itemIndex
            }
        } else {
            selectedItemStart = nil
            selectedItemEnd = nil
        }
    }
}


