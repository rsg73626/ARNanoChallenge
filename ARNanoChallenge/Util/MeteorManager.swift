//
//  MeteorManager.swift
//  ARNanoChallenge
//
//  Created by Renan Germano on 28/02/2018.
//  Copyright © 2018 Renan Germano. All rights reserved.
//

import ARKit
import SceneKit

public class MeteorsManager {
    
    private enum Position {
        case FrontLeft
        case FrontCenter
        case FrontRight
        case BackLeft
        case BackCenter
        case BackRight
    }
    
    private var isStoped: Bool = false
    private var positions: [Position:SCNVector3] = [Position:SCNVector3]();
    private let velocity: TimeInterval = 3.0
    var vc: ViewController!
    private var scene: ARSCNView!
    var meteors: [SCNNode] = [SCNNode]()
    
    init(x: CGFloat, y: CGFloat, z: CGFloat, maxMove: CGFloat) {
        let left: CGFloat = x - (maxMove*0.25)
        let right: CGFloat = x + (maxMove*0.25)
        let front: CGFloat = z - maxMove
        let back: CGFloat = z + maxMove
        
        self.positions[MeteorsManager.Position.FrontLeft] = SCNVector3.init(left, y, front)
        self.positions[MeteorsManager.Position.FrontCenter] = SCNVector3.init(x, y, front)
        self.positions[MeteorsManager.Position.FrontRight] = SCNVector3.init(right, y, front)
        self.positions[MeteorsManager.Position.BackLeft] = SCNVector3.init(left, y, back)
        self.positions[MeteorsManager.Position.BackCenter] = SCNVector3.init(x, y, back)
        self.positions[MeteorsManager.Position.BackRight] = SCNVector3.init(right, y, back)
    }
    
    func start(to scene: ARSCNView) {
        self.scene = scene
        self.createMeteorAt(.FrontLeft)
    }
    
    func stop() {
        self.isStoped = true
        self.meteors.forEach { $0.removeFromParentNode() }
    }
    
    private func createMeteorAt(_ at: Position) {
        if !self.isStoped {
            guard let meteor = Types.Nodes.meteor?.clone(), let position = self.positions[at] else { return }
            self.meteors.append(meteor)
            meteor.position = position
            let to = at == .FrontLeft ? Position.BackLeft : at == .FrontCenter ? Position.BackCenter : Position.BackRight
            self.move(meteor, to)
        }
    }
    
    private func move(_ meteor: SCNNode, _ to: Position) {
        guard let position = self.positions[to] else { return }
        
        let fadeIn = SCNAction.fadeIn(duration: self.velocity*0.3)
        let scaleUp = SCNAction.scale(by: 10, duration: self.velocity*0.3)
        let appear = SCNAction.group([fadeIn, scaleUp])
        
        let move = SCNAction.move(to: position, duration: self.velocity)
        let wait = SCNAction.wait(duration: self.velocity*0.7)
        let createAnother = SCNAction.run { _ in
            let position = to == Position.BackLeft ? Position.FrontCenter :  to == Position.BackCenter ? Position.FrontRight : Position.FrontLeft
            self.createMeteorAt(position)
        }
        
        let fadeOut = SCNAction.fadeOut(duration: self.velocity*0.3)
        let scaleDown = SCNAction.scale(by: 0, duration: self.velocity*0.3)
        let desappearGroup = SCNAction.group([fadeOut, scaleDown])
        let remove = SCNAction.run { n in
            let index = self.meteors.index(of: n)
            self.meteors.remove(at: index!)
        }
        let desappear = SCNAction.sequence([wait, desappearGroup, SCNAction.removeFromParentNode(), remove])
        
        let point = SCNAction.sequence([
            SCNAction.wait(duration: self.velocity*0.6),
            SCNAction.run { _ in if !self.vc.isGameOver { self.vc.score+=1 } }
        ])
        let group = SCNAction.group([point, appear, move, desappear])
        let sequence = SCNAction.sequence([group, createAnother])
        
        self.scene.scene.rootNode.addChildNode(meteor)
        meteor.runAction(sequence)
        print("*** Move! ***")
    }
    
}




























