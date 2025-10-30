//
//  AddSubView.swift
//  SubTracker
//
//  Created by Oneli Karunaratne on 2025-10-30.
//

import SwiftUI
import SwiftData

struct AddSubView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name = ""
    @State private var cost = ""
    @State private var billingPlan = "Monthly"
    @State private var nextBillingDate = Date()
    
    let billingCycles = ["Monthly", "Yearly"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Text("New Subscription")
                    .font(.title.bold())
                    .foregroundColor(.blue)
                    .padding(.top, 5)
                
                VStack(spacing: 10) {
                    Image(systemName: "square.and.arrow.down")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.gray.opacity(0.7))
                    
                    TextField("Enter Name", text: $name)
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
                
                HStack {
                    Text("LKR")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("0.00", text: $cost)
                        .keyboardType(.decimalPad)
                        .font(.title2.bold())
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                
                Form {
                    DatePicker("Next Billing Date", selection: $nextBillingDate, displayedComponents: .date)
                    
                    Picker("Billing Plan", selection: $billingPlan) {
                        ForEach(billingCycles, id: \.self) { cycle in
                            Text(cycle)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(.systemGray6))
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Cancel") {
                                        dismiss()
                                    }
                                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        saveSubscription()
                    }
                }
            }
        }
    }
    
    private func saveSubscription() {
        guard let costValue = Double(cost) else { return }
        let newSub = Subscription(
            name: name,
            category: "General",
            cost: costValue,
            billingPlan: billingPlan,
            billingDate: nextBillingDate
        )
        context.insert(newSub)
        do {
            try context.save()
            dismiss()
        } catch {
            print("Error saving subscription:", error.localizedDescription)
        }
    }
}

#Preview {
    AddSubView()
}

