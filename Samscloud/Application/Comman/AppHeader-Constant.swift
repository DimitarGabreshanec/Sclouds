//
//  AppHeader.swift
//  FoodUp_Customer
//
//  Created by Malav Soni on 07/04/16.
//  Copyright © 2016 AgileInfoWays Pvt.Ltd. All rights reserved.
//

import Foundation
import UIKit

//enum FDPushNotificationType: Int {
//}



struct Constant {
    
    struct AppInfo {
        static let Name = "ParkTip"
        static let screenSize: CGRect = UIScreen.main.bounds
         static  let baseURL = "http://getdrinkr.com"
    }
    
    struct StoryBoardName {
        static let Main = "Main"
    }
    
    struct Endpoint {
     static  let searchBar = "api/searchBars"
        static  let FAVORITES_LIST = "api/listFavourite"
         static  let category_LIST = "api/listCategory"
        static  let Subcategory_LIST = "api/getBarsByCategory"
         static  let friends_LIST = "api/listFriends"
         static  let CheckinPeople_LIST = "api/getChekInPeopleList"
        static  let pendingFriends_LIST = "api/pendingFriends"
         static  let checkinDetail = "api/checkinDetails"
    }
    
    struct INSTAGRAM_IDS {
        static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
        static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
        static let INSTAGRAM_CLIENT_ID  = "62d7d65c980a4552b536b15551bb9d54"
        static let INSTAGRAM_CLIENTSERCRET = "3f9ab94e11564a3f9cea92368df08fc8"
        static let INSTAGRAM_REDIRECT_URI = "http://www.iplexuss.com"
        static let INSTAGRAM_ACCESS_TOKEN =  "access_token"
        static let INSTAGRAM_SCOPE = "likes+comments+relationships"
    }
    
//   struct APIResponseCode {
//        static let MISSING_REQUIRED_PARAMS:Int = 100;
//        static let MISSING_ACCESS_TOKEN:Int = 101;
//        static let EXPIRED_ACCESS_TOKEN:Int = 102;
//        static let INVALID_ACCESS_TOKEN:Int = 103;
//        static let DUPLICATE_EMAIL:Int = 104;
//        static let INVALID_JSON:Int = 105;
//        static let INVALID_CARD_DETAILS:Int = 106;
//        static let INVALID_STRIPE_TOKEN:Int = 107;
//        static let ERR_UPLOADING_MEDIA:Int = 108;
//        static let NO_USER_FOUND:Int = 109;
//        static let INVALID_INVITATION_CODE:Int = 110;
//        static let DEVICE_ID_MISMATCH:Int = 111;
//        static let MISSING_DEVICE_ID:Int = 112;
//        static let MISSING_USER_ID:Int = 113;
//        static let BAD_REQUEST:Int = 400;
//        static let ERR_DATABASE:Int = 500;
//        static let DOES_NOT_EXIST:Int = 404;
//        static let CONFLICT:Int = 409;
//        static let SUCCESS:Int = 200;
//    }
    
    
    struct APIHeader {
        static let DeviceId = "device_id"
        static let AccessToken = "access_token"
        static let DeviceType = "device_type"
        static let UserId = "user_id"
    }
    
    struct Popup {
        static let Name = "My Better Sight"
    }
   
    struct AttributedString {
        static let LinkText = "linkText"
        static let LinkUnderline = "shouldAddLinkUnderline"
        static let LinkColor = "linkColor"
        static let LinkFont = "linkFont"
    }
    
    
    struct TextField {
        static var padding = 4.0
        static var bottomBorderHeight = 0.5
        static var textFieldText = "textFieldText"
        static var textFieldPlaceholder = "textFieldPlaceholder"
        static var textFieldTextLength = "textFieldTextLength"
        static var textFieldValidationType = "textFieldValidationType"
        static var textFieldKeyboardType = "textFieldKeyboardType"
        static var textFieldEnable = "textFieldEnabled"
        
        struct ArrowTextField {
            static var innerHorizontalPadding = 20.0
            static var innerVerticalPadding = 10.0
            static var headerPlaceHolderName = "headerPlaceHolderName"
            static var firstArrowTextFieldDetails = "firstArrowTextFieldDetails"
            static var secondArrowTextFieldDetails = "secondArrowTextFieldDetails"
            static var arrowType = "arrowType" 
        }
        
        struct TextFieldNotification {
            static var kValueChangeText = "kTextFieldValueChangeText"
            static var kValueDidEndEditing = "kTextFieldDidEndEditing"
        }
    }
    
    struct TextView {
        static var textViewPlaceholder = "textViewPlaceholder"
        static var textViewText = "textViewText"
        static var textViewTextLength = "textViewTextLength"
    }
    
    struct TableView {
        static var sectionTitle = "tableViewSectionTitle"
        static var rowHeight = "tableViewRowHeight"
        static var sectionInfoText = "tableViewSectionInfoText"
        static var tableViewCellType = "tableViewCellType"
      /*  struct PromotionDetailContentTableViewCell {
            static var kHeaderText = "kHeaderText"
            static var kRatingCount = "kRatingCount"
            static var kDealPrice = "kDealPrice"
            static var kSubHeader = "kSubHeaderText"
            static var kNoteInfo = "kNoteText"
        }*/
    }
    
    
}
