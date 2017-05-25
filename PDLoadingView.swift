//
//  PDLoadingView.swift
//
//  Created by Paolo Di Lorenzo on 4/27/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

class PDLoadingView: UIView {

  private struct LocalConstants {
    static let strokeStartKeyPath = "strokeStart"
    static let strokeEndKeyPath = "strokeEnd"
    static let rotationKeyPath = "transform.rotation.z"

    static let radiusScale: CGFloat = 0.6
    static let circleLineWidth: CGFloat = 5
    static let padding: CGFloat = 4
  }

  private var radius: CGFloat {
    return bounds.width / 2 * LocalConstants.radiusScale
  }

  private var circleLayer = CAShapeLayer()

  private var strokeStartAnimation: CABasicAnimation?
  private var strokeEndAnimation: CABasicAnimation?
  private var rotationAnimation: CABasicAnimation?

  var foreColor: UIColor

  var isPaused: Bool {
    return strokeStartAnimation != nil && circleLayer.speed == 0
  }

  lazy var messageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = self.foreColor
    label.textAlignment = .center
    label.sizeToFit()
    return label
  }()

  // MARK: - Initializer

  init(foreColor: UIColor) {
    self.foreColor = foreColor
    super.init(frame: .zero)

    backgroundColor = Constants.Colors.mainBackgroundColor
    alpha = 0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life Cycle

  override func layoutSubviews() {
    super.layoutSubviews()

    addSubview(messageLabel)
    messageLabel.anchor(left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstant: LocalConstants.padding, rightConstant: LocalConstants.padding, bottomConstant: LocalConstants.padding)

    layer.cornerRadius = 10

    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = .zero
    layer.shadowOpacity = 0.5
    layer.shadowRadius = bounds.width * 1.5
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
  }

  // MARK: - View Elements

  private func setupView() {
    circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius), cornerRadius: radius).cgPath
    circleLayer.position = CGPoint(x: bounds.midX - radius, y: messageLabel.frame.origin.y / 2 - radius)

    circleLayer.strokeColor = foreColor.cgColor
    circleLayer.fillColor = UIColor.clear.cgColor
    circleLayer.lineWidth = LocalConstants.circleLineWidth
    circleLayer.lineCap = kCALineCapRound

    circleLayer.strokeStart = 0
    circleLayer.strokeEnd = 0

    circleLayer.frame = CGRect(origin: circleLayer.position, size: circleLayer.path?.boundingBox.size ?? .zero)

    layer.addSublayer(circleLayer)
  }

  private func set(message: String) {
    messageLabel.text = message
    messageLabel.sizeToFit()
  }

  // MARK: - Loading Flow

  func start(with message: String) {
    set(message: message)
    UIView.animate(withDuration: 0.25) { self.alpha = 1 }

    setupView()
    addAnimations(to: circleLayer)
  }

  func pause() {
    pause(layer: circleLayer)
  }

  func resume() {
    resume(layer: circleLayer)
  }

  func end() {
    removeAnimation(with: LocalConstants.strokeStartKeyPath, in: circleLayer)
    removeAnimation(with: LocalConstants.strokeEndKeyPath, in: circleLayer)
    removeAnimation(with: LocalConstants.rotationKeyPath, in: circleLayer)

    strokeStartAnimation = nil
    strokeEndAnimation = nil
    rotationAnimation = nil

    circleLayer.removeFromSuperlayer()
    circleLayer = CAShapeLayer()

    UIView.animate(withDuration: 0.25) { self.alpha = 0 }
  }

  // MARK: - Animation Control

  private func addAnimations(to layer: CAShapeLayer) {
    strokeStartAnimation = CABasicAnimation(keyPath: LocalConstants.strokeStartKeyPath)
    strokeStartAnimation?.fromValue = 0
    layer.strokeStart = 1
    strokeStartAnimation?.duration = 1
    strokeStartAnimation?.repeatCount = .greatestFiniteMagnitude
    strokeStartAnimation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    strokeStartAnimation?.fillMode = kCAFillModeForwards

    strokeEndAnimation = CABasicAnimation(keyPath: LocalConstants.strokeEndKeyPath)
    strokeEndAnimation?.fromValue = 0
    layer.strokeEnd = layer.strokeStart + 0.5
    strokeEndAnimation?.duration = 1
    strokeEndAnimation?.repeatCount = .greatestFiniteMagnitude
    strokeEndAnimation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    strokeEndAnimation?.fillMode = kCAFillModeForwards

    rotationAnimation = CABasicAnimation(keyPath: LocalConstants.rotationKeyPath)
    rotationAnimation?.fromValue = 0
    rotationAnimation?.toValue = Float.pi * 2
    rotationAnimation?.duration = 2
    rotationAnimation?.repeatCount = .greatestFiniteMagnitude

    if let start = strokeStartAnimation, let end = strokeEndAnimation, let rotation = rotationAnimation {
      layer.add(start, forKey: LocalConstants.strokeStartKeyPath)
      layer.add(end, forKey: LocalConstants.strokeEndKeyPath)
      layer.add(rotation, forKey: LocalConstants.rotationKeyPath)
    }
  }

  private func resume(layer: CAShapeLayer) {
    let pausedTime = layer.timeOffset

    layer.speed = 1
    layer.timeOffset = 0
    layer.beginTime = 0

    let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    layer.beginTime = timeSincePause
  }

  private func pause(layer: CAShapeLayer) {
    let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)

    layer.speed = 0
    layer.timeOffset = pausedTime
  }

  private func removeAnimation(with keyPath: String, in layer: CAShapeLayer) {
    pause(layer: layer)
    layer.removeAnimation(forKey: keyPath)
  }

}
