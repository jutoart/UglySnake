//
//  UglySnakeView.swift
//  UglySnake
//
//  Created by Art Huang on 05/03/2017.
//  Copyright © 2017 Art Huang. All rights reserved.
//

import UIKit

class UglySnakeView: UIView
{
    var blockSize: CGFloat = 0
    var snake = [Point]() { didSet { setNeedsDisplay() } }
    var fruit: Point!  { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        for view in subviews {
            view.removeFromSuperview()
        }
        
        if fruit != nil {
            let fruitView = getNewView(with: fruit)
            fruitView.backgroundColor = UIColor.green
            addSubview(fruitView)
        }
        
        for point in snake {
            let snakeBodyView = getNewView(with: point)
            
            if point == snake.first! {
                snakeBodyView.backgroundColor = UIColor.red
            }
            else {
                snakeBodyView.backgroundColor = UIColor.blue
            }
            
            addSubview(snakeBodyView)
        }
    }
    
    private func getNewView(with point: Point) -> UIView {
        let frame = CGRect(origin: CGPoint(x: CGFloat(point.x) * blockSize, y: CGFloat(point.y) * blockSize), size: CGSize(width: blockSize, height: blockSize))
        return UIView(frame: frame)
    }
}
