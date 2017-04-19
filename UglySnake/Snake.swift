//
//  Snake.swift
//  UglySnake
//
//  Created by Art Huang on 05/03/2017.
//  Copyright © 2017 Art Huang. All rights reserved.
//

class Snake
{
    var queue = [Point]()
    var direction = Direction.right
    var boundary = Point(x: 0, y: 0)
    
    enum Direction {
        case up
        case down
        case left
        case right
    }
    
    func move() -> Bool {
        let newHead = getNextHead()
        
        if newHead.outOfBoundary(at: boundary) {
            return false
        }
        else {
            for point in queue {
                if point == newHead {
                    return false
                }
            }
            
            _ = queue.removeLast()
            queue.insert(newHead, at: 0)
            return true
        }
    }
    
    func grow() {
        queue.insert(getNextHead(), at: 0)
    }
    
    func willCollide(at point: Point) -> Bool {
        return getNextHead() == point ? true : false
    }
    
    func isInSnakeBody(with point: Point) -> Bool {
        return queue.filter { $0 == point }.count > 0 ? true : false
    }
    
    private func getNextHead() -> Point {
        var newHead = queue.first!
        
        switch direction {
        case .up:
            newHead.y -= 1
        case .down:
            newHead.y += 1
        case .left:
            newHead.x -= 1
        case .right:
            newHead.x += 1
        }
        
        return newHead
    }
}
