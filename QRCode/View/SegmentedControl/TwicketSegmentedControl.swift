//
//  TwicketSegmentedControl.swift
//  TwicketSegmentedControlDemo
//
//  Created by Pol Quintana on 7/11/15.
//  Copyright © 2015 Pol Quintana. All rights reserved.
//

import UIKit

public protocol TwicketSegmentedControlDelegate: class {
    func didSelect(_ segmentIndex: Int)
}

open class TwicketSegmentedControl: UIControl {
    open static let height: CGFloat = Constants.height + Constants.topBottomMargin * 2

    fileprivate struct Constants {
        static let height: CGFloat = 55
        static let topBottomMargin: CGFloat = 0
        static let leadingTrailingMargin: CGFloat = 0
    }

    class SliderView: UIView {
        // MARK: - Properties
        fileprivate let sliderMaskView = UIView()
        
        var cornerRadius: CGFloat! {
            didSet {
                layer.cornerRadius = 0
                sliderMaskView.layer.cornerRadius = 0
            }
        }

        override var frame: CGRect {
            didSet {
                sliderMaskView.frame = frame
            }
        }

        override var center: CGPoint {
            didSet {
                sliderMaskView.center = center
            }
        }

        init() {
            super.init(frame: .zero)
            setup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }

        private func setup() {
            layer.masksToBounds = true
            sliderMaskView.backgroundColor = .black
            sliderMaskView.addShadow(with: .black)
        }
    }

    open weak var delegate: TwicketSegmentedControlDelegate?

    open var defaultTextColor: UIColor = Palette.defaultTextColor {
        didSet {
            updateLabelsColor(with: defaultTextColor, selected: false)
        }
    }

    open var highlightTextColor: UIColor = Palette.highlightTextColor {
        didSet {
            updateLabelsColor(with: highlightTextColor, selected: true)
        }
    }

    open var segmentsBackgroundColor: UIColor = Palette.segmentedControlBackgroundColor {
        didSet {
            backgroundView.backgroundColor = backgroundColor
        }
    }

    open var sliderBackgroundColor: UIColor = Palette.sliderColor {
        didSet {
            selectedContainerView.backgroundColor = sliderBackgroundColor
        }
    }

