//
//  GameViewController.swift
//  Ventilador
//
//  Created by Mariana Lima on 14/04/20.
//  Copyright © 2020 Mariana Lima. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create a new scene
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let baseVentilador = scene.rootNode.childNode(withName: "baseVentilador reference", recursively: true)!
        let gradeVentilador = scene.rootNode.childNode(withName: "gradeVentilador reference", recursively: true)!
        let heliceVentilador = scene.rootNode.childNode(withName: "heliceVentilador reference", recursively: true)!
        let botao1Ventilador = scene.rootNode.childNode(withName: "BotaoVentilador1 reference", recursively: true)!
        let botao2Ventilador = scene.rootNode.childNode(withName: "BotaoVentilador2 reference", recursively: true)!
        
        heliceVentilador.scale = SCNVector3(x: 1, y: 1, z: 1)
        botao1Ventilador.scale = SCNVector3(x: 1, y: 1, z: 1)
        botao2Ventilador.scale = SCNVector3(x: 1, y: 1, z: 1)
        
        heliceVentilador.rotation = SCNVector4(x: 0, y: 0, z: 0, w: 1.2)
        baseVentilador.rotation = SCNVector4(x: 0, y: 0, z: 0, w: 1.2)
        heliceVentilador.position = SCNVector3(x: 0, y: 0, z: 3)
        baseVentilador.position = SCNVector3(x: 0, y: -30, z: 30)
        
        baseVentilador.scale = SCNVector3(x: 1, y: 1, z: 1)
        
        gradeVentilador.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        
        gradeVentilador.position = SCNVector3(x: 0, y: 0, z: 0)
        
     gradeVentilador.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 2)))
     heliceVentilador.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: 2, duration: 0.3)))
     
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        gradeVentilador.addChildNode(heliceVentilador)
        gradeVentilador.addChildNode(baseVentilador)
        baseVentilador.addChildNode(botao1Ventilador)
        baseVentilador.addChildNode(botao2Ventilador)
        
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
    }
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            // get its material
            let material = result.node.geometry!.firstMaterial!
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {

                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                material.emission.contents = UIColor.red
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.black
            
            SCNTransaction.commit()
        }
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
