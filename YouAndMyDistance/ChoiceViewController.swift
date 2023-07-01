//
//  ChoiceViewController.swift
//  BHS-termProject
//
//  Created by 배한성 on 2023/06/14.
//

import UIKit
import MapKit

class ChoiceViewController: UIViewController {
    @IBOutlet weak var meImage: UIImageView!
    var location:Location!
    var otherLocation:CLLocationCoordinate2D?
    var setMeImage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let meGesture = UITapGestureRecognizer(target: self, action: #selector(meClick))
        meImage.isUserInteractionEnabled = true
        meImage.addGestureRecognizer(meGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        setMeImage = false
        meImage.image = UIImage(named: "click.png")
    }
    @IBAction func showDistanceOfMap(_ sender: UIButton) {
        if setMeImage{
            let mapViewController = storyboard?.instantiateViewController(withIdentifier: "ShowMap") as! MapViewController
            mapViewController.configure(withData: location)
            navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
}

extension ChoiceViewController{
    @objc func meClick(sender: UITapGestureRecognizer) {
        // 컨트로러를 생성한다
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        // UIImagePickerController 활성화
        present(imagePickerController, animated: true, completion: nil)
    }
}
extension ChoiceViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // 여기서 이미지에 대한 추가적인 작업을 한다
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        let location = getImageLocation(imageURL: imageURL)
        if let location = location{
            meImage.image = image
            setMeImage = true
            self.location.myLocation = location
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // imagePickerController을 죽인다
        picker.dismiss(animated: true, completion: nil)
    }
}
extension ChoiceViewController{
    func getImageLocation(imageURL: URL) -> CLLocationCoordinate2D? {
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil) else {
            return nil
        }
        
        guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else {
            return nil
        }
        
        if let gpsInfo = imageProperties[kCGImagePropertyGPSDictionary as String] as? [String: Any],
           let latitudeRef = gpsInfo[kCGImagePropertyGPSLatitudeRef as String] as? String,
           let latitude = gpsInfo[kCGImagePropertyGPSLatitude as String] as? Double,
           let longitudeRef = gpsInfo[kCGImagePropertyGPSLongitudeRef as String] as? String,
           let longitude = gpsInfo[kCGImagePropertyGPSLongitude as String] as? Double {
            
            var latitudeMultiplier = 1.0
            if latitudeRef == "S" {
                latitudeMultiplier = -1.0
            }
            
            var longitudeMultiplier = 1.0
            if longitudeRef == "W" {
                longitudeMultiplier = -1.0
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude * latitudeMultiplier, longitude: longitude * longitudeMultiplier)
            return coordinate
        }
        
        return nil
    }
}
extension ChoiceViewController{
    func configure(withData imageLocation:CLLocationCoordinate2D){
        self.location = Location()
        self.location.otherLocation = imageLocation
    }
}
