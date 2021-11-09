//
//  AddPhotoViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class AddPhotoViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var addPhotoContainerView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var facialLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
//    @IBOutlet weak var photoImage: UIImageView!
    
    var userModel = User()
    var generalInfoParam = [String:String]()
    var dataImage : Date!
    var imagePicker: UIImagePickerController!
     var picker = UIImagePickerController();
    // MARK: - View life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(generalInfoParam)
        title = "Introduce Yourself"
        
        prepareNavigation()
        attributedText()
        roundRadiuView()
//        selectedImageView.contentMode = .scaleAspectFill
        //            PSApi.apiRequestWithEndPoint(.createUser, isShowAlert: true, controller: self) { (response) in
        //                print("yes")
        //            }
        
    }
    
    // MARK: - Private methods
    
    private func roundRadiuView() {
        addPhotoContainerView.roundRadius()
        nextButton.roundRadius()
    }
    
    private func prepareNavigation() {
        createBackBarButtonItem()
        
        let pageControlImage = UIImageView()
        pageControlImage.image = #imageLiteral(resourceName: "slideNavigation-2")
        let rightBarButtonItem = UIBarButtonItem(customView: pageControlImage)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func attributedString(title: String) -> NSAttributedString {
        let attributed = NSAttributedString(string: title,
                                            attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                         NSAttributedString.Key.underlineColor: UIColor.mainColor()])
        return attributed
    }
    
    private func attributedText() {
        //Attribute `Login` button
        loginButton.setAttributedTitle(attributedString(title: "Login"), for: .normal)
        
        //Attribute `facialLabel` label
        facialLabel.attributedText = attributedString(title: "Facial Recognition")
    }
    
    // MARK: - IBActions
    
    @IBAction func actionLate(_ sender: Any) {
//        let addPhotoController = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberViewController") as! PhoneNumberViewController
//        self.present(addPhotoController, animated: true, completion: nil)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let otpVC = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberViewController
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    
    @IBAction func openPhoneNoAction(_ sender: Any) {
        
        //        if (segue.identifier == "PhoneNumberVC"){
        //            if let otpSelecetOptionVC = segue.destination as? PhoneNumberViewController{
        //                //otpSelecetOptionVC.emailId = emailIdTextField.text ?? ""
        //                otpSelecetOptionVC.UserId = user.emailId ?? ""
        //
        //
        //            }
        //        }
        
        let phonenoController = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberViewController
        phonenoController.userModel.id = userModel.id
        phonenoController.userModel.email = userModel.email
        self.present(phonenoController, animated: true, completion: nil)
    }
    @IBAction func addButtonAction(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.selectImageFrom(.camera)
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.selectImageFrom(.photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        
        picker.delegate = self as (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            selectImageFrom(.photoLibrary)
//            return
//        }
//        selectImageFrom(.photoLibrary)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is LoginViewController {
                navigationController?.popToViewController(vc as! LoginViewController, animated: false)
            }
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        /*        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let otpVC = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberViewController
        otpVC.userModel.email = userModel.email
         otpVC.userModel.id = userModel.id
        self.navigationController?.pushViewController(otpVC, animated: true)
        */
        guard let data = selectedImageView.image?.jpegData(compressionQuality: 0.5) else {
            
            Utility.SubmitAlertView(viewController: self, title: "Alert", message: "Please select profile image")
            return
        }
        if selectedImageView.image != nil {
           
            
            upload()
            /*
            // Marks Api Calling for uplaod images from form-data
            PSApi.upload(.photo, params: generalInfoParam as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: true, fileName: "profile_logo", binary: data) { status in
                //let statusCode = response.response?.statusCode
                //let value1 = response.result
                if  status == true  {
//                    let msg = response.value!["msg"]
//                    let msgUrl = response.value!["img_url"]
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let otpVC = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberViewController
                    self.navigationController?.pushViewController(otpVC, animated: true)
                } else {
                    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Image did not upload, please try again!")

                }
                
            }*/
            
        }
        else{
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please select profile image")
        }
 
        
    }
    
    func upload() {

        let url = BASE_URL + Users.UPLOAD_PHOTO
        guard let image = selectedImageView.image else {return}
        guard let data = image.jpegData(compressionQuality: 0.3) else {return}
        SwiftLoader.show(title:"Please Wait...", animated: false)
        
        let userEmail = DefaultManager().getEmail()  ?? ""
        ApiManager.shared.UploadPhoto(url, data, "profile.png", ["email":userEmail], header: nil) { (error, reponse, statuCode) in
            
            
            if let err = error {
                 SwiftLoader.hide()
                print(err.localizedDescription)
            }else if let json = reponse, let code = statuCode {
                 SwiftLoader.hide()
                print(json)
                if code == 200 {
                     SwiftLoader.hide()
                    let string = json["profile_logo_url"].string
                                                if let image = getImage(from: string ?? ""){
                                                    UserDefaults().setImage(image: image, forKey: "profile_logo_url")
                    //                                print("user image is \()")

                                                }

                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let otpVC = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberViewController
                    self.navigationController?.pushViewController(otpVC, animated: true)
                }else{
                     SwiftLoader.hide()
                    showAlert(msg: "Something went wrong, please try again", title: "Error", sender: self)
                }
            }
        }
        
    }
    
    
    
    // Added by Chetu
//    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
  
    //MARKS:-  API Request Upload a image  //Chetu
    func apiCalingUpload(songData:Data?, fileName:String) {
    
        let API_URL = photoUpload
        print("API_URL : \(API_URL)")
        let request = NSMutableURLRequest(url: URL(string: API_URL)!)
        request.httpMethod = "POST"
        
        let boundary = self.generateBoundaryString()
        //define the multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        let fname = "File"
        let mimetype = "image/png"
        //define the data post parameter
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        
        if let songRawData = songData {
            body.append("Content-Disposition:form-data; name=\"File\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append(songRawData)
        }
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//        for (key, value) in param
//        {
//            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
//        }
        
        request.httpBody = body as Data
        // return body as Data
        print("Fire....")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            print("Complete")
            if error != nil {
                print("error upload : \(error)")
               // responseHandler(nil)
                return
            }
        
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    //responseHandler(json as NSDictionary?)
                } else {
                    print("Invalid Json")
                }
            } catch {
                print("Some Error")
                //responseHandler(nil)
            }
        }
        task.resume()
    }
        
        
        
        
        
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let url = "http://google.com" /* your API url */
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}


extension AddPhotoViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func selectImageFrom(_ source: ImageSource) {
           
           imagePicker =  UIImagePickerController()
           imagePicker.delegate = self
           switch source {
           case .camera:
               imagePicker.sourceType = .camera
           case .photoLibrary:
               imagePicker.sourceType = .photoLibrary
           }
           present(imagePicker, animated: true, completion: nil)
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.selectedImageView?.clipsToBounds = true
        self.selectedImageView.contentMode = .scaleAspectFill
        self.selectedImageView.layer.cornerRadius = self.selectedImageView.frame.height / 2
        if let image = info[.originalImage] as? UIImage {

            selectedImageView?.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
//              guard let selectedImage = info[.originalImage] as? UIImage else {
//                  print("Image not found!")
//                  return
//              }
//              selectedImageView?.image = selectedImage
          }
    
    
}

extension UserDefaults {
    func imageForKey(key: String) -> UIImage? {
        var image: UIImage?
        if let imageData = data(forKey: key) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
        }
        return image
    }
    func setImage(image: UIImage?, forKey key: String) {
        var imageData: NSData?
        if let image = image {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
        }
        set(imageData, forKey: key)
    }
}
