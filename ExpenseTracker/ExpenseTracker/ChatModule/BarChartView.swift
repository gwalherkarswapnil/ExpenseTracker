//
//  BarChartView.swift
//  ExpenseTracker
//
//  Created by Swapnil on 01/12/24.
//

import SwiftUI

struct BarChartView: View {
    let data: [CGFloat]

    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            ForEach(data, id: \.self) { value in
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 20, height: value)
                    .cornerRadius(5)
            }
        }
        .frame(height: 100)
    }
}

struct PieChartView: View {
    let data: [CGFloat]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<data.count) { index in
                    PieSliceView(startAngle: startAngle(for: index),
                                 endAngle: endAngle(for: index))
                        .fill(colors[index % colors.count])
                }
            }
            .aspectRatio(contentMode: .fit)
        }
    }

    private let colors: [Color] = [.red, .blue, .green, .yellow, .purple]

    private func startAngle(for index: Int) -> Angle {
        let total = data.reduce(0, +)
        let sum = data.prefix(index).reduce(0, +)
        return .degrees(Double(sum / total) * 360)
    }

    private func endAngle(for index: Int) -> Angle {
        let total = data.reduce(0, +)
        let sum = data.prefix(index + 1).reduce(0, +)
        return .degrees(Double(sum / total) * 360)
    }
}
