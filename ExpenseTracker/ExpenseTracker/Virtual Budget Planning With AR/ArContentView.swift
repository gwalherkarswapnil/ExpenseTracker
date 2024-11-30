//
//  ArContentView.swift
//  ExpenseTracker
//
//  Created by Swapnil on 01/12/24.
//

import SwiftUI

struct ArContentView: View {
    var body: some View {
        VStack {
            Text("AR Budget Planner")
                .font(.largeTitle)
                .bold()
                .padding()
            
            ARBudgetPlannerView()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ArContentView()
}
