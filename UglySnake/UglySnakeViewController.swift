//
//  UglySnakeViewController.swift
//  UglySnake
//
//  Created by Art Huang on 05/03/2017.
//  Copyright © 2017 Art Huang. All rights reserved.
//

import UIKit

class UglySnakeViewController: UIViewController
{
    var boundary = Point(x: 0, y: 0)
    var snake = Snake()
    var fruit = Point(x: 0, y: 0) { didSet { updateUI() } }
    var gameTimer: Timer?
    var score = 0 {
        didSet {
            if scoreLabel != nil {
                scoreLabel.text = "Score: \(score)"
            }
        }
    }
    
    struct GameSettings {
        static let BlockSize: CGFloat = 20
        static let MovingTimeInterval = 0.4
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameView: UglySnakeView! {
        didSet {
            let direction: [UISwipeGestureRecognizerDirection] = [.up, .down, .left, .right]
            
            for swipe in direction {
                let turnGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(turn(recognizer:)))
                turnGestureRecognizer.direction = swipe
                gameView.addGestureRecognizer(turnGestureRecognizer)
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
            gameView.addGestureRecognizer(tapGestureRecognizer)
            
            gameView.blockSize = GameSettings.BlockSize
            updateUI()
        }
    }
    
    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if gameTimer != nil, gameTimer!.isValid {
                gameTimer?.invalidate()
            }
        }
    }
    
    func turn(recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case UISwipeGestureRecognizerDirection.up:
            if snake.direction == .left || snake.direction == .right {
                snake.direction = .up
            }
        case UISwipeGestureRecognizerDirection.down:
            if snake.direction == .left || snake.direction == .right {
                snake.direction = .down
            }
        case UISwipeGestureRecognizerDirection.left:
            if snake.direction == .up || snake.direction == .down {
                snake.direction = .left
            }
        case UISwipeGestureRecognizerDirection.right:
            if snake.direction == .up || snake.direction == .down {
                snake.direction = .right
            }
        default:
            break
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        boundary = Point(x: Int(gameView.frame.width / GameSettings.BlockSize), y: Int(gameView.frame.height / GameSettings.BlockSize))
        
        snake.boundary = boundary
        
        if snake.queue.isEmpty {
            snake.queue.append(getNewSnakeHead())
            fruit = getNewFruit()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    private func updateUI() {
        if gameView != nil {
            gameView.snake = snake.queue
            gameView.fruit = fruit
        }
    }
    
    private func getRandomPosition(with boundary: Point) -> Point {
        let x = Int(arc4random_uniform(UInt32(boundary.x)))
        let y = Int(arc4random_uniform(UInt32(boundary.y)))
        
        return Point(x: x, y: y)
    }
    
    private func getNewSnakeHead() -> Point {
        while true {
            let newSnakeHead = getRandomPosition(with: boundary)
            
            switch snake.direction {
            case .up:
                if newSnakeHead.y != 0 {
                    return newSnakeHead
                }
            case .down:
                if newSnakeHead.y != boundary.y - 1 {
                    return newSnakeHead
                }
            case .left:
                if newSnakeHead.x != 0 {
                    return newSnakeHead
                }
            case .right:
                if newSnakeHead.y != boundary.x - 1 {
                    return newSnakeHead
                }
            }
        }
    }
    
    private func getNewFruit() -> Point {
        var newFruit = getRandomPosition(with: boundary)
        
        while snake.isInSnakeBody(with: newFruit) {
            newFruit = getRandomPosition(with: boundary)
        }
        
        return newFruit
    }
    
    private func startTimer() {
        if gameTimer == nil {
            gameTimer = Timer.scheduledTimer(
                withTimeInterval: GameSettings.MovingTimeInterval,
                repeats: true) { [unowned self] timer in
                    if self.snake.willCollide(at: self.fruit) {
                        self.snake.grow()
                        self.fruit = self.getNewFruit()
                        self.score += 1
                    }
                    else {
                        if !self.snake.move() {
                            self.gameTimer?.invalidate()
                            self.gameTimer = nil
                            self.gameOver()
                        }
                    }
                    
                    self.updateUI()
            }
        }
    }
    
    private func gameOver() {
        let gameOverAlertController = UIAlertController(
            title: "GAME OVER",
            message: "Score: \(score)",
            preferredStyle: .alert
        )
        
        let restartAction = UIAlertAction(
            title: "Restart",
            style: .default) { alert in
                self.snake.queue.removeAll()
                self.snake.queue.append(self.getNewSnakeHead())
                self.fruit = self.getNewFruit()
                self.score = 0
                self.updateUI()
                self.startTimer()
        }
        
        gameOverAlertController.addAction(restartAction)
        present(gameOverAlertController, animated: true, completion: nil)
    }
}
