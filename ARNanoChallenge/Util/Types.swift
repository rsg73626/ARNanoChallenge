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
            guard let shipScene = SCNScene(named: "art.scnassets/ship.scn")
                else { return nil }
            return shipScene.rootNode
        }
        static var meteor: SCNNode? {
            let sphere = SCNSphere(radius: 0.01)
            sphere.materials.first?.diffuse.contents = UIColor.brown
            let meteor = SCNNode(geometry: sphere)
            return meteor
        }
    }
    
}
