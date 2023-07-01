//
//  MapViewController.swift
//  BHS-termProject
//
//  Created by 배한성 on 2023/06/15.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var imageLocation:Location?
    var coordinates = [CLLocationCoordinate2D]()
    var annotationView:MKAnnotationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let location = imageLocation,let myLocation = location.myLocation,
            let otherLocation = location.otherLocation{
            let calcLocation = location.calcLocation()
            //print(calcLocation!)
            coordinates.append(CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude))
            coordinates.append(CLLocationCoordinate2D(latitude: otherLocation.latitude, longitude: otherLocation.longitude))
            // MKPolyline 객체 생성
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
            
            let polylineBoundingRect = polyline.boundingMapRect
            mapView.setVisibleMapRect(polylineBoundingRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
            updateMap(title: "Other", longitute: otherLocation.longitude, latitute: otherLocation.latitude)
            updateMap(title: "Me", longitute: myLocation.longitude, latitute: myLocation.latitude)
        
            if let middleLocation = location.calculateMidCoordinate(){
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.maximumFractionDigits = 2
                
                if let formattedString = numberFormatter.string(from: NSNumber(value: calcLocation ?? 0)) {
                    updateMap(title: "\(formattedString) KM", longitute: middleLocation.longitude, latitute: middleLocation.latitude)
                }
            }
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
    }

}
extension MapViewController{
    func updateMap(title: String, longitute: Double?, latitute: Double?){

        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        var center = mapView.centerCoordinate // 일단 기존의 중심을 저장
        if let longitute = longitute, let latitute = latitute{
            center = CLLocationCoordinate2D(latitude: latitute, longitude: longitute) // 새로운 중심 설정
        }
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true) // 주어진 영역으로 지도를 설정
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center    // 센터에 annotation을 설치
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
}
extension MapViewController{
    func configure(withData imageLocation:Location){
        self.imageLocation = imageLocation
    }
}
extension MapViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemMint
            renderer.lineWidth = 2.0
            return renderer
        }
            
        return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let location = imageLocation{
            let calcLocation = location.calcLocation()
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            if let formattedString = numberFormatter.string(from: NSNumber(value: calcLocation ?? 0)){
                // 특정 어노테이션의 핀 색상을 변경합니다.
                if annotation.title == "\(formattedString) KM" {
                    let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "delimeter")
                    annotationView.image = nil
                    annotationView.canShowCallout = false
                    annotationView.tintColor = .clear
                    annotationView.glyphTintColor = .clear
                    annotationView.markerTintColor = .clear
                    return annotationView
                    
                }
            }
        }
        // 기본 어노테이션 뷰를 반환합니다.
        return nil
    }
   
}
