//
//  AAPoint.swift
//  Test
//
//  Created by Fxxx on 2018/11/30.
//  Copyright © 2018 Aaron Feng. All rights reserved.
//
import UIKit

struct AAPoint {
    
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
    
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        (self.x, self.y, self.z) = (x, y, z)
    }
    
    mutating func rotate(translation: CGPoint) {
        
        guard translation.x != 0 || translation.y != 0 else {
            return
        }
        
        let translation = CGPoint.init(x: -translation.y, y: translation.x)
        var temp = Array.init(repeating: Array.init(repeating: 0.0, count: 4), count: 4)
        temp[0] = [Double(self.x), Double(self.y), Double(self.z), 1.0]
        
        var result: Matrix = Matrix.init(temp)
        if translation.y != 0 {
            
            let cos1 = Double(0)
            let sin1 = translation.y > 0 ? 1.0 : -1.0
            let t1 = [[1, 0, 0, 0], [0, cos1, sin1, 0], [0, -sin1, cos1, 0], [0, 0, 0, 1]]
            result *= Matrix.init(t1)
            
        }
        
        if pow(translation.x, 2) + pow(translation.y, 2) != 0 {
            
            let cos2 = abs(translation.y) / sqrt(pow(translation.x, 2) + pow(translation.y, 2))
            let sin2 = -translation.x / sqrt(pow(translation.x, 2) + pow(translation.y, 2))
            let t2 = [[Double(cos2), 0, Double(-sin2), 0], [0, 1, 0, 0], [Double(sin2), 0, Double(cos2), 0], [0, 0, 0, 1]]
            result *= Matrix.init(t2)
            
        }
        
        let cos3 = Double(cos(sqrt(pow(translation.x, 2) + pow(translation.y, 2))))
        let sin3 = Double(sin(sqrt(pow(translation.x, 2) + pow(translation.y, 2))))
        let t3 = [[cos3, sin3, 0, 0], [-sin3, cos3, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
        result *= Matrix.init(t3)
        
        if pow(translation.x, 2) + pow(translation.y, 2) != 0 {
            
            let cos2 = abs(translation.y) / sqrt(pow(translation.x, 2) + pow(translation.y, 2))
            let sin2 = -translation.x / sqrt(pow(translation.x, 2) + pow(translation.y, 2))
            let t2 = [[Double(cos2), 0, Double(sin2), 0], [0, 1, 0, 0], [Double(-sin2), 0, Double(cos2), 0], [0, 0, 0, 1]]
            result *= Matrix.init(t2)
            
        }
        
        if translation.y != 0 {
            
            let cos1 = Double(0)
            let sin1 = translation.y > 0 ? 1.0 : -1.0
            let t1 = [[1, 0, 0, 0], [0, cos1, -sin1, 0], [0, sin1, cos1, 0], [0, 0, 0, 1]]
            result *= Matrix.init(t1)
            
        }
        
        x = CGFloat(result[0, 0])
        y = CGFloat(result[0, 1])
        z = CGFloat(result[0, 2])
        
    }
    
}
