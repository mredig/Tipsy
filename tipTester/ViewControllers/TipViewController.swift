//
//  ViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 6/2/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UITextFieldDelegate {

	var logic: CalculatorLogic?
	let themeHelper = ThemeHelper()
	var previousTip: String?
	let clearValue = "$0.00"
//	var cardViewController: CardViewController!

	@IBOutlet weak var tipsyTitleLabel: UILabel!
	@IBOutlet var totalBillTextField: UITextField!
	@IBOutlet var totalBillErrorLabel: UILabel!
	@IBOutlet var tipTextField: UITextField!
	@IBOutlet var tipErrorLabel: UILabel!
	@IBOutlet var calcButton: UIButton!
	@IBOutlet var tipOutputLabel: UILabel!
	@IBOutlet var totalOutputLabel: UILabel!
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet var totalInputView: UIView!
	@IBOutlet weak var tipInputView: UIView!
	@IBOutlet weak var dollarSymbol: UILabel!
	@IBOutlet weak var percentSymbol: UILabel!
	@IBOutlet weak var billAmountLabel: UILabel!
	@IBOutlet weak var tipPercentLabel: UILabel!
	@IBOutlet weak var quickTipLabel: UILabel!
	@IBOutlet weak var tipAmountLabel: UILabel!
	@IBOutlet weak var totalWithTipLabel: UILabel!
	@IBOutlet weak var firstEmoji: UIButton!
	@IBOutlet weak var twoPercentLabel: UILabel!
	@IBOutlet weak var secondEmoji: UIButton!
	@IBOutlet weak var fifteenPercentLabel: UILabel!
	@IBOutlet weak var thirdEmoji: UIButton!
	@IBOutlet weak var twentyPercentLabel: UILabel!
	@IBOutlet weak var fourthEmoji: UIButton!
	@IBOutlet weak var twentyFivePercentLabel: UILabel!
	@IBOutlet weak var emojiStackView: UIStackView!
	@IBOutlet weak var settingsButton: UIButton!


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = true
		setTheme()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.isHidden = true
		logic = CalculatorLogic()
		totalBillTextField.delegate = self
		tipTextField.delegate = self
		let originalImage = UIImage(named: "settings")
		let tintedImage = originalImage?.withRenderingMode(.alwaysTemplate)
		settingsButton.setImage(tintedImage, for: .normal)
		updateResetButtonTextColor()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let settingsVC = segue.destination as? SettingsViewController else { return }
		settingsVC.themeHelper = themeHelper
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isNavigationBarHidden = false
	}

	@IBAction func firstEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "2"
		emojiCalculate()
	}
	@IBAction func secondEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "15"
		emojiCalculate()
	}
	@IBAction func thirdEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "20"
		emojiCalculate()
	}
	@IBAction func fourthEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "25"
		emojiCalculate()
	}


	
	@IBAction func tipCalcButtonTapped(_ sender: Any) {
		let generator = UIImpactFeedbackGenerator(style: .light)
		generator.prepare()
		generator.impactOccurred()
		totalBillTextField.resignFirstResponder()
		tipTextField.resignFirstResponder()
		guard let totalStrInput = totalBillTextField.text, !totalStrInput.isEmpty else {
			totalBillErrorLabel.isHidden = false
			return
		}
		guard let tipPercentStrInput = tipTextField.text, !tipPercentStrInput.isEmpty else {
			tipErrorLabel.isHidden = false
			return
		}
		
		guard let logic = logic else { return }
		guard let (tipOutput, totalOutput) = logic.calculateTipTotal(subTotalStr: totalStrInput, tipPercentStr: tipPercentStrInput) else { return }
		tipOutputLabel.text = tipOutput
		totalOutputLabel.text = totalOutput
	}
	
	
	@IBAction func resetButtonTapped(_ sender: UIButton) {
		clear()
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
	}

	private func tipValueChanged() {
		tipErrorLabel.isHidden = true
		updateResetButtonTextColor()
		resetTaptic()
	}

	private func updateResetButtonTextColor() {
		if totalBillTextField.text?.isEmpty == true && tipTextField.text?.isEmpty == true {
			resetButton.isEnabled = false
		} else {
			resetButton.isEnabled = true
		}
	}

	private func resetTaptic() {
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
	}

	
	@IBAction func totalDidChange(_ sender: CustomTextField) {
		guard var totalString = sender.text else { return }
		let legalChar = Set("0123456789")
		totalString = totalString.filter { legalChar.contains($0) }
		guard let totalInt = Int(totalString) else { return }
		sender.text = String.formattedPrice(with: totalInt)
		totalBillErrorLabel.isHidden = true
		updateResetButtonTextColor()
	}

	private func emojiCalculate() {
		tipCalcButtonTapped(self)
	}


	@IBAction func tipFieldDidChange(_ sender: CustomTextField) {
		tipErrorLabel.isHidden = true
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func clear() {
		totalBillTextField.text = nil
		tipTextField.text = nil
		totalOutputLabel.text = nil
		tipOutputLabel.text = clearValue
		totalOutputLabel.text = clearValue
		tipErrorLabel.isHidden = true
		totalBillErrorLabel.isHidden = true
		updateResetButtonTextColor()
	}

	func setTheme() {
		switch themeHelper.themePreference {
		case .light:
			view.backgroundColor = .wildSand
			tipsyTitleLabel.textColor = .black
			dollarSymbol.textColor = .turquoiseTwo
			percentSymbol.textColor = .turquoiseTwo
			[totalBillTextField, tipTextField].forEach({ $0?.textColor = .black })
			[totalBillErrorLabel, tipErrorLabel].forEach( { $0?.isHidden = true} )
			[totalBillErrorLabel, tipErrorLabel].forEach( { $0?.textColor = .razzmatazz} )
			calcButton.setTitleColor(.mako, for: .normal)
			calcButton.backgroundColor = .turquoise
			calcButton.layer.cornerRadius = 30
			resetButton.setTitleColor(.razzmatazz, for: .normal)
			resetButton.setTitleColor(.mako, for: .disabled)
			[totalOutputLabel, tipOutputLabel].forEach( { $0?.textColor = .black})
			[totalInputView, tipInputView].forEach( { $0?.backgroundColor = .white } )
			[totalInputView, tipInputView].forEach( { $0?.layer.cornerRadius = 25} )
			[billAmountLabel, tipPercentLabel, quickTipLabel, tipAmountLabel, totalWithTipLabel,
			 twoPercentLabel, fifteenPercentLabel, twentyPercentLabel, twentyFivePercentLabel].forEach( { $0?.textColor = .mako} )
			[totalBillTextField, tipTextField].forEach( { $0?.keyboardAppearance = .light} )
			totalBillTextField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mako])
			tipTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mako])
			settingsButton.tintColor = .turquoiseTwo
		case .dark:
			view.backgroundColor = .black
			tipsyTitleLabel.textColor = .white
			dollarSymbol.textColor = .turquoiseTwo
			percentSymbol.textColor = .turquoiseTwo
			[totalBillTextField, tipTextField].forEach({ $0?.textColor = .wildSand })
			[totalBillErrorLabel, tipErrorLabel].forEach( { $0?.isHidden = true} )
			[totalBillErrorLabel, tipErrorLabel].forEach( { $0?.textColor = .razzmatazz} )
			calcButton.setTitleColor(.mako, for: .normal)
			calcButton.backgroundColor = .turquoise
			calcButton.layer.cornerRadius = 30
			resetButton.setTitleColor(.razzmatazz, for: .normal)
			resetButton.setTitleColor(.mako, for: .disabled)
			[totalOutputLabel, tipOutputLabel].forEach( { $0?.textColor = .wildSand })
			[totalInputView, tipInputView].forEach( { $0?.backgroundColor = .darkJungleGreen} )
			[totalInputView, tipInputView].forEach( { $0?.layer.cornerRadius = 25} )
			[billAmountLabel, tipPercentLabel, quickTipLabel, tipAmountLabel, totalWithTipLabel,
			 twoPercentLabel, fifteenPercentLabel, twentyPercentLabel, twentyFivePercentLabel].forEach( { $0?.textColor = .lightGray} )
			[totalBillTextField, tipTextField].forEach( { $0?.keyboardAppearance = .dark} )
			totalBillTextField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
			tipTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
			settingsButton.tintColor = .turquoiseTwo
		}
	}
}



