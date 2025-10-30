//
//  SubscriptionResponse.swift
//  SubTracker
//
//  Created by Chathuka Gamage on 2025-10-30.
//

import Foundation

struct SubscriptionResponse: Codable, Identifiable {
    let id: UUID
    let name: String
    let category: String
    let cost: Double
    let billingPlan: String
    let billingDate: Date
}

struct BinResponse: Codable {
    let record: [SubscriptionResponse]
}
