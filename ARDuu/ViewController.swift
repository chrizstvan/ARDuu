//
//  ViewController.swift
//  ARDuu
//
//  Created by Christian Stevanus on 27/02/19.
//  Copyright © 2019 Christian Stevanus. All rights reserved.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //show detection
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
//        // Create a new scene - udah ga kepake di pake di method touch
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        // Set the scene to the view
//        //sceneView.scene = scene
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true){
//            diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
        
//        //3D object
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        let sphere = SCNSphere(radius: 0.2)
//
//        //Setting material
//        let customMaterial = SCNMaterial()
//        customMaterial.diffuse.contents = UIImage(named: "art.scnassets/8k_sun.jpg")
//
//        //insert material to object
//        sphere.materials = [customMaterial]
//
//        //create point in 3d space
//        let node = SCNNode()
//        // node position
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
//        //assign position to 3D object
//        node.geometry = sphere
//
//        //implement to scene
//        sceneView.scene.rootNode.addChildNode(node)
//        //setting light into scene
       sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
//        print("Face Tracking is supported = \(ARFaceTrackingConfiguration.isSupported)")
//        print("Image tracking is supported = \(ARImageTrackingConfiguration.isSupported)")
//        print("World tracking is supported = \(ARWorldTrackingConfiguration.isSupported)")
//        print("Object scaning is supported = \(ARObjectScanningConfiguration.isSupported)")
//        print("Orientaion tracking is supported = \(AROrientationTrackingConfiguration.isSupported)")
//
        //configure plane detection
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    //MARK: - Set up plane
    //Method didadd setting plane anchor
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            //set up plane
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            //set up plane in world space
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            //give the plane 90 degree rotation
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            //set up plane material
            let planeMaterial = SCNMaterial()
            planeMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [planeMaterial]
            
            //place the plane to world space
            planeNode.geometry = plane
            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }
    
    //MARK: - Setup Touch screen
    //Method to touch screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: sceneView)
            
            let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
//            //chek if we touch the plane or not
//            if !result.isEmpty {
//                print("we touch the plane")
//            } else {
//                print("we touch somewhere else")
//            }
            
            if let hitResult = result.first {
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    diceNode.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        z: hitResult.worldTransform.columns.3.z
                    )
                    sceneView.scene.rootNode.addChildNode(diceNode)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    
}
