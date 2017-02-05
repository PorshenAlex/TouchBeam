//
//  DrawingView.swift
//  TouchBeam
//
//  Created by a.tyurin on 05/02/2017.
//  Copyright © 2017 a.tyurin. All rights reserved.
//

import UIKit

let numberOfSegments = 4
let colors:Array<UIColor> = [UIColor.blue, UIColor.red, UIColor.green, UIColor.brown, UIColor.purple,
                             UIColor.magenta, UIColor.yellow, UIColor.black, UIColor.darkGray, UIColor.orange]

class DrawingView: UIView {
    var touchPoints:Array<CGPoint> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        var lineNumber = 0
        while lineNumber < touchPoints.count {
            let location = touchPoints[lineNumber]
            
            let size = UIScreen.main.bounds.size
            
            var startPoint = CGPoint(x: size.width/2, y: size.height/2)
            var endPoint = location
            
            var points = Array<CGPoint>()
            var pointNumber = 0
            
            while pointNumber < numberOfSegments {
                var angle = asin((startPoint.y - endPoint.y)/(sqrt(pow(startPoint.x - endPoint.x, 2) + pow(startPoint.y - endPoint.y,2))))
                
                if endPoint.x < startPoint.x {
                    angle = CGFloat.pi - angle
                } else {
                    angle = 2*CGFloat.pi + angle
                }
                let point = endPointOfLine(startPoint: startPoint, angle: angle)
                endPoint = point
                points.append(point)
                if endPoint.x == 0 || endPoint.x == size.width {
                    startPoint.y = 2 * endPoint.y - startPoint.y
                } else {
                    startPoint.x = 2 * endPoint.x - startPoint.x
                }
                let swapPoint = startPoint
                startPoint = endPoint
                endPoint = swapPoint
                
                pointNumber = pointNumber + 1
            }
            drawLine(points: points, color: colors[lineNumber])
            
            lineNumber = lineNumber + 1
        }
    }
    
    func drawLine(points: Array<CGPoint>, color: UIColor) {
        
        let path = UIBezierPath()
        let size = UIScreen.main.bounds.size
        path.move(to: CGPoint(x: size.width/2, y: size.height/2))
        
        var index = 0
        while index < points.count {
            path.addLine(to: points[index])
            index = index + 1
        }
        color.setStroke()
        path.stroke()
    }
    
    func endPointOfLine(startPoint: CGPoint, angle: CGFloat) -> CGPoint {
        let size = UIScreen.main.bounds.size
        let top = sin(angle) > 0
        let left = cos(angle) < 0
        
        
        let height = top ? startPoint.y : size.height - startPoint.y
        let width = left ? startPoint.x : size.width - startPoint.x
        
        let endPoint:CGPoint
        if fabs(tan(angle)) > fabs(height/width) {
            let offset = height / fabs(tan(angle))
            endPoint = CGPoint(x: left ? (width - offset) : (offset + startPoint.x),
                               y: top ? 0 : size.height)
        } else {
            let offset = width * fabs(tan(angle))
            endPoint = CGPoint(x: left ? 0 : size.width,
                               y: top ? (height - offset) : (offset + startPoint.y))
        }
        return endPoint
    }
}
