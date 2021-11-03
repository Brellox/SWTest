//
//  PickerViewController.swift
//  SWTest
//
//  Created by Иван Суслов on 30.06.2021.
//

import Foundation
import UIKit

protocol FromSelectionDelegate {
    func didSelectFrom(valute: Valute?)
}
protocol ToSelectionDelegate {
    func didSelectTo(valute: Valute?)
}

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    private var valutes: [Valute]?
    private let url = "https://www.cbr.ru/scripts/XML_daily.asp"
    private var fromValute = Valute(numCode: "000", charCode: "RUR", nominal: 1, name: "Российский рубль", value: 1)
    private var toValute = Valute(numCode: "000", charCode: "RUR", nominal: 1, name: "Российский рубль", value: 1)
    var fromSelectionDelegate: FromSelectionDelegate!
    var toSelectionDelegate: ToSelectionDelegate!

    @IBOutlet weak var convertCurrencyLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toPickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        fromPickerView.delegate = self
        fromPickerView.dataSource = self
        toPickerView.delegate = self
        toPickerView.dataSource = self
    }
    
    private func fetchData()
    {
        let valuteParser = ValuteParser()
        valuteParser.parseValutes(url: url) { (valutes) in
            self.valutes = valutes
            self.valutes?.append(self.fromValute)
            OperationQueue.main.addOperation {
                self.fromPickerView.reloadAllComponents()
                self.toPickerView.reloadAllComponents()
            }
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let valutes = valutes else {
            return 0
        }
        return valutes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return valutes?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fromPickerView
        {
            fromSelectionDelegate.didSelectFrom(valute: valutes?[row])
            
        } else  if pickerView == toPickerView
        {
            toSelectionDelegate.didSelectTo(valute: valutes?[row])
            
        }
    }
}
