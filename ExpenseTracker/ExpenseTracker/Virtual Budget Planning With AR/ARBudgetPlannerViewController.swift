//
//  ARBudgetPlannerViewController.swift
//  ExpenseTracker
//
//  Created by Swapnil on 01/12/24.
//



import UIKit
import ARKit
import SwiftUI

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
    private let budgetData: [CGFloat] = [5000, 3000, 2000, 7000, 1500] // Example data for categories
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSceneView()
        addInstructionLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Configure AR session with horizontal plane detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    private func setupSceneView() {
        // Initialize ARSCNView
        sceneView = ARSCNView(frame: self.view.bounds)
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        self.view.addSubview(sceneView)
    }

    private func addInstructionLabel() {
        // Add a label with usage instructions
        let instructionLabel = UILabel()
        instructionLabel.text = "Point the camera at a flat surface to see your budget plan."
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = .white
        instructionLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        instructionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(instructionLabel)

        NSLayoutConstraint.activate([
            instructionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            instructionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            instructionLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40),
            instructionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // Handle tap gestures to place the budget chart
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: sceneView),
              let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent).first else {
            return
        }

        // Add 3D pie chart at the tap location
        let position = SCNVector3(
            hitTestResult.worldTransform.columns.3.x,
            hitTestResult.worldTransform.columns.3.y,
            hitTestResult.worldTransform.columns.3.z
        )
        addBudgetVisualization(at: position)
    }

    private func addBudgetVisualization(at position: SCNVector3) {
        let total = budgetData.reduce(0, +)
        var startAngle: CGFloat = 0

        for value in budgetData {
            let proportion = value / total
            let sliceNode = createPieSlice(
                startAngle: startAngle,
                proportion: proportion
            )
            sliceNode.position = position
            sceneView.scene.rootNode.addChildNode(sliceNode)
            startAngle += proportion * 360
        }
    }

    private func createPieSlice(startAngle: CGFloat, proportion: CGFloat) -> SCNNode {
        let radius: CGFloat = 0.15 // Size of the pie chart
        let endAngle = startAngle + (proportion * 360)

        // Define the 2D pie slice using a UIBezierPath
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

        // Create 3D geometry from the path
        let shape = SCNShape(path: path, extrusionDepth: 0.01)
        shape.firstMaterial?.diffuse.contents = UIColor.random()

        // Return a node containing the geometry
        return SCNNode(geometry: shape)
    }

    // MARK: - ARSCNViewDelegate Methods
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            DispatchQueue.main.async {
                // Optional: Add visuals or labels when a plane is detected
            }
        }
    }
}

// MARK: - Utility Extensions
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
