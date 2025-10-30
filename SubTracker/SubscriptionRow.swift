//
//  SubscriptionRow.swift
//  SubTracker
//
//  Created by Chathuka Gamage on 2025-10-30.
//

import SwiftUI

struct SubscriptionRow: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 16) {
            Image(uiImage: logo(for: subscription.name))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(dueText(for: subscription.billingDate))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("LKR \(subscription.cost, specifier: "%.2f")")
                    .foregroundColor(.white)
                    .font(.headline)
                Text("")
            }
        }
        .padding(.vertical, 8)
    }
    
    func logo(for name: String) -> UIImage {
        switch name.lowercased() {
        case "netflix": return UIImage(named: "netflix") ?? UIImage(systemName: "n.square")!
        case "spotify": return UIImage(named: "spotify") ?? UIImage(systemName: "music.note")!
        case "icloud", "apple icloud": return UIImage(named: "icloud") ?? UIImage(systemName: "cloud")!
        case "chatgpt": return UIImage(named: "chatgpt") ?? UIImage(systemName: "app.fill")!
        default: return UIImage(systemName: "app.fill")!
        }
    }
    
    func dueText(for date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        if days == 0 {
            return "Due Today"
        } else if days > 0 {
            return "Due in \(days) Days"
        } else {
            return "Overdue"
        }
    }
}

