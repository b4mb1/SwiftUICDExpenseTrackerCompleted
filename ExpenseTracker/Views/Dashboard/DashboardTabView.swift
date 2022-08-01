//
//  DashboardTabView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

class PublisherHolder {
    var cancellable: AnyCancellable?
}

struct DashboardTabView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @State var totalExpenses: Double?
    @State var categoriesSum: [CategorySum]?
    @State var conversionRate: Double = 1.0
    @State var displayCurrency: Currency = .USD
    
    var publisherHolder = PublisherHolder()
    
    var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: 4) {
                    if totalExpenses != nil {
                        Text("Total expenses")
                            .font(.headline)
                        if totalExpenses != nil {
                            Text(totalExpensesText())
                                .font(.largeTitle)
                        }
                    }
                }
                
                if categoriesSum != nil {
                    if totalExpenses != nil && totalExpenses! > 0 {
                        PieChartView(
                            data: categoriesSum!.map { ($0.sum, $0.category.color) },
                            style: Styles.pieChartStyleOne,
                            form: CGSize(width: 300, height: 240),
                            dropShadow: false
                        )
                    }
                    
                    Divider()
                    ZStack {
                        LinearGradient(
                            colors: [Category.shopping.color.opacity(0.4), Category.health.color.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ).frame(maxHeight:100)

                        Button(action: {
                            switch displayCurrency {
                                case .EUR:
                                    displayCurrency = .USD
                                    conversionRate = 1.0
                                    if let cancellable = publisherHolder.cancellable {
                                        cancellable.cancel()
                                    }
                                case .USD:
                                fetchCurrencyRate(publisherHolder: publisherHolder, completion: { result in
                                        switch result {
                                        case .success(let conversionOutput):
                                            conversionRate = conversionOutput.rate
                                            displayCurrency = Currency.EUR
                                        case .failure(let fail):
                                            print("FAIIIL", fail)
                                    }
                                })
                            }
                        }){
                            Text(currencyToText())
                        }.buttonStyle(AppButton())
                    }
                    
                    List {
                        Text("Breakdown").font(.headline)
                        ForEach(self.categoriesSum!) {
                            CategoryRowView(category: $0.category, sum: $0.sum, displayCurrency: $displayCurrency, conversionRate: $conversionRate)
                        }
                    }
                }
                
                if totalExpenses == nil && categoriesSum == nil {
                    Text("No expenses data\nPlease add your expenses from the logs tab")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(.horizontal)
                }
            }
        .padding(.top)
        .onAppear(perform: fetchTotalSums)
    }
    
    func totalExpensesText() -> String {
        return (totalExpenses! * conversionRate).formattedCurrencyTextWithCurrency(currencyCode: displayCurrency.rawValue)
    }
    
    
    func currencyToText() -> String {
        switch displayCurrency {
        case .USD:
            return "Change to: EUR"
        case .EUR:
            return "Change to: USD"
        }
        
    }
    
    func fetchTotalSums() {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: self.context) { (results) in
            guard !results.isEmpty else { return }
            
            let totalSum = results.map { $0.sum }.reduce(0, +)
            self.totalExpenses = totalSum
            self.categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: result.sum, category: result.category)
            })
        }
    }
    
    func convertTo() {
        var newCategorySum = [CategorySum]()
        guard let categoriesSum else {
            return
        }
        
        for element in categoriesSum {
            let newSum = element.sum * conversionRate
            let categorySum = CategorySum(sum: newSum, category: element.category)
            newCategorySum.append(categorySum)
        }
    }
    
    func fetchCurrencyRate(publisherHolder: PublisherHolder,
                           toCurrency: Currency = .EUR,
                           fromCurrency: Currency = .USD,
                           amount: Double = 100.0,
                           
                           completion: @escaping (Result<DefaultExchangeService.ConversionOutput, Error>) -> Void) {
        
        // TODO: These dependencies should be injected
        publisherHolder.cancellable = DefaultExchangeService(networkManager: DefaultNetworkManager(session: ApiNetworkSession())).fetchCurrencyRate(
            request: DefaultExchangeService.Request(
                input: DefaultExchangeService.Request.ConversionInput(to: toCurrency, from: fromCurrency, amount: amount))
        )
        .sink { status in
            print("status received \(String(describing: status))")
        } receiveValue: { value in
            completion(.success(value))
        }
    }
}


struct CategorySum: Identifiable, Equatable {
    let sum: Double
    let category: Category
    
    var id: String { "\(category)\(sum)" }
}


struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView()
    }
}
