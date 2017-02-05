//
//  ViewController.swift
//  TouchBeam
//
//  Created by a.tyurin on 04/02/2017.
//  Copyright © 2017 a.tyurin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var drawingView: DrawingView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDrawingView()
    }
    
    func setupDrawingView() {
        drawingView = DrawingView(frame: self.view.frame)
        drawingView.isMultipleTouchEnabled = true
        view.addSubview(drawingView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.drawingView.touchPoints.append(contentsOf: touches.map { (touch) -> CGPoint in
            touch.location(in: drawingView)
        })
        drawingView.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var newPoints = Array<CGPoint>()
        for point in drawingView.touchPoints {
            var newValue = false
            for touch in touches {
                if point == touch.previousLocation(in: drawingView) {
                    newPoints.append(touch.location(in: drawingView))
                    newValue = true
                    continue
                }
            }
            if !newValue {
                newPoints.append(point)
            }
        }
        drawingView.touchPoints = newPoints
        drawingView.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            if drawingView.touchPoints.contains(touch.location(in: drawingView)) {
                drawingView.touchPoints.remove(at: drawingView.touchPoints.index(of: touch.location(in: drawingView))!)
            }
            if drawingView.touchPoints.contains(touch.previousLocation(in: drawingView)) {
                drawingView.touchPoints.remove(at: drawingView.touchPoints.index(of: touch.previousLocation(in: drawingView))!)
            }
        }
        drawingView.setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.drawingView.touchPoints = []
        drawingView.setNeedsDisplay()
    }
}

