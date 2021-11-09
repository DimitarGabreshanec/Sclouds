//
//  Constant.swift
//  Samscloud
//
//  Created by Chetu Mac on 15/04/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CoreLocation

// US States
let stateList = ["AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY"]

// base URl
let baseURLLatest = "https://api.samscloud.io/api/"

//let baseURLLatest = "https://virtserver.swaggerhub.com/sanders-tech/samscloud/1.0.1/"
let baseURLLatestMockUp = "https://e740439e-0c75-443a-ad4c-43500d92e975.mock.pstmn.io"
let photoUpload = "http://3.17.138.157:8000/api/user-profile-logo/"
let token =  "54M5CL0UD-T0K3N"
let CheckLoc =  "true"


// MARK: -  Validation Msg
let msgForgot = "User doesn't exists"
let verifyMsg = "OTP doesn’t match."


// MARK: - UserType Individual or Responder
var userType : String = "Individual"
var userId : String = ""
var userToken : String  = ""



// MARK: - STRUCT
struct APIKey {
    static let userID = "user_id"
}

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let widthFactor = SCREEN_WIDTH/320.0





func showAlert(msg:String , title:String , sender:UIViewController?){
    let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
    let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
    alert.addAction(okAction)
    sender?.present(alert, animated: true, completion: nil)
}



struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}



let wsc_api_key = "CgWkkCmiq1zJNbys22IdOx1OzwkfcTjJ8JbQlSAVMSkGsj1BtN1RHkfbHSN83435"

//"VqEBBmbb7jvsSKIqT3Qhck6RSuccV2iYlvReRTHzkQkZCve19QFniKC3kSkn352d"
//"qzDZOlYP8hVJm8lteiDJqgCJWjz5Eh4DhDeLaLYrcDGnsrUS11Vot0HkL0pi3449"
//"CgWkkCmiq1zJNbys22IdOx1OzwkfcTjJ8JbQlSAVMSkGsj1BtN1RHkfbHSN83435"
//"CgWkkCmiq1zJNbys22IdOx1OzwkfcTjJ8JbQlSAVMSkGsj1BtN1RHkfbHSN83435"

let wsc_access_key = "GMCQKJsWcrOrxTgSWtLzqNhP2war774nf730Q5WOZyIX1VKHFBX2uogFbpuK333a"

//"pgpCklGQknTjRWQo4cc3dM7Bp2KtsjcpbqF98MDn4fjQyE1tgEmi5DJSnQO03428"
//"rRZ2vbiCCriqtQQsQppA0Zv5o5bY2oMQoF4dUQj2hhC6nyov8ezlzYGBGngJ3602"
//"OG6H6Se0Aunoxqokm3QyTSuwhKwnC7v8R2duhklKM9T9xFXwNEPM6ckU5hZT3450"
//"Gztsmmi5PCjn1hxQyNrYo8H2uzPoupDh8xJ7hS16UYVTdbDqitIqL4lBSFpr362d"

let GoogleApiKey = "AIzaSyCrm9soD1AxqIgoKoH0VsBWC8lBE4wHDbo"//"AIzaSyAVpWTab6uydEkt8X1uJrzqWS69zmJX24w"









func getNearByPlaces(lat:Double,lng:Double) {
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=2000&type=establishment&key=\(GoogleApiKey)"
    
    print("Hitting near by places API ----->>>>",url)
    APIsHandler.GETApi(url, param: nil, header: nil) { (response, error, statusCode) in
        if let err = error {
            print(err.localizedDescription)
        }else if let json = response {
            guard let array = json["results"].array else {return}
            print(array)
            var results:[PlaceResult] = array.decode()
            results = results.sorted(by: { $0.distance < $1.distance })
            appDelegate.nearbyPlaces = results
        }
    }
}




class PlaceResult:JSONDecodable,Codable {
    
    var icon:String?
    var name:String?
    var place_id:String?
    var reference:String?
    var vicinity:String?
    var lat:Double?
    var lng:Double?
    var distance:Float = 0
    required init(json: JSON) {
        
        icon = json["icon"].stringValue
        name = json["name"].stringValue
        place_id = json["place_id"].stringValue
        reference = json["reference"].stringValue
        
        vicinity = json["vicinity"].stringValue
        lat = json["geometry"]["location"]["lat"].doubleValue
        lng = json["geometry"]["location"]["lng"].doubleValue
        self.updateDistance()
    }
    
    func updateDistance() {
        guard let lat1 = self.lat, let lng2 = self.lng else {return}
        if appDelegate.currentLocation == nil {return}
        let loc1 = CLLocation.init(latitude: lat1, longitude: lng2)
        let distance = appDelegate.currentLocation.distance(from: loc1)
        self.distance = Float(distance)
    }
}



