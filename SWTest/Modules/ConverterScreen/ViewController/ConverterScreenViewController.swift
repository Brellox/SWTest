//
//  ConverterScreenViewController.swift
//  SWTest
//
//  Created by Иван Суслов on 30.06.2021.
//

import Foundation
import UIKit

class ConverterScreenViewController: UIViewController {
    
    private var fromValute = Valute(numCode: "000", charCode: "RUR", nominal: 1, name: "Российский рубль", value: 1)
    private var toValute = Valute(numCode: "000", charCode: "RUR", nominal: 1, name: "Российский рубль", value: 1)
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var insertionField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insertionField.addTarget(self, action: #selector(updateViews), for: .editingChanged)
    }
    
    @IBAction func chooseCurrency(_ sender: Any) {
        let pickerViewController = storyboard?.instantiateViewController(identifier: "picker") as! PickerViewController
        pickerViewController.fromSelectionDelegate = self
        pickerViewController.toSelectionDelegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
   @objc func updateViews(input: Double){
        guard let amountText = insertionField.text, let theAmountText = Double(amountText) else {return}
        if insertionField.text != ""{
            let total = theAmountText * fromValute.value / toValute.value
            resultLabel.text = String(format: "%.2f", total)
        }
    }
}

extension ConverterScreenViewController: FromSelectionDelegate{
    func didSelectFrom(valute: Valute?) {
        fromLabel.text = "From: " + valute!.charCode
        fromValute = valute!
    }
}

extension ConverterScreenViewController: ToSelectionDelegate{
    func didSelectTo(valute: Valute?) {
        toLabel.text = "To: " + valute!.charCode
        toValute = valute!
    }
}
