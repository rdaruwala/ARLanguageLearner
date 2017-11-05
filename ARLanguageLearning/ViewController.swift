//
//  ViewController.swift
//  ARLanguageLearning
//
//  Created by Rohan Daruwala on 11/4/17.
//  Copyright © 2017 Roholiver. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import CoreData
import SwiftyJSON
import ROGoogleTranslate

class LanguageHolder {
    static var fromLang = "en"
    static var toLang = "es"
    static var database:[SKLabelNode:[String]] = [:]
    static var nodeList:[SKLabelNode] = []
}
class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    @IBOutlet var tapObj: UITapGestureRecognizer!
    
    let defaults = UserDefaults.standard
    var imagePicker = UIImagePickerController()
    
    var scene:SKScene = SKScene()
    
    let session = URLSession.shared
    
    var tempVar:[String] = []
    
    
    
    var translator = ROGoogleTranslate()
    
    var fromLanguage:String = ""
    var toLanguage:String = ""

    
    
    var googleAPIKey = "AIzaSyB0bpWxewvKCrjqFEJlgufARdUl3VVKDH0"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
//        if let scene = SKScene(fileNamed: "Scene") {
//            sceneView.presentScene(scene)
//        }
        
        scene = SKScene(fileNamed: "Scene")!
        sceneView.presentScene(scene)
        
        //fromLanguage = "en"
        //toLanguage = "es"
        fromLanguage = LanguageHolder.fromLang
        toLanguage = LanguageHolder.toLang
        
        translator.apiKey = "AIzaSyB0bpWxewvKCrjqFEJlgufARdUl3VVKDH0"
    }
    

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                self.performSegue(withIdentifier: "settings", sender: self)
            default:
                break
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        self.performSegue(withIdentifier: "settings", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "settings"){
            let next = segue.destination as! SettingsViewController
            
//            next.fromLanguage = self.fromLanguage //"en"
//            next.toLanguage = self.toLanguage //"es"
            
            next.fromLanguage = LanguageHolder.fromLang
            next.toLanguage = LanguageHolder.toLang
        }
    }
    
    
    @IBAction func onTap(_ sender: Any) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.75
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
        let screenSize = UIScreen.main.bounds
        let sWidth = screenSize.width
        let sHeight = screenSize.height
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        print("Now!")
        let labelNode = SKLabelNode(text: "Waiting...")
        let screenshot = self.view?.pb_takeSnapshot()
        let binaryImageData = base64EncodeImage(screenshot!)
        var results = createRequest(with: binaryImageData, node: labelNode)
        
        print("Woah!")
        
        // Create and configure a node for the anchor added to the view's session.
        //let next = defaults.object(forKey: "nextWord") as? String
        labelNode.fontSize = 12
        labelNode.fontName = "Arial"
        //labelNode.toggleBoldface(self)
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        LanguageHolder.nodeList.append(labelNode)
        return labelNode;
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension ViewController {
    
    func analyzeResults(_ dataToParse: Data, node: SKLabelNode) ->[String] {
        var labelResultsText:String = ""
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
               print("Error")
            } else {
                // Parse the response
                print(json)
                let responses: JSON = json["responses"][0]
                // Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
                var labels: Array<String> = []
                let numLabels: Int = labelAnnotations.count
                if numLabels > 0 {
                    //var labelResultsText:String = "Labels found: "
                    for index in 0..<numLabels {
                        let label = labelAnnotations[index]["description"].stringValue
                        labels.append(label)
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)"
                        }
                    }
                    //self.labelResults.text = labelResultsText
                    print(labelResultsText)
                    print("HELLLLOOOOO")
                    LanguageHolder.database[node] = labels
                    print(labels)
//                    self.translate(sourceLang: self.fromLanguage, targetLang: self.toLanguage, text: labels[0], node: node)
                    self.translate(sourceLang: LanguageHolder.fromLang, targetLang: LanguageHolder.toLang, text: labels[0], node: node)
                    
                } else {
                    //self.labelResults.text = "No labels found"
                    print("Nothing found.... :( ")
                }
            }
        })
        return ["nobody sees this anyways"]
    }
    
    func translate(sourceLang: String, targetLang: String, text: String, node:SKLabelNode) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageView.contentMode = .scaleAspectFit
//            imageView.isHidden = true // You could optionally display the image here by setting imageView.image = pickedImage
//            spinner.startAnimating()
//            faceResults.isHidden = true
//            labelResults.isHidden = true
            
            // Base64 encode the image and create the request
            let binaryImageData = base64EncodeImage(pickedImage)
            //createRequest(with: binaryImageData)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}


/// Networking

extension ViewController {
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String, node: SKLabelNode) -> [String] {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return ["rip"]
        }
        
        request.httpBody = data
        
        // Run the request on a FOREGROUND thread
        //DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
        return self.runRequestOnBackgroundThread(request, node: node)
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest, node: SKLabelNode) ->[String] {
        // run the request
        var tmp:[String] = []
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            tmp = self.analyzeResults(data, node: node)
            //return self.analyzeResults(data)
        }
        
        task.resume()
        return tmp
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

