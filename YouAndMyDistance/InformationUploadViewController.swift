//
//  InfomationApplayViewController.swift
//  BHS-termProject
//
//  Created by 배한성 on 2023/06/15.
//
import UIKit
import MapKit

class InformationUploadViewController: UIViewController {

    @IBOutlet weak var dateDatePicker: UIDatePicker!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    var information: Information?
    var saveChangeDelegate: ((Information)->Void)?
    var latitudeDegree:CLLocationDegrees?
    var longitudeDegree:CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        information = information ?? Information(date: Date(), withData: true)
        dateDatePicker.date = information?.date ?? Date()
        ownerLabel.text = information?.owner //ownerLabel에 owner 등록
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ownerClick)) //Gesture 생성
        ownerImage.isUserInteractionEnabled = true
        ownerImage.addGestureRecognizer(tapGesture) //imageView에 gesture 등록
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let latitudeDegree = latitudeDegree, let longitudeDegree = longitudeDegree{
            information!.date = dateDatePicker.date
            information!.owner = ownerLabel.text
            information!.location = CLLocationCoordinate2D(latitude: latitudeDegree, longitude: longitudeDegree)
            saveChangeDelegate?(information!) // 부모에게 전달
        }
    }
}

extension InformationUploadViewController{
    @objc func ownerClick(sender: UITapGestureRecognizer) {
        // 컨트로러를 생성한다
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self // 이 딜리게이터를 설정하면 사진을 찍은후 호출된다
        imagePickerController.sourceType = .photoLibrary
        
        // UIImagePickerController이 활성화
        present(imagePickerController, animated: true, completion: nil)
    }
}
extension InformationUploadViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // 여기서 이미지에 대한 추가적인 작업을 한다
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        let location = getImageLocation(imageURL: imageURL)
        ownerImage.image = image
        if let location = location{
            latitudeDegree = location.latitude
            longitudeDegree = location.longitude
            latitudeLabel.text = String(describing: location.latitude)
            longitudeLabel.text = String(describing: location.longitude)
        }else{
            latitudeLabel.text = "위도가 존재하지 않는 이미지 입니다"
            longitudeLabel.text = "경도가 존재하지 않는 이미지 입니다"
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // 사진 캡쳐를 취소하는 경우 호출 함수
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // imagePickerController을 죽인다
        picker.dismiss(animated: true, completion: nil)
    }
}
extension InformationUploadViewController{
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
