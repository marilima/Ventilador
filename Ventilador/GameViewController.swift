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
    let cameraNode = SCNNode()
    var baseVentis = SCNNode()
    var gradeVentis = SCNNode()
    var heliceVentis = SCNNode()
    var botao1 = SCNNode()
    var botao2 = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        criando, adicionando e posicionando a camera
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // criando, adicionando e posicionando a luz
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // criando e adicionando na cena
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // criando e adicionando na cena as peças do ventilador
        let baseVentilador = scene.rootNode.childNode(withName: "baseVentilador reference", recursively: true)!
        let gradeVentilador = scene.rootNode.childNode(withName: "gradeVentilador reference", recursively: true)!
        let heliceVentilador = scene.rootNode.childNode(withName: "heliceVentilador reference", recursively: true)!
        let botao1Ventilador = scene.rootNode.childNode(withName: "BotaoVentilador1 reference", recursively: true)!
        let botao2Ventilador = scene.rootNode.childNode(withName: "BotaoVentilador2 reference", recursively: true)!
        
        // escalando as peças do ventilador
        heliceVentilador.scale = SCNVector3(x: 1, y: 1, z: 1)
        botao1Ventilador.scale = SCNVector3(x: 1, y: 1, z: 1)
        botao2Ventilador.scale = SCNVector3(x: 1, y: 1, z: 1)
        baseVentilador.scale = SCNVector3(x: 1, y: 1, z: 1)
        gradeVentilador.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        
        // rotacionando as peças do ventilador
        heliceVentilador.rotation = SCNVector4(x: 0, y: 0, z: 0, w: 1.2)
        baseVentilador.rotation = SCNVector4(x: 0, y: 0, z: 0, w: 1.2)
        
        // posicionando as peças do ventilador
        heliceVentilador.position = SCNVector3(x: 0, y: 0, z: 3)
        baseVentilador.position = SCNVector3(x: 0, y: -30, z: 30)
        gradeVentilador.position = SCNVector3(x: 0, y: 0, z: 0)
        botao1Ventilador.position = SCNVector3(x: 4, y: -27, z: -36)
        botao2Ventilador.position = SCNVector3(x: -5, y: -27, z: -36)
        
        
        // falando que a scnView é essa view
        let scnView = self.view as! SCNView
        
        // setando a cena da scnView
        scnView.scene = scene
        
        // deixando o usuario mexer na camera
        scnView.allowsCameraControl = true
        
        // adicionando as peças como filhas
        gradeVentilador.addChildNode(heliceVentilador)
        gradeVentilador.addChildNode(baseVentilador)
        baseVentilador.addChildNode(botao1Ventilador)
        baseVentilador.addChildNode(botao2Ventilador)
        
        // setando os nomes das peças
        baseVentilador.name = "baseVentiladorName"
        baseVentis = baseVentilador
        gradeVentilador.name = "gradeVentiladorName"
        gradeVentis = gradeVentilador
        heliceVentilador.name = "heliceVentiladorName"
        heliceVentis = heliceVentilador
        botao1Ventilador.name = "botao1Name"
        botao1 = botao1Ventilador
        botao2Ventilador.name = "botao2Name"
        botao2 = botao2Ventilador
        
        
        // adicionando o tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
    }
    func animacoesFuncionando() {
        if botao1.name == "botao1Name" {
           gradeVentis.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 2)))
            heliceVentis.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: 2, duration: 0.3)))
            botao1.position = SCNVector3(x: 4, y: -28, z: -36)
            botao2.position = SCNVector3(x: -5, y: -27, z: -36)
            gradeVentis.isPaused = false
            heliceVentis.isPaused = false
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        for i in hitResults {
            if i.node.parent?.name == "botao1Name"{
                 self.animacoesFuncionando()
            } else if i.node.parent?.name == "botao2Name"{
                gradeVentis.isPaused = true
                heliceVentis.isPaused = true
                botao2.position = SCNVector3(x: -5, y: -28, z: -36)
                botao1.position = SCNVector3(x: 4, y: -27, z: -36)
                
            }
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
