//
//  Point.swift
//  UglySnake
//
//  Created by Art Huang on 05/03/2017.
//  Copyright © 2017 Art Huang. All rights reserved.
//

struct Point
{
    var x: Int
    var y: Int
    
    func outOfBoundary(at boundary: Point) -> Bool {
        if x >= boundary.x || y >= boundary.y || x < 0 || y < 0 {
            return true
        }
        else {
            return false
        }
    }
}

extension Point: Equatable {
    static func ==(lhs: Point, rhs: Point) -> Bool {
        if lhs.x == rhs.x && lhs.y == rhs.y {
            return true
        }
        else {
            return false
        }
    }
}
