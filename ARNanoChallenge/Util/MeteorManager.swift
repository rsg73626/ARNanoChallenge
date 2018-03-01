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
    
    private var positions: [Position:SCNVector3] = [Position:SCNVector3]();
    private let velocity: TimeInterval = 3.0
    private var scene: ARSCNView!
    
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
    
    private func createMeteorAt(_ at: Position) {
        guard let meteor = Types.Nodes.meteor?.clone(), let position = self.positions[at] else { return }
        meteor.position = position
        let to = at == .FrontLeft ? Position.BackLeft : at == .FrontCenter ? Position.BackCenter : Position.BackRight
        self.move(meteor, to)
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
        let desappear = SCNAction.sequence([wait, desappearGroup, SCNAction.removeFromParentNode()])
        
        let group = SCNAction.group([appear, move, desappear])
        let sequence = SCNAction.sequence([group, createAnother])
        
        self.scene.scene.rootNode.addChildNode(meteor)
        meteor.runAction(sequence)
        print("*** Move! ***")
    }
    
}




























