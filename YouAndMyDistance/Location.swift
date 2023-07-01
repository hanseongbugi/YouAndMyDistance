//
//  Location.swift
//  BHS-termProject
//
//  Created by 배한성 on 2023/06/15.
//
import Foundation
import CoreLocation

class Location{
    var myLocation:CLLocationCoordinate2D?
    var otherLocation:CLLocationCoordinate2D?
}
extension Location{
    func calcLocation() -> CLLocationDistance?{
        if let source = myLocation,let destination = otherLocation{
            let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
            let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
            // 거리를 미터(meter) 단위로 계산
            let distanceInMeters = sourceLocation.distance(from: destinationLocation)
            // 미터를 킬로미터(kilometer) 단위로 변환
            let distanceInKilometers = distanceInMeters / 1000
            return distanceInKilometers
        }
        return nil
    }
    func calculateMidCoordinate() -> CLLocationCoordinate2D? {
        if let myLocation = myLocation, let otherLocation = otherLocation{
            let lat1 = myLocation.latitude //내 위치의 위도 경도
            let lon1 = myLocation.longitude
            let lat2 = otherLocation.latitude // 다른 사용자 위치의 위도 경도
            let lon2 = otherLocation.longitude
            
            let midLat = (lat1 + lat2) / 2 //위도 합의 절반
            let midLon = (lon1 + lon2) / 2 //경도 합의 절반
            
            //중앙 위치의 CLLocationCoordinate2D 객체를 만든다.
            let midCoordinate = CLLocationCoordinate2D(latitude: midLat, longitude: midLon)
            return midCoordinate
        }
        return nil
    }
}
