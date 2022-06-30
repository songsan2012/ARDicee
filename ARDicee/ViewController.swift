//
//  ViewController.swift
//  ARDicee
//
//  Created by song on 6/23/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
        
        
        // -- COMMENT OUT FOR NOW
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        let sphere = SCNSphere(radius: 0.2)
//
//        let material = SCNMaterial()
//
////        material.diffuse.contents = UIColor.red
//        material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
//
//        cube.materials = [material]
//        sphere.materials = [material]
//
//        let node = SCNNode()
//
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
//
////        node.geometry = cube
//        node.geometry = sphere
//
//        sceneView.scene.rootNode.addChildNode(node)
        
        
        
//        // Create a new scene for dice
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//            // Set the scene to the view
//            diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
//            sceneView.scene = diceScene
//        }

        
        
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        print("World Tracking is supported: \(ARWorldTrackingConfiguration.isSupported)")
        
        // AR Plane detection
        configuration.planeDetection = .horizontal
        
        // TODO: Add vertical plane detection
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
//            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
//            let results = ARSCNView.raycastQuery(frompoint)  [ARSCNView raycastQueryFromPoint:allowingTarget:alignment]
            
//            let results = sceneView.hitTest(touchLocation, options: [SCNHitTestOption.searchMode : 1])
            let results = sceneView.hitTest(touchLocation, options: [SCNHitTestOption.searchMode : 1])
            
//            for result in results.filter({$0.node.name != nil})
//            for result in results
//            {
//                if result.node.name == "planeNode"
//                if (!results.isEmpty)
//                {
//                    print("touched the planeNode")
//                }
//                else
//                {
//                    print("Touched somewhere else")
//                }
//            }
            
            
//            if (!results.isEmpty)
//            {
//                print("touched the planeNode")
//            }
//            else
//            {
//                print("Touched somewhere else")
//            }
            
            if let hitResult = results.first {
//            if let hitResult = results.last {
                print ("hitResult is: \(hitResult)")
                
                

                
                // Create a new scene for dice
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
//                let rootNode = particleScene.rootNode
//
//                      rootNode.position = SCNVector3(
//                        x: hitResult.worldTransform.columns.3.x,
//                        y: hitResult.worldTransform.columns.3.y,
//                        z: hitResult.worldTransform.columns.3.z
//                      )
                
                
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    // Set the scene to the view
//                    diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
                    
                    var xPosition = hitResult.worldCoordinates.x
                    var yPosition = hitResult.worldCoordinates.y + diceNode.boundingSphere.radius
                    var zPosition = hitResult.worldCoordinates.z
                    
                    print ("x: \(xPosition), y: \(yPosition), z: \(zPosition)")
                    
                    diceNode.position = SCNVector3(
//                        x: 0.001786,
//                        y: -0.159694,
//                        z: -0.221248z
                        x: hitResult.worldCoordinates.x,
//                        y: hitResult.worldCoordinates.y + diceNode.boundingSphere.radius,
                        y: hitResult.worldCoordinates.y + diceNode.boundingSphere.radius,
                        z:  hitResult.worldCoordinates.z
                    )
//                    sceneView.scene = diceScene
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    
                    let randomX = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
                    let randomZ = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
                    
                    diceNode.runAction(SCNAction.rotateBy(
                        x: CGFloat(randomX * 5),
                        y: 0,
                        z: CGFloat(randomZ * 5),
                        duration: 0.5))
                    
                }
                
            }
            
        }
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            print("Plane detected")
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
            
        }
        else {
            return
        }
        
    }
    
    
}
