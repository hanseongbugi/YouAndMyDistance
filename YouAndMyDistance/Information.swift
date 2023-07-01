//
//  Infomation.swift
//  BHS-termProject
//
//  Created by 배한성 on 2023/06/15.
//

import Foundation
import Firebase
import MapKit
class Information: NSObject{
    var key: String //Information의 id
    var date: Date //생성한 날짜
    var owner: String? //사용자 이름
    var location:CLLocationCoordinate2D? //위도 경도를 담을 수 있는 객체
    
    init(date: Date, owner: String?){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.
        self.date = Date(timeInterval: 0, since: date)
        self.owner = Owner.getOwner() // owner를 가져와 저장한다.
        super.init()
    }
}

extension Information{
    convenience init(date: Date? = nil, withData: Bool = false){
        if withData == true{
            self.init(date: date ?? Date(), owner: "me")
        }else{
            self.init(date: date ?? Date(), owner: "me")
        }
    }
}

extension Information{
    func clone() -> Information {
        let clonee = Information()
        clonee.key = self.key    // key는 String이고 String은 struct이다. 따라서 복제가 된다
        clonee.date = Date(timeInterval: 0, since: self.date) // Date는 struct가 아니라 class이기 때문
        clonee.owner = self.owner //owner도 String이라 복제 가능
        clonee.location = self.location 
        return clonee
    }
}
extension Information{
    func toDict()->[String:Any?]{
        var dict: [String:Any?] = [:] // 빈 딕셔너리 생성
        
        dict["key"] = key
        dict["date"] = Timestamp(date:date)
        dict["owner"] = owner
        dict["latitude"] = location!.latitude
        dict["longitude"] = location!.longitude
        return dict // 딕셔너리 반환
    }
    
    func toInformation(dict:[String:Any?]){
        key = dict["key"] as! String //인자로 전달받는 딕셔너리에서 값을 가져온다.
        date = Date()
        if let timestamp = dict["date"] as? Timestamp{
            date = timestamp.dateValue()
        }
        owner = dict["owner"] as? String
        let latitude = dict["latitude"] as? CLLocationDegrees
        let longitude = dict["longitude"] as? CLLocationDegrees
        location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
}
