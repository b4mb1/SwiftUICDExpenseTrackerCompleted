//
//  CategoryRowView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct CategoryRowView: View {
    let category: Category
    let sum: Double
    @Binding var displayCurrency: Currency
    @Binding var conversionRate: Double
    
    var body: some View {
        HStack {
            CategoryImageView(category: category)
            Text(category.rawValue.capitalized)
            Spacer()
            Text((sum * conversionRate).formattedCurrencyTextWithCurrency(currencyCode: displayCurrency.rawValue)).font(.headline)
        }
    }
}

struct CategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRowView(category: .donation, sum: 2500, displayCurrency: .constant(Currency.USD), conversionRate: .constant(1.0))
    }
}
