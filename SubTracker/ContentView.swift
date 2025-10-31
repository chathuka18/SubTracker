//
//  ContentView.swift
//  SubTracker
//
//  Created by Chathuka Gamage on 2025-10-30.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var localSubs: [Subscription]
    @Environment(\.modelContext) private var context
    
    @State private var apiSubs: [Subscription] = []
    @State private var showAddSheet = false
    
    private var allSubscriptions: [Subscription] {
        let combined = localSubs + apiSubs
        var uniqueDict = [UUID: Subscription]()
        for sub in combined {
            uniqueDict[sub.id] = sub
        }
        return Array(uniqueDict.values)
            .sorted { $0.billingDate < $1.billingDate }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Subscriptions")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        showAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                    
                    
                }
                .padding(.horizontal)
                .padding(.top)
                
                Divider().background(Color.gray)
                
                if allSubscriptions.isEmpty {
                    VStack(spacing: 10) {
                        Spacer()
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No Subscriptions Yet")
                            .foregroundColor(.gray)
                            .font(.headline)
                        Spacer()
                    }
                } else {
                    NavigationStack {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(allSubscriptions) { sub in
                                    NavigationLink(destination: UpdateSubView(subscription: sub)) {
                                        SubscriptionRow(subscription: sub)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                
                        .navigationBarTitleDisplayMode(.inline)
                        
                        .background(Color.black)
                    }
                    .background(Color.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Spacer()
                
                VStack {
                    Divider().background(Color.gray)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Estimated Total (Per Month)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("LKR \(totalCost(), specifier: "%.2f")")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddSubView()
        }
        
        .onAppear {
            fetchSubscriptions()
        }
    }
    
    func fetchSubscriptions() {
        guard let url = URL(string: "https://api.jsonbin.io/v3/qs/690434daae596e708f393462") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decoded = try decoder.decode(BinResponse.self, from: data)
                    
                    let apiItems = decoded.record.map {
                        Subscription(
                            id: $0.id,
                            name: $0.name,
                            category: $0.category,
                            cost: $0.cost,
                            billingPlan: $0.billingPlan,
                            billingDate: $0.billingDate
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self.apiSubs = apiItems
                    }
                    
                } catch {
                    print("Decoding error:", error)
                }
            } else if let error = error {
                print("Network error:", error.localizedDescription)
            }
        }.resume()
    }
    
    func totalCost() -> Double {
        allSubscriptions.reduce(0) { $0 + $1.cost }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Subscription.self)
}
