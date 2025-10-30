//
//  UpdateSubView.swift
//  SubTracker
//
//  Created by Vishmi Shanilka on 2025-10-31.
//

import SwiftUI
import SwiftData

struct UpdateSubView: View {
    
        @Bindable var subscription: Subscription
        
        @Environment(\.modelContext) private var context
        @Environment(\.dismiss) private var dismiss
        
        let currency = "LKR"
        
        var body: some View {
            VStack(spacing: 25) {
                
                VStack(spacing: 10) {
                    Image(systemName: "creditcard.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.cyan)
                        .cornerRadius(12)
                    
                   
                    Text(subscription.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                   
                    HStack(spacing: 6) {
                        Text(currency)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(5)
                        
                        TextField("0.00", text: Binding(
                            get: {
                                String(subscription.cost)
                            },
                            set: { newValue in
                                if let value = Double(newValue) {
                                    subscription.cost = value
                                }
                            }
                        ))
                        .keyboardType(.decimalPad)
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 100)
                        .multilineTextAlignment(.leading)
                    }
                }
                .padding(.top, 20)
                
                Divider().background(Color.gray)
                
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Next Billing Date")
                            .foregroundColor(.gray)
                        Spacer()
                        DatePicker("", selection: $subscription.billingDate, displayedComponents: .date)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .tint(.white)
                            
                    }
                    
                  
                    HStack {
                        Text("Billing Plan")
                            .foregroundColor(.gray)
                        Spacer()
                        Picker("Billing Plan", selection: $subscription.billingPlan) {
                            Text("Monthly").tag("Monthly")
                            Text("Yearly").tag("Yearly")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
                
                
                Button(role: .destructive) {
                    context.delete(subscription)
                    try? context.save()
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "xmark.circle")
                        Text("Delete")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
               
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        try?
                        context.save()
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
