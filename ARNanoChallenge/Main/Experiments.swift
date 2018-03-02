/*
 
 @objc func buttonDidBeginTap(sender: UIButton) {
 guard let id = sender.restorationIdentifier else { return }
 print("\(id) began press!")
 
 self.ship.removeAllActions()
 var space: CGFloat = 0.0
 var timeInterval: TimeInterval = 0.0
 
 if id == Types.Identifier.left {
 self.right.isEnabled = false
 space = self.leftSpace
 timeInterval = self.timeIntervalToLeft
 } else if id == Types.Identifier.right {
 self.left.isEnabled = false
 space = -self.rightSpace
 timeInterval = self.timeIntervalToRight
 }
 
 let move = SCNAction.moveBy(x: space, y: 0, z: 0, duration: timeInterval)
 self.ship.runAction(move)
 }
 
 @objc func buttonDidPress(sender: UIButton) {
 guard let id = sender.restorationIdentifier else { return }
 print("\(id) pressed!")
 
 self.ship.removeAllActions()
 
 if id == Types.Identifier.left {
 self.right.isEnabled = true
 } else if id == Types.Identifier.right {
 self.left.isEnabled = true
 }
 }
 
 private func setUpButtons() {
 let leftFrame = CGRect.init(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
 self.left = UIButton(frame: leftFrame)
 self.left.setTitle("Left", for: .normal)
 self.left.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
 self.left.restorationIdentifier = Types.Identifier.left
 
 let rightFrame = CGRect.init(x: self.view.frame.width/2, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
 self.right = UIButton(frame: rightFrame)
 self.right.setTitle("Right", for: .normal)
 self.right.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
 self.right.restorationIdentifier = Types.Identifier.right
 
 [self.left, self.right].forEach {
 $0?.titleLabel?.textColor = UIColor.white
 $0?.titleLabel?.textAlignment = .center
 self.view.addSubview($0!)
 $0?.addTarget(self, action: #selector(ViewController.buttonDidBeginTap(sender:)), for: .touchDown)
 $0?.addTarget(self, action: #selector(ViewController.buttonDidPress(sender:)), for: .touchUpInside)
 $0?.addTarget(self, action: #selector(ViewController.buttonDidPress(sender:)), for: .touchUpOutside)
 }
 }
 
 @objc func screenTappedCreate(sender: UIGestureRecognizer) {
 print("*** screen tapped create! ***")
 if self.isPlaneDetected && !self.isGameAdded {
 let tapLocation = sender.location(in: sceneView)
 let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
 
 guard let hitTestResult = hitTestResults.first else { return }
 let translation = hitTestResult.worldTransform.translation
 let x = translation.x
 let y = translation.y+1.5
 let z = translation.z
 
 self.initialX = CGFloat(x)
 
 guard let ship = Types.Nodes.ship else { return }
 self.ship = ship
 self.ship.position = SCNVector3.init(x, y, z)
 self.sceneView.scene.rootNode.addChildNode(self.ship)
 
 self.isGameAdded = true
 self.updateLabel()
 
 /*let sphere = SCNSphere(radius: 0.5)
 let meteor = SCNNode(geometry: sphere)
 meteor.position = SCNVector3.init(x, y, z-100)
 self.sceneView.scene.rootNode.addChildNode(meteor)
 meteor.runAction(SCNAction.sequence([SCNAction.moveBy(x: 0, y: 0, z: 100, duration: 5), SCNAction.scale(by: 3, duration: 5)]))*/
 
 } else if self.isGameAdded && !self.isGameStarted{
 self.tap.removeTarget(self, action: #selector(ViewController.screenTappedCreate(sender:)))
 //            self.tap.addTarget(self, action: #selector(ViewController.screenTappedMove(sender:)))
 self.isGameStarted = true
 self.updateLabel()
 self.startGame()
 }
 
 }
 
 */

/*
 // Override to create and configure nodes for anchors added to the view's session.
 func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
 let node = SCNNode()
 
 return node
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
 */

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