    open var font: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            updateLabelsFont(with: font)
        }
    }

    private(set) open var selectedSegmentIndex: Int = 0

    fileprivate var segments: [String] = []
    fileprivate var segmentImages: [UIImage] = []


    fileprivate var numberOfSegments: Int {
        return segments.count
    }
    
    fileprivate var numberOfSegmentImages: Int {
        return segmentImages.count
    }

    fileprivate var segmentWidth: CGFloat {
        if numberOfSegments == 0 {
            return self.backgroundView.frame.width / CGFloat(numberOfSegmentImages)
        }
        return self.backgroundView.frame.width / CGFloat(numberOfSegments)
    }

    fileprivate var correction: CGFloat = 0

    fileprivate lazy var containerView: UIView = UIView()
    fileprivate lazy var backgroundView: UIView = UIView()
    fileprivate lazy var selectedContainerView: UIView = UIView()
    fileprivate lazy var sliderView: SliderView = SliderView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    fileprivate func setup() {
        addSubview(containerView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedContainerView)
        containerView.addSubview(sliderView)

        selectedContainerView.layer.mask = sliderView.sliderMaskView.layer
        addTapGesture()
        addDragGesture()
    }

    open func setSegmentItems(_ segments: [String]) {
        guard !segments.isEmpty else { fatalError("Segments array cannot be empty") }

        self.segments = segments
        configureViews()

        clearLabels()

        for (index, title) in segments.enumerated() {
            let baseLabel = createLabel(with: title, at: index, selected: false)
            let selectedLabel = createLabel(with: title, at: index, selected: true)
            backgroundView.addSubview(baseLabel)
            selectedContainerView.addSubview(selectedLabel)
        }

        setupAutoresizingMasks()
    }
    
    
    open func setSegmentImageItems(_ segments: [UIImage]) {
        guard !segments.isEmpty else { fatalError("SegmentImages array cannot be empty") }
        
        self.segmentImages = segments
        configureViews()
        
        clearLabels()
        
        for (index, image) in segments.enumerated() {
            let baseImageView = createImage(with: image, at: index, selected: false)
            let selectedImageView = createImage(with: image, at: index, selected: true)
            backgroundView.addSubview(baseImageView)
            selectedContainerView.addSubview(selectedImageView)
        }
        setupAutoresizingMasks()
    }

    fileprivate func configureViews() {
        containerView.frame = CGRect(x: Constants.leadingTrailingMargin,
                                     y: Constants.topBottomMargin,
                                     width: bounds.width - Constants.leadingTrailingMargin * 2,
                                     height: Constants.height)
        let frame = containerView.bounds
        backgroundView.frame = frame
        selectedContainerView.frame = frame
        sliderView.frame = CGRect(x: 0, y: 0, width:segmentWidth , height: backgroundView.frame.height)

//        let cornerRadius = backgroundView.frame.height / 2
//        [backgroundView, selectedContainerView].forEach { $0.layer.cornerRadius = 0 }
//        sliderView.cornerRadius = 0
        backgroundColor = .white
        
        backgroundView.backgroundColor = segmentsBackgroundColor
        selectedContainerView.backgroundColor = sliderBackgroundColor
        selectedContainerView.addShadow(with: sliderBackgroundColor)
    }

    fileprivate func setupAutoresizingMasks() {
        containerView.autoresizingMask = [.flexibleWidth]
        backgroundView.autoresizingMask = [.flexibleWidth]
        selectedContainerView.autoresizingMask = [.flexibleWidth]
        sliderView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
    }

    // MARK: Labels

    fileprivate func clearLabels() {
        backgroundView.subviews.forEach { $0.removeFromSuperview() }
        selectedContainerView.subviews.forEach { $0.removeFromSuperview() }
    }

    fileprivate func createLabel(with text: String, at index: Int, selected: Bool) -> UILabel {
        let rect = CGRect(x: CGFloat(index) * segmentWidth, y: 0, width: segmentWidth, height: backgroundView.frame.height)
        let label = UILabel(frame: rect)
        label.text = text
        label.textAlignment = .center
        label.textColor = selected ? highlightTextColor : defaultTextColor
        label.font = font
        label.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        return label
    }
    
    fileprivate func createImage(with image: UIImage, at index: Int, selected: Bool) -> UIImageView {
        let rect = CGRect(x: CGFloat(index) * segmentWidth, y: 5, width: segmentWidth, height: backgroundView.frame.height-15)
        let imageView = UIImageView(frame: rect)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        return imageView
    }

    fileprivate func updateLabelsColor(with color: UIColor, selected: Bool) {
        let containerView = selected ? selectedContainerView : backgroundView
        containerView.subviews.forEach { ($0 as? UILabel)?.textColor = color }
    }

    fileprivate func updateLabelsFont(with font: UIFont) {
        selectedContainerView.subviews.forEach { ($0 as? UILabel)?.font = font }
        backgroundView.subviews.forEach { ($0 as? UILabel)?.font = font }
    }

    // MARK: Tap gestures

    fileprivate func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }

    fileprivate func addDragGesture() {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        sliderView.addGestureRecognizer(drag)
    }

    @objc fileprivate func didTap(tapGesture: UITapGestureRecognizer) {
        moveToNearestPoint(basedOn: tapGesture)
    }

    @objc fileprivate func didPan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .cancelled, .ended, .failed:
            moveToNearestPoint(basedOn: panGesture, velocity: panGesture.velocity(in: sliderView))
        case .began:
            correction = panGesture.location(in: sliderView).x - sliderView.frame.width/2
        case .changed:
            let location = panGesture.location(in: self)
            sliderView.center.x = location.x - correction
        case .possible: ()
        }
    }

    // MARK: Slider position

    fileprivate func moveToNearestPoint(basedOn gesture: UIGestureRecognizer, velocity: CGPoint? = nil) {
        var location = gesture.location(in: self)
        if let velocity = velocity {
            let offset = velocity.x / 12
            location.x += offset
        }
        let index = segmentIndex(for: location)
        move(to: index)
        delegate?.didSelect(index)
    }

    open func move(to index: Int) {
        let correctOffset = center(at: index)
        animate(to: correctOffset)

        selectedSegmentIndex = index
    }

    fileprivate func segmentIndex(for point: CGPoint) -> Int {
        var index = Int(point.x / sliderView.frame.width)
        if index < 0 { index = 0 }
        
        if numberOfSegments == 0 {
            if index > numberOfSegmentImages - 1 { index = numberOfSegmentImages - 1 }
        }
        else
        {
            if index > numberOfSegments - 1 { index = numberOfSegments - 1 }
        }
        
        return index
    }

    fileprivate func center(at index: Int) -> CGFloat {
        let xOffset = CGFloat(index) * sliderView.frame.width + sliderView.frame.width / 2
        return xOffset
    }

    fileprivate func animate(to position: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.sliderView.center.x = position
        }
    }
}
