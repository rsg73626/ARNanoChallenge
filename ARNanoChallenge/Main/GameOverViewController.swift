//
//  GameOverViewController.swift
//  ARNanoChallenge
//
//  Created by Renan Germano on 01/03/2018.
//  Copyright © 2018 Renan Germano. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let score = self.score {
            self.scoreLabel.text = "\(score)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAgainButtonTapped(_ sender: UIButton) {
        guard let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Game") as? ViewController else { return }
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        guard let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu") as? MenuViewController else { return }
        self.present(viewController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
