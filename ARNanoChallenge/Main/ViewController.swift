//
//  ViewController.swift
//  ARNanoChallenge
//
//  Created by Renan Germano on 26/02/2018.
//  Copyright © 2018 Renan Germano. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    //MARK: Outlets
    @IBOutlet var sceneView: ARSCNView!
    
    //MARK: Properties
    override var prefersStatusBarHidden: Bool { return true }
    
    private var tap: UITapGestureRecognizer!
    
    private var label: UILabel!
    private var left: UIButton!
    private var right: UIButton!
    
    private var isPlaneDetected: Bool = false
    private var isGameAdded: Bool = false
    private var isGameStarted: Bool = false
    private var meteorsManager: MeteorsManager!
    
    private var ship: SCNNode!
    private let maxMove: CGFloat = 2.0
    private let maxTime: CGFloat = 2.0
    private var leftX: CGFloat!
    private var rightX: CGFloat!
    private var initialX: CGFloat! {
        didSet {
            leftX = initialX - (maxMove/2)
            rightX = initialX + (maxMove/2)
        }
    }
    
    private var leftSpace: CGFloat! {
        let currentX = CGFloat(self.ship.presentation.position.x)
        return CGFloat(currentX - leftX)
    }
    private var rightSpace: CGFloat! {
        let currentX = CGFloat(self.ship.presentation.position.x)
        return CGFloat(rightX - currentX)
    }
    private var timeIntervalToLeft: TimeInterval {
        let currentX = self.ship.presentation.position.x
        let timeInterval = (leftSpace*maxTime)/maxMove
        return TimeInterval(timeInterval)
    }
    private var timeIntervalToRight: TimeInterval {
        let currentX = self.ship.presentation.position.x
        let timeInterval = (rightSpace*maxTime)/maxMove
        return TimeInterval(timeInterval)
    }
    
    //MARK: Life cicle functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpSceneView()
        self.setUpLightning()
        self.setUpLabel()
        setUpLightning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //MARK: SetUp functions
    private func setUpSceneView() {
        self.sceneView.delegate = self
        self.sceneView.showsStatistics = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
    }
    
    private func setUpLabel() {
        let labelFrame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 30)
        self.label = UILabel(frame: labelFrame)
        self.label.textAlignment = .center
        self.label.text = Types.Messages.searchingPlane
        self.label.textColor = UIColor.white
        self.view.addSubview(self.label)
    }
    
    private func setUpLightning() {
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.automaticallyUpdatesLighting = true
    }
    
    //MARK: Aux funcs
    private func startGame() {
        self.isGameStarted = true
        self.updateLabel()
        self.move(to: .Left)
        self.meteorsManager.start(to: self.sceneView)
        self.sceneView.session.run(ARWorldTrackingConfiguration())
    }
    
    private func addGame(to location: CGPoint) {
        let hitTestResults = sceneView.hitTest(location, types: .existingPlane)
        
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y+1
        let z = translation.z
        
        self.initialX = CGFloat(x)
        self.meteorsManager = MeteorsManager(x: self.initialX, y: CGFloat(y), z: CGFloat(z), maxMove: self.maxMove)
        
        guard let ship = Types.Nodes.ship else { return }
        self.ship = ship
        self.ship.position = SCNVector3.init(x, y, z)
        self.sceneView.scene.rootNode.addChildNode(self.ship)
        
        self.isGameAdded = true
        self.updateLabel()
    }
    
    private func move(to direction: Types.Direction) {
        self.ship.removeAllActions()
        
        var space: CGFloat = 0.0
        var timeInterval: TimeInterval = 0.0
        let currentX = CGFloat(self.ship.presentation.position.x)
        var rotation: CGFloat = CGFloat.pi*0.1
        
        if direction == .Left && currentX > self.leftX {
            space = -self.leftSpace
            timeInterval = self.timeIntervalToLeft
            rotation *= -1
        } else if direction == .Right && currentX < self.rightX {
            space = self.rightSpace
            timeInterval = self.timeIntervalToRight
        } else {
            return
        }
        
        let rotate = SCNAction.rotateTo(x: 0, y: 0, z: rotation, duration: timeInterval)
        let move = SCNAction.moveBy(x: space, y: 0, z: 0, duration: timeInterval)
        let group = SCNAction.group([move, rotate])
        self.ship.runAction(group)
    }
    
    private func updateLabel() {
        let textLabel = self.isGameStarted ? Types.Messages.empty :
            self.isGameAdded ? Types.Messages.startGame :
            self.isPlaneDetected ? Types.Messages.planeDetected :
            Types.Messages.searchingPlane
        DispatchQueue.main.async {
            self.label.text = textLabel
        }
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("*** Plane detected! ***")
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        if !self.isPlaneDetected {
            self.isPlaneDetected = true
            self.updateLabel()
            
            /*Adding Floor
            let width = CGFloat(planeAnchor.extent.x)
            let height = CGFloat(planeAnchor.extent.z)
            let floor = SCNFloor()
            floor.materials.first?.diffuse.contents = UIColor.lightGray.withAlphaComponent(0.5)
            
            let floorNode = SCNNode(geometry: floor)
            
            let x = CGFloat(planeAnchor.center.x)
            let y = CGFloat(planeAnchor.center.y)
            let z = CGFloat(planeAnchor.center.z)
            floorNode.position = SCNVector3(x,y,z)
            
            node.addChildNode(floorNode)*/
            //End adding floor
            
        }
    }
    
    //MARK: Touches handler
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches began!")
        if self.isGameStarted {
            self.move(to: .Right)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches ended!")
        if self.isGameStarted {
            self.move(to: .Left)
        } else {
            if self.isPlaneDetected && !self.isGameAdded {
                guard let touch = touches.first else { return }
                let location = touch.location(in: sceneView)
                self.addGame(to: location)
            } else if self.isGameAdded && !self.isGameStarted{
                self.startGame()
            }
        }
    }
    
    /*
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("*** Touches Moved ***")
        let touchesArray = Array(touches)
        guard let beginTouch = touches.first, let endTouch = touchesArray.last else { return }
        let begin = beginTouch.location(in: sceneView)
        let end = endTouch.location(in: sceneView)
        if begin.x > end.x {
            print("*** Right ***")
            self.move(to: .Right)
        }else if begin.x < end.x {
            print("*** Left ***")
            self.move(to: .Left)
        }
    }*/
    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
