//
//  UIAdvancedSegmentedControl.swift
//  CovidTracker
//
//  Created by Steven Syp on 19/03/2021.
//

import UIKit

public class UIAdvancedSegmentedControl: UIControl {

	fileprivate var labels = [UILabel]()
	private lazy var thumbView: UIView = {
		let view = UIView()
		view.backgroundColor = .secondarySystemFill
		view.layer.cornerCurve = .continuous
		view.layer.cornerRadius = (frame.height - padding * 2) / 3
		view.layer.shadowRadius = 2
		view.layer.shadowOpacity = 0.08
		view.layer.shadowColor = UIColor.darkGray.cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: 1)
		return view
	}()

	public var items: [String] = ["Item 1", "Item 2", "Item 3"] {
		didSet { if !items.isEmpty { setupLabels() }}
	}

	public var selectedIndex: Int = 0 {
		didSet { displayNewSelectedIndex() }
	}

	public var selectedLabelColor: UIColor = .label {
		didSet { setSelectedColors() }
	}

	public var unselectedLabelColor: UIColor = .secondaryLabel {
		didSet { setSelectedColors() }
	}

	public var thumbColor: UIColor = .tertiarySystemBackground {
		didSet { setSelectedColors() }
	}

	public var font: UIFont? = .systemFont(ofSize: 15, weight: .medium) {
		didSet { labels.forEach { $0.font = font } }
	}

	public var padding: CGFloat = 4 {
		didSet { setupLabels() }
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init(coder: NSCoder) {
		super.init(coder: coder)!
		setupView()
	}

	private func setupView() {
		layer.cornerCurve = .continuous
		layer.cornerRadius = frame.height / 3
		backgroundColor = .secondarySystemBackground
		insertSubview(thumbView, at: 0)
		setupLabels()
	}

	private func setupLabels() {
		labels.forEach { $0.removeFromSuperview() }
		labels.removeAll(keepingCapacity: true)

		for index in 1...items.count {
			let label = UILabel()
			label.text = items[index - 1]
			label.backgroundColor = .clear
			label.textAlignment = .center
			label.font = font
			label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
			label.translatesAutoresizingMaskIntoConstraints = false
			addSubview(label)
			labels.append(label)
		}

		addIndividualItemConstraints(labels, mainView: self)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		if !labels.isEmpty {
			let label = labels[selectedIndex]
			label.textColor = selectedLabelColor
			thumbView.frame = label.frame
			displayNewSelectedIndex()
		}
	}

	public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		let location = touch.location(in: self)
		var calculatedIndex : Int?
		labels.enumerated().forEach { (index, item) in
			if item.frame.contains(location) { calculatedIndex = index }
		}

		if let calculatedIndex = calculatedIndex {
			selectedIndex = calculatedIndex
			sendActions(for: .valueChanged)
		}

		return false
	}

	private func displayNewSelectedIndex() {
		labels.enumerated().forEach { (index, item) in
			item.textColor = index == selectedIndex ? selectedLabelColor : unselectedLabelColor
		}
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
			self.thumbView.frame = self.labels[self.selectedIndex].frame
		}, completion: nil)
	}

	private func addIndividualItemConstraints(_ items: [UIView], mainView: UIView) {
		for (index, button) in items.enumerated() {
			button.topAnchor.constraint(equalTo: mainView.topAnchor, constant: padding).isActive = true
			button.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -padding).isActive = true

			if index == 0 {
				button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: padding).isActive = true
			} else {
				let prevButton: UIView = items[index - 1]
				let firstItem: UIView = items[0]
				button.leadingAnchor.constraint(equalTo: prevButton.trailingAnchor, constant: padding).isActive = true
				button.widthAnchor.constraint(equalTo: firstItem.widthAnchor).isActive = true
			}

			if index == items.count - 1 {
				button.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -padding).isActive = true
			} else {
				let nextButton: UIView = items[index + 1]
				button.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -padding).isActive = true
			}
		}
	}

	private func setSelectedColors() {
		labels.forEach { $0.textColor = unselectedLabelColor }
		if !labels.isEmpty { labels[0].textColor = selectedLabelColor }
	}
}
