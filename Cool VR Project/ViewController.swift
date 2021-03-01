//
//  ViewController.swift
//  Cool VR Project
//
//  Created by Michael Tan on 2021-02-28.
//  Copyright © 2021 Michael Tan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate {

    var userExpression = "";

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var vrTextView: UIView!
    @IBOutlet weak var vrTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creates a sceneView
        sceneView.delegate = self
        
        //guard statement to check if our ar face tracking is allowed on the users device
        //if ar face tracking is now allowed
        //we will return an error letting the user know
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Sorry your device does not support our awesome facetracking!!")
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration();

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let userFace = ARSCNFaceGeometry(device: sceneView.device!)
        let node = SCNNode(geometry: userFace)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        //checks our anchors for any updates
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
                 faceGeometry.update(from: faceAnchor.geometry)
                 expression(anchor: faceAnchor)
                 
            //this gets our current facial expressiong and tells the user what they are expressing
                 DispatchQueue.main.async {
                    self.vrTextLabel.text = self.userExpression
                 }
                 
             }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func expression(anchor: ARFaceAnchor){
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        
        self.userExpression = "Checking for expression"
        
        if ((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
            self.userExpression = "You are smiling. "
        }
    }
}
