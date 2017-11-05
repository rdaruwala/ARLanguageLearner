//
//  SettingsViewController.swift
//  
//
//  Created by Rohan Daruwala on 11/4/17.
//

import UIKit
import ARLanguageLearning
import ROGoogleTranslate
import ARKit


class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fromLanguageChoices: UIPickerView!
    @IBOutlet weak var toLanguageChoices: UIPickerView!
    
    var translator = ROGoogleTranslate()
    
    let dictionary = [ "Afrikaans" : "af", "Albanian" : "sq", "Amharic" : "am", "Arabic" : "ar", "Armenian" : "hy", "Azerbaijani" : "az", "Basque" : "eu", "Belarusian" : "be", "Bengali" : "bn", "Bosnian" : "bs", "Bulgarian" : "bg", "Catalan" : "ca", "Cebuano" : "ceb", "Chichewa" : "ny", "Chinese" : "zh", "Corsican" : "co", "Croatian" : "hr", "Czech" : "cs", "Danish" : "da", "Dutch" : "nl", "English" : "en", "Esperanto" : "eo", "Estonian" : "et", "Filipino" : "fil", "Finnish" : "fi", "French" : "fr", "Galician" : "gl", "Georgian" : "ka", "German" : "de", "Greek" : "el", "Gujarati" : "gu", "Haitian Creole" : "ht", "Hausa" : "ha", "Hawaiian" : "haw", "Hebrew" : "he", "Hindi" : "hi", "Hungarian" : "hu", "Icelandic" : "is", "Igbo" : "ig", "Indonesian" : "id", "Irish" : "ga", "Italian" : "it", "Japanese" : "ja", "Javanese" : "jv", "Kannada" : "kn", "Kazakh" : "kk", "Khmer" : "km", "Korean" : "ko", "Kurdish (Kurmanji)" : "ku", "Kyrgyz" : "ky", "Lao" : "lo", "Latin" : "la", "Latvian" : "lv", "Lithuanian" : "lt", "Luxembourgish" : "lb", "Macedonian" : "mk", "Malagasy" : "mg", "Malay" : "ms", "Malayalam" : "ml", "Maltese" : "mt", "Maori" : "mi", "Marathi" : "mr", "Mongolian" : "mn", "Myanmar (Burmese)" : "my", "Nepali" : "ne", "Norwegian" : "no", "Pashto" : "pus", "Persian" : "fa", "Polish" : "pl", "Portuguese" : "pt", "Punjabi" : "pa", "Romanian" : "ro", "Russian" : "ru", "Samoan" : "sm", "Scots Gaelic" : "gd", "Serbian" : "sr", "Sesotho" : "st", "Shona" : "sn", "Sindhi" : "sd", "Sinhala" : "si", "Slovak" : "sk", "Slovenian" : "sl", "Somali" : "so", "Spanish" : "es", "Sundanese" : "su", "Swahili" : "sw", "Swedish" : "sv", "Tajik" : "tg", "Tamil" : "ta", "Telugu" : "te", "Thai" : "th", "Turkish" : "tr", "Ukrainian" : "uk", "Urdu" : "ur", "Uzbek" : "uz", "Vietnamese" : "vi", "Welsh" : "cy", "Xhosa" : "xh", "Yiddish" : "yi", "Yoruba" : "yo", "Zulu" : "zu"]


    
    let languageChoices = [ "Afrikaans", "Albanian", "Amharic", "Arabic", "Armenian", "Azerbaijani", "Basque", "Belarusian", "Bengali", "Bosnian", "Bulgarian", "Catalan", "Cebuano", "Chichewa", "Chinese", "Corsican", "Croatian", "Czech", "Danish", "Dutch", "English", "Esperanto", "Estonian", "Filipino", "Finnish", "French", "Galician", "Georgian", "German", "Greek", "Gujarati", "Haitian Creole", "Hausa", "Hawaiian", "Hebrew", "Hindi", "Hungarian", "Icelandic", "Igbo", "Indonesian", "Irish", "Italian", "Japanese", "Javanese", "Kannada", "Kazakh", "Khmer", "Korean", "Kurdish (Kurmanji)", "Kyrgyz", "Lao", "Latin", "Latvian", "Lithuanian", "Luxembourgish", "Macedonian", "Malagasy", "Malay", "Malayalam", "Maltese", "Maori", "Marathi", "Mongolian", "Myanmar (Burmese)", "Nepali", "Norwegian", "Pashto", "Persian", "Polish", "Portuguese", "Punjabi", "Romanian", "Russian", "Samoan", "Scots Gaelic", "Serbian", "Sesotho", "Shona", "Sindhi", "Sinhala", "Slovak", "Slovenian", "Somali", "Spanish", "Sundanese", "Swahili", "Swedish", "Tajik", "Tamil", "Telugu", "Thai", "Turkish", "Ukrainian", "Urdu", "Uzbek", "Vietnamese", "Welsh", "Xhosa", "Yiddish", "Yoruba", "Zulu"]

    
    let languageChoicesShort = [ "af", "sq", "am", "ar", "hy", "az", "eu", "be", "bn", "bs", "bg", "ca", "ceb", "ny", "zh", "co", "hr", "cs", "da", "nl", "en", "eo", "et", "fil", "fi", "fr", "gl", "ka", "de", "el", "gu", "ht", "ha", "haw", "he", "hi", "hu", "is", "ig", "id", "ga", "it", "ja", "jv", "kn", "kk", "km", "ko", "ku", "ky", "lo", "la", "lv", "lt", "lb", "mk", "mg", "ms", "ml", "mt", "mi", "mr", "mn", "my", "ne", "no", "pus", "fa", "pl", "pt", "pa", "ro", "ru", "sm", "gd", "sr", "st", "sn", "sd", "si", "sk", "sl", "so", "es", "su", "sw", "sv", "tg", "ta", "te", "th", "tr", "uk", "ur", "uz", "vi", "cy", "xh", "yi", "yo", "zu"]



    var fromLanguage:String = ""
    var toLanguage:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(fromLanguage)
        print(toLanguage)
        
        var origFrom = 0
        var origTo = 0
        
            if let i = languageChoicesShort.index(of: fromLanguage) {
                if let j = languageChoicesShort.index(of:toLanguage) {
                    origFrom = i
                    origTo = j
                }
            }
        
        fromLanguageChoices.delegate = self
        toLanguageChoices.delegate = self
        
        print(origFrom)
        print(origTo)
        
        translator.apiKey = "AIzaSyB0bpWxewvKCrjqFEJlgufARdUl3VVKDH0"
        
        //fromLanguageChoices.selectedRow(inComponent: origFrom)
        //toLanguageChoices.selectedRow(inComponent: origTo)
        
        fromLanguageChoices.selectRow(origFrom, inComponent: 0, animated: false)
        toLanguageChoices.selectRow(origTo, inComponent: 0, animated: false)
        
    }
    
    @IBAction func onCloseButtonTap(_ sender: Any) {
        
        LanguageHolder.fromLang = languageChoicesShort[fromLanguageChoices.selectedRow(inComponent: 0)]
        LanguageHolder.toLang = languageChoicesShort[toLanguageChoices.selectedRow(inComponent: 0)]
        replaceNodes()
        self.dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //help with waiting for the async process to complete
    func application(application: UIApplication!, performFetchWithCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        loadShows(completionHandler: completionHandler)
    }
    
    func loadShows(completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        //....
        //DO IT
        //....
        
        completionHandler(UIBackgroundFetchResult.newData)
        print("Background Fetch Complete")
    }
    
//    func translateHelper(text: String) -> String {
//        var sourceLang = LanguageHolder.fromLang
//        var targetLang = LanguageHolder.toLang
//    func translateHelper (dest: String, )
//        var params = ROGoogleTranslateParams(source: sourceLang, target: targetLang, text: text)
//        var result = ""
//
//        self.translator.translate(params: params) {
//            (trans) in print("Translate to Translation: \(trans)")
//            result = trans
//        }
//        usleep(1000 * 100)
//        return result
//    }
    //english -> reference & target languages
    func nodeTranslator(text: String, node: SKLabelNode) {
        var sourceLang = LanguageHolder.fromLang
        var targetLang = LanguageHolder.toLang
        var result = ""
        var params = ROGoogleTranslateParams(source: "en", target: targetLang, text:  text)
        self.translator.translate(params: params) { (trans) in
            print("Translate To Translation: \(trans)")

            if(sourceLang != "en"){
                var params2 = ROGoogleTranslateParams(source: "en", target: sourceLang, text:  text)
                self.translator.translate(params: params2) { (ref) in
                    node.text = trans + " (" + ref + ")"
                }
            }
            else{
                node.text = trans + " (" + text + ")"
            }
        }
    }
    
    func replaceNodes() {
        for (offset: i, element:(key: node, value: objectNames)) in LanguageHolder.database.enumerated() {
//            for objectName in objectNames {
//                nodeTranslator(text: objectName, node: LanguageHolder.nodeList[i])
//            }
            nodeTranslator(text: objectNames[0], node: LanguageHolder.nodeList[i])
        }
    }
    
//    func replaceNodes(){
//        for (offset: i, element: (key: node, value: objects)) in LanguageHolder.database.enumerated(){
//            for (j, string) in objects.enumerated(){
//                //LanguageHolder.database[node]![j] = translateHelper(text: string)
//            }
//        }
//        for (i, node) in LanguageHolder.nodeList.enumerated() {
//            //LanguageHolder.nodeList[i].text = LanguageHolder.database[node]?[0]
//            //print(LanguageHolder.database[node]?[0])
//            let objNameEng = ""
//            translateHelper(text: objNameEng, node: LanguageHolder.nodeList[i])
//        }
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageChoices[row]
    }

}
