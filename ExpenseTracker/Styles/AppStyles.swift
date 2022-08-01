//
//  AppStyles.swift
//  ExpenseTracker
//
//  Created by Klaudyna Marciniak on 7/31/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation
import SwiftUI

struct AppButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Category.health.color)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}
