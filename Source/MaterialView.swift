//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

public class MaterialView : UIView {
	//
	//	:name:	visualLayer
	//
	public private(set) lazy var visualLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	image
	*/
	public var image: UIImage? {
		didSet {
			visualLayer.contents = image?.CGImage
		}
	}
	
	/**
		:name:	contentsRect
	*/
	public var contentsRect: CGRect! {
		didSet {
			visualLayer.contentsRect = nil == contentsRect ? CGRectMake(0, 0, 1, 1) : contentsRect!
		}
	}
	
	/**
		:name:	contentsCenter
	*/
	public var contentsCenter: CGRect! {
		didSet {
			visualLayer.contentsCenter = nil == contentsCenter ? CGRectMake(0, 0, 1, 1) : contentsCenter!
		}
	}
	
	/**
		:name:	contentsScale
	*/
	public var contentsScale: CGFloat! {
		didSet {
			visualLayer.contentsScale = nil == contentsScale ? UIScreen.mainScreen().scale : contentsScale!
		}
	}
	
	/**
		:name:	contentsGravity
	*/
	public var contentsGravity: MaterialGravity! {
		didSet {
			visualLayer.contentsGravity = MaterialGravityToString(nil == contentsGravity ? .ResizeAspectFill : contentsGravity!)
		}
	}
	
	/**
		:name:	backgroundColor
	*/
	public override var backgroundColor: UIColor? {
		get {
			return nil == visualLayer.backgroundColor ? nil : UIColor(CGColor: visualLayer.backgroundColor!)
		}
		set(value) {
			visualLayer.backgroundColor = value?.CGColor
		}
	}
	
	/**
		:name:	x
	*/
	public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/**
		:name:	y
	*/
	public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
		}
	}
	
	/**
		:name:	width
	*/
	public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
			if nil != shape {
				layer.frame.size.height = value
			}
		}
	}
	
	/**
		:name:	height
	*/
	public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
			if nil != shape {
				layer.frame.size.width = value
			}
		}
	}
	
	/**
		:name:	shadowColor
	*/
	public var shadowColor: UIColor! {
		didSet {
			layer.shadowColor = nil == shadowColor ? MaterialColor.clear.CGColor : shadowColor!.CGColor
		}
	}
	
	/**
		:name:	shadowOffset
	*/
	public var shadowOffset: CGSize! {
		didSet {
			layer.shadowOffset = nil == shadowOffset ? CGSizeMake(0, 0) : shadowOffset!
		}
	}
	
	/**
		:name:	shadowOpacity
	*/
	public var shadowOpacity: Float! {
		didSet {
			layer.shadowOpacity = nil == shadowOpacity ? 0 : shadowOpacity!
		}
	}
	
	/**
		:name:	shadowRadius
	*/
	public var shadowRadius: CGFloat! {
		didSet {
			layer.shadowRadius = nil == shadowRadius ? 0 : shadowRadius!
		}
	}
	
	/**
		:name:	masksToBounds
	*/
	public var masksToBounds: Bool! {
		didSet {
			visualLayer.masksToBounds = nil == masksToBounds ? false : masksToBounds!
		}
	}
	
	/**
		:name:	cornerRadius
	*/
	public var cornerRadius: MaterialRadius! {
		didSet {
			layer.cornerRadius = MaterialRadiusToValue(nil == cornerRadius ? .None : cornerRadius!)
			if .Circle == shape {
				shape = nil
			}
		}
	}
	
	/**
		:name:	shape
	*/
	public var shape: MaterialShape? {
		didSet {
			if nil != shape {
				if width < height {
					layer.frame.size.width = height
				} else {
					layer.frame.size.height = width
				}
			}
		}
	}
	
	/**
		:name:	borderWidth
	*/
	public var borderWidth: MaterialBorder! {
		didSet {
			layer.borderWidth = MaterialBorderToValue(nil == borderWidth ? .None : borderWidth!)
		}
	}
	
	/**
		:name:	borderColor
	*/
	public var borderColor: UIColor! {
		didSet {
			layer.borderColor = nil == borderColor ? MaterialColor.clear.CGColor : borderColor!.CGColor
		}
	}
	
	/**
		:name:	shadowDepth
	*/
	public var shadowDepth: MaterialDepth! {
		didSet {
			let value: MaterialDepthType = MaterialDepthToValue(nil == shadowDepth ? .None : shadowDepth!)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
		}
	}
	
	/**
		:name:	position
	*/
	public var position: CGPoint {
		get {
			return layer.position
		}
		set(value) {
			layer.position = value
		}
	}
	
	/**
		:name:	zPosition
	*/
	public var zPosition: CGFloat! {
		didSet {
			layer.zPosition = zPosition
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/**
		:name:	layerClass
	*/
	public override class func layerClass() -> AnyClass {
		return CAShapeLayer.self
	}
	
	/**
		:name:	layoutSubviews
	*/
	public override func layoutSubviews() {
		super.layoutSubviews()
		prepareShape()
		
		visualLayer.frame = bounds
		visualLayer.cornerRadius = layer.cornerRadius
	}
	
	/**
		:name:	animation
	*/
	public func animation(animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == layer.presentationLayer() ? layer : layer.presentationLayer() as! CALayer).valueForKeyPath(a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			layer.addAnimation(a, forKey: a.keyPath!)
			if true == filterAnimations(a) {
				visualLayer.addAnimation(a, forKey: a.keyPath!)
			}
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			layer.addAnimation(a, forKey: nil)
			filterAnimations(a)
			visualLayer.addAnimation(a, forKey: nil)
		}
	}
	
	/**
		:name:	animationDidStart
	*/
	public override func animationDidStart(anim: CAAnimation) {}
	
	/**
		:name:	animationDidStop
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				CATransaction.begin()
				CATransaction.setDisableActions(true)
				layer.setValue(nil == b.toValue ? b.byValue : b.toValue, forKey: b.keyPath!)
				CATransaction.commit()
			}
			layer.removeAnimationForKey(a.keyPath!)
			visualLayer.removeAnimationForKey(a.keyPath!)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
	}
	
	//
	//	:name:	filterAnimations
	//
	internal func filterAnimations(animation: CAAnimation) -> Bool? {
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			return "position" != a.keyPath
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			for var i: Int = a.animations!.count - 1; 0 <= i; --i {
				if false == filterAnimations(a.animations![i]) {
					a.animations!.removeAtIndex(i)
				}
			}
		}
		return nil
	}
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		userInteractionEnabled = MaterialTheme.view.userInteractionEnabled
		backgroundColor = MaterialTheme.view.backgroundColor

		contentsRect = MaterialTheme.view.contentsRect
		contentsCenter = MaterialTheme.view.contentsCenter
		contentsScale = MaterialTheme.view.contentsScale
		contentsGravity = MaterialTheme.view.contentsGravity
		shadowDepth = MaterialTheme.view.shadowDepth
		shadowColor = MaterialTheme.view.shadowColor
		zPosition = MaterialTheme.view.zPosition
		masksToBounds = MaterialTheme.view.masksToBounds
		cornerRadius = MaterialTheme.view.cornerRadius
		borderWidth = MaterialTheme.view.borderWidth
		borderColor = MaterialTheme.view.bordercolor
		
		// visualLayer
		visualLayer.zPosition = -1
		layer.addSublayer(visualLayer)
	}
	
	//
	//	:name:	prepareShape
	//
	internal func prepareShape() {
		if .Circle == shape {
			layer.cornerRadius = width / 2
		}
	}
}

