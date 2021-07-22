//
//  IndicatorView.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import Foundation
import UIKit


class IndicatorView: UIView {
    
    // MARK: - Initialization
    init(frame: CGRect,
         colors: [UIColor],
         lineWidth: CGFloat
    ) {
        self.colors = colors
        self.lineWidth = lineWidth
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    convenience init(colors: [UIColor], lineWidth: CGFloat) {
        self.init(frame: .zero, colors: colors, lineWidth: lineWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
        
        let path = UIBezierPath(ovalIn:
                                    CGRect(
                                        x: 0,
                                        y: 0,
                                        width: self.bounds.width,
                                        height: self.bounds.width
                                    )
        )
        
        shapeLayer.path = path.cgPath
    }
    
    // MARK: - Animations
   private func animateStroke() {
        
        let startAnimation = StrokeAnimation(
            type: .start,
            beginTime: 0.25,
            fromValue: 0.0,
            toValue: 1.0,
            duration: 0.75
        )
        
        let endAnimation = StrokeAnimation(
            type: .end,
            fromValue: 0.0,
            toValue: 1.0,
            duration: 0.75
        )
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1
        strokeAnimationGroup.repeatDuration = .infinity
        strokeAnimationGroup.animations = [startAnimation, endAnimation]
        
        shapeLayer.add(strokeAnimationGroup, forKey: nil)
        
        let colorAnimation = StrokeColorAnimation(
            colors: colors.map { $0.cgColor },
            duration: strokeAnimationGroup.duration * Double(colors.count)
        )
        
        shapeLayer.add(colorAnimation, forKey: nil)
        
        self.layer.addSublayer(shapeLayer)
    }
    
    private func animateRotation() {
        let rotationAnimation = RotationAnimation(
            direction: .z,
            fromValue: 0,
            toValue: CGFloat.pi * 2,
            duration: 2,
            repeatCount: .greatestFiniteMagnitude
        )
        
        self.layer.add(rotationAnimation, forKey: nil)
    }
    
    // MARK: - Properties
    let colors: [UIColor]
    let lineWidth: CGFloat
    
    private lazy var shapeLayer: ProgressShapeLayer = {
        return ProgressShapeLayer(strokeColor: colors.first!, lineWidth: lineWidth)
    }()
    
    private var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                self.animateStroke()
                self.animateRotation()
            } else {
                self.shapeLayer.removeFromSuperlayer()
                self.layer.removeAllAnimations()
            }
        }
    }
    
    func show()  {
        
        DispatchQueue.main.async { [self] in
         guard let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first else {return}
            window.addSubview(self)
            NSLayoutConstraint.activate([
                self.centerXAnchor
                    .constraint(equalTo: window.centerXAnchor),
                self.centerYAnchor
                    .constraint(equalTo: window.centerYAnchor),
                self.widthAnchor
                    .constraint(equalToConstant: 50),
                self.heightAnchor
                    .constraint(equalTo: self.widthAnchor)
            ])
            
            
            self.isAnimating = true
        }
    }
    
    func hide() {
        DispatchQueue.main.async { [self] in
            self.isAnimating = false
            self.removeFromSuperview()
        }
    }
    
}
