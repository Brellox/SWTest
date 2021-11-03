//
//  XMLParser.swift
//  SWTest
//
//  Created by Иван Суслов on 29.06.2021.
//

import Foundation

class ValuteParser: NSObject, XMLParserDelegate {
    private var valutes: [Valute] = []
    private var currentElement = ""
    private var currentNumCode: String = ""
    private var currentCharCode: String = ""
    private var currentNominal: Int = 0
    private var currentName: String = ""{
        didSet{currentName = currentName.trimmingCharacters(in: CharacterSet.whitespaces)}
    }
    private var currentValue: Double = 0
    private var parserCompletionHandler: (([Valute])-> Void)?
    
    func parseValutes(url:String, completionHandler: (([Valute])-> Void)?) {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                if let error = error{
                    print(error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "Valute" {
            currentNumCode = ""
            currentCharCode = ""
            currentNominal = 0
            currentName = ""
            currentValue = 0
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "NumCode":currentNumCode+=string
        case "CharCode": currentCharCode+=string
        case "Nominal": currentNominal = (string as NSString).integerValue
        case "Name": currentName += string
        case "Value": currentValue = (string as NSString).doubleValue
        default: break
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Valute"
        {
            let valute = Valute(numCode: currentNumCode, charCode: currentCharCode, nominal: currentNominal, name: currentName, value: currentValue)
            self.valutes.append(valute)
        }
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(valutes)
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
