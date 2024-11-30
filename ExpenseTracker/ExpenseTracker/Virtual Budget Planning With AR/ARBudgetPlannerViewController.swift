//
//  ARBudgetPlannerViewController.swift
//  ExpenseTracker
//
//  Created by Swapnil on 01/12/24.
//

import UIKit

import UIKit
import ARKit

import SwiftUI
import ARKit

struct ARBudgetPlannerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ARBudgetPlannerViewController {
        let viewController = ARBudgetPlannerViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: ARBudgetPlannerViewController, context: Context) {
        // Handle updates if necessary
    }
}

class ARBudgetPlannerViewController: UIViewController, ARSCNViewDelegate {
    private var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize ARSCNView
        sceneView = ARSCNView(frame: self.view.bounds)
        sceneView.delegate = self
        self.view.addSubview(sceneView)

        // Setup AR Session
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // AR session configurations
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the AR session
        sceneView.session.pause()
    }

    // Add AR content
    func addBudgetVisualization(data: [CGFloat]) {
        let total = data.reduce(0, +)
        let center = SCNVector3(0, 0, -0.5) // Adjust for AR positioning

        // Create pie chart in 3D
        var startAngle: CGFloat = 0
        for value in data {
            let slice = SCNNode(geometry: createPieSlice(startAngle: startAngle, value: value / total))
            slice.position = center
            sceneView.scene.rootNode.addChildNode(slice)
            startAngle += CGFloat(Double(value / total) * 360.0)
        }
    }

    private func createPieSlice(startAngle: CGFloat, value: CGFloat) -> SCNGeometry {
        let radius: CGFloat = 0.1
        let endAngle = startAngle + CGFloat(value * 360.0)

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(
            withCenter: CGPoint(x: 0, y: 0),
            radius: radius,
            startAngle: startAngle.toRadians(),
            endAngle: endAngle.toRadians(),
            clockwise: true
        )
        path.close()

        let shape = SCNShape(path: path, extrusionDepth: 0.01)
        shape.firstMaterial?.diffuse.contents = UIColor.random()
        return shape
    }
}

private extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180
    }
}

private extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

