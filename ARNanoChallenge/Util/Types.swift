//
//  Util.swift
//  ARNanoChallenge
//
//  Created by Renan Germano on 26/02/2018.
//  Copyright © 2018 Renan Germano. All rights reserved.
//

import Foundation
import ARKit

public class Types {
    
    enum Direction {
        case Left
        case Right
        func string() -> String { return self == .Left ? "Left" : "Right"}
    }
    
    struct Messages {
        static let searchingPlane = "Searching plane..."
        static let planeDetected = "Plane detected. Tap to add. "
        static let startGame = "Tap to start."
        static let empty = ""
    }
    
    struct Nodes {
        static var ship: SCNNode? {
            guard let shipScene = SCNScene(named: "art.scnassets/ship.scn") else { return nil }
            let ship = shipScene.rootNode
            if let leftMotor = ship.childNode(withName: Identifiers.leftMotor, recursively: false), let rightMotor = ship.childNode(withName: Identifiers.rightMotor, recursively: false), let leftMotorParticle = Particles.motor, let rightMotorParticle = Particles.motor {
                
                let leftMotorGeometry = SCNSphere(radius: 0.005)
                leftMotorParticle.emitterShape = leftMotorGeometry
                leftMotor.geometry = leftMotorGeometry
                leftMotor.addParticleSystem(leftMotorParticle)
                
                let rightMotorGeometry = SCNSphere(radius: 0.005)
                rightMotorParticle.emitterShape = rightMotorGeometry
                rightMotor.geometry = rightMotorGeometry
                rightMotor.addParticleSystem(rightMotorParticle)
                
                print("*** Added particle! ***")
                
            }
            return ship
        }
        static var meteor: SCNNode? {
            let sphere = SCNSphere(radius: 0.01)
            sphere.materials.first?.diffuse.contents = Images.metor
            let fireParticle = Particles.fire
            fireParticle?.emitterShape = sphere
            let meteor = SCNNode(geometry: sphere)
            meteor.name = Types.Identifiers.meteor
            meteor.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape.init(node: meteor, options: nil))
            meteor.physicsBody?.categoryBitMask = Types.Masks.meteor
            meteor.physicsBody?.contactTestBitMask = Types.Masks.ship
            meteor.addParticleSystem(fireParticle!)
            return meteor
        }
    }
    
    struct Masks {
        static let empty: Int = 0
        static let ship: Int = 1
        static let meteor: Int = 2
    }
    
    struct Identifiers {
        static let meteor = "meteor"
        static let ship = "ship"
        static let leftMotor = "leftMotor"
        static let rightMotor = "rightMotor"
    }
    
    struct Images {
        static let metor = #imageLiteral(resourceName: "meteor")
    }
    
    struct Particles {
        static var fire: SCNParticleSystem? {
            return SCNParticleSystem(named: "Fire.scnp", inDirectory: nil)
        }
        static var stars: SCNParticleSystem? {
            return SCNParticleSystem(named: "Stars.scnp", inDirectory: nil)
        }
        static var motor: SCNParticleSystem? {
            return SCNParticleSystem(named: "Motor.scnp", inDirectory: nil)
        }
    }
    
}
