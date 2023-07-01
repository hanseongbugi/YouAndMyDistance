//
//  DbFirebase.swift
//  BHS-termProject
//
//  Created by 배한성 on 2023/06/15.
//

import UIKit
import Firebase

class DbFirebase: Database {
    
    var reference: CollectionReference                    // firestore에서 데이터베이스 위치
    var parentNotification: ((Information?, DbAction?) -> Void)? // InformationGroupViewController에서 설정
    var existQuery: ListenerRegistration?                 // 이미 설정한 Query의 존재여부

    required init(parentNotification: ((Information?, DbAction?) -> Void)?) {
        self.parentNotification = parentNotification
        reference = Firestore.firestore().collection("informations")
    }
}
extension DbFirebase{
    
    func saveChange(information: Information, action: DbAction){
        if action == .Delete{
            reference.document(information.key).delete()    // key로된 information을 지운다
            return
        }
        let data = information.toDict() //information에 저장된 data를 딕셔너리로 반환 받는다.
        // 저장 형태로 만든다
        let storeDate: [String : Any] = ["date": information.date, "data": data]
        reference.document(information.key).setData(storeDate)
    }
}
extension DbFirebase{
    func queryInformation(fromDate: Date, toDate: Date) {
        
        if let existQuery = existQuery{    // 이미 적용 쿼리가 있으면 제거, 중복 방지
            existQuery.remove()
        }
        let queryReference = reference.whereField("date", isGreaterThanOrEqualTo: fromDate).whereField("date", isLessThanOrEqualTo: toDate)

        // onChangingData는 쿼리를 만족하는 데이터가 있거나 firestore내에서 다른 앱에 의하여
        // 데이터가 변경되어 쿼리를 만족하는 데이터가 발생하면 호출해 달라는 것
        existQuery = queryReference.addSnapshotListener(onChangingData)
    }
}
extension DbFirebase{
    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?){
        guard let querySnapshot = querySnapshot else{ return }
        // 초기 데이터가 하나도 없는 경우에 count가 0이다
        if(querySnapshot.documentChanges.count <= 0){
            if let parentNotification = parentNotification { parentNotification(nil, nil)} // 부모에게 알림
        }
        // 쿼리를 만족하는 데이터가 많은 경우 한꺼번에 여러 데이터가 온다
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data() //["date": date, "data": data!]로 구성되어 있다
            let information = Information()
            information.toInformation(dict: data["data"] as! [String : Any?])
            var action: DbAction?
            switch(documentChange.type){    // 단순히 DbAction으로 설정
                case    .added: action = .Add
                case    .modified: action = .Modify
                case    .removed: action = .Delete
            }
            if let parentNotification = parentNotification {parentNotification(information, action)} // 부모에게 알림
        }
    }
}
