//
//  Subscription.swift
//  SubTracker
//
//  Created by Oneli Karunaratne on 2025-10-30.
//

import Foundation
import SwiftData

@Model
class Subscription: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    var cost: Double
    var billingPlan: String
    var billingDate: Date

    init(id: UUID = UUID(), name: String, category: String, cost: Double, billingPlan: String, billingDate: Date) {
        self.id = id
        self.name = name
        self.category = category
        self.cost = cost
        self.billingPlan = billingPlan
        self.billingDate = billingDate
    }
}
