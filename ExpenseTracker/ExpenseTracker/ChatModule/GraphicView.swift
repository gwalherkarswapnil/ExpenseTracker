//
//  GraphicView.swift
//  ExpenseTracker
//
//  Created by Swapnil on 01/12/24.
//

import SwiftUI

struct GraphicView: View {
    let graphic: GraphicType

    var body: some View {
        switch graphic {
        case .barChart(let data):
            BarChartView(data: data)
        case .pieChart(let data):
            PieChartView(data: data)
        case .image(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
        }
    }
}

import SwiftUI

struct PieSliceView: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}
