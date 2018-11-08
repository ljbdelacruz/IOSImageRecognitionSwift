//
//  ViewController.swift
//  ImageRecognitionApp
//
//  Created by Lainel John Dela Cruz on 25/09/2017.
//  Copyright © 2017 Lainel John Dela Cruz. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imagePicker.delegate=self;
        self.imagePicker.sourceType = .camera;
        self.imagePicker.allowsEditing=false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage=info[UIImagePickerControllerOriginalImage] as? UIImage{
                 self.imageView.image=userPickedImage;
            
            guard let ciimage=CIImage(image: userPickedImage) else{
                fatalError("Could Not Convert to CIImage");
            }
            Detect(image: ciimage);
        }
        self.imagePicker.dismiss(animated: true, completion: nil);
    }
    
    @IBOutlet weak var ItemName: UILabel!
    func Detect(image :CIImage){
        guard  let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Error");
        };
        
        let request=VNCoreMLRequest(model:model) { (request, error) in
            guard let results=request.results as? [VNClassificationObservation] else{
                fatalError("Error in getting request");
            }
            if let firstResult=results.first{
                print(firstResult.identifier);
                self.ItemName.text=firstResult.identifier;
            }
        }
        
        let handler=VNImageRequestHandler(ciImage:image);
        do{
            try handler.perform([request]);
        }catch{
            print(error);
        }
        
        
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func cameraEnable(_ sender: Any) {
        present(self.imagePicker, animated: true, completion: nil);
        
    }
    
    
    
}

