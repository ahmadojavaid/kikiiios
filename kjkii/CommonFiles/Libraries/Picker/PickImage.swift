////
////  ImagePicker.swift
////  HireSecurity
////
////  Created by abbas on 2/4/20.
////  Copyright © 2020 abbas. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class ImgPicker:ImagePickerDelegate {
//    var imagePicker:ImagePicker!
//    var completion: ((UIImage?)->Void)!
//    init(target:UIViewController) {
//        self.imagePicker = ImagePicker(presentationController: target, delegate: self)
//    }
//    func pick(sender:UIView, completion:@escaping (UIImage?)->Void){
//        self.completion = completion
//        self.imagePicker.present(from: sender)
//    }
//
//    deinit {
//        print("\n\n Deinited ImgPicker ......... \n\n")
//    }
//    func didSelect(image: UIImage?) {
//        completion(image)
//        //imagePicker = nil
//    }
//
//}
//
//public protocol ImagePickerDelegate: class {
//    func didSelect(image: UIImage?)
//}
//extension ImagePicker {
//    func alertToEncourageCameraAccessInitially() {
//        let alert = UIAlertController(
//            title: "\"Polse\" Required to Access the Camera",
//            message: "This will let you capture image for profile photo! This can be configured in settings.",
//            preferredStyle: UIAlertController.Style.alert
//        )
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
//            UIApplication.shared.open(URL(string:  UIApplication.openSettingsURLString)!)
//        }))
//        self.presentationController?.present(alert, animated: true, completion: nil)
//    }
//}
//open class ImagePicker: NSObject {
//
//    private let pickerController: UIImagePickerController
//    fileprivate weak var presentationController: UIViewController?
//    fileprivate weak var delegate: ImagePickerDelegate?
//
//    public init(presentationController: UIViewController?, delegate: ImagePickerDelegate?) {
//        self.pickerController = UIImagePickerController()
//
//        super.init()
//
//        self.presentationController = presentationController
//        self.delegate = delegate
//
//        self.pickerController.view.tintColor = .black
//        self.pickerController.delegate = self
//        self.pickerController.allowsEditing = true
//        self.pickerController.mediaTypes = ["public.image"]
//            //pickerController
//    }
//    deinit {
//        print("\n\nImagePicker Deinitialized\n\n")
//    }
//    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
//        guard UIImagePickerController.isSourceTypeAvailable(type) else {
//            return nil
//        }
//        return UIAlertAction(title: title, style: .default) { /*[unowned self]*/ _ in
//            self.pickerController.sourceType = type
//            self.presentationController?.present(self.pickerController, animated: true)
//        }
//    }
//
//    public func present(from sourceView: UIView) {
//
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alertController.view.tintColor = .black
//        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied {
//            alertController.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { _ in
//                self.alertToEncourageCameraAccessInitially()
//            }))
//        } else if let action = self.action(for: .camera, title: "Take photo") {
//            alertController.addAction(action)
//        }
//        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
//            alertController.addAction(action)
//        }
//        if let action = self.action(for: .photoLibrary, title: "Photo library") {
//            alertController.addAction(action)
//        }
//
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            alertController.popoverPresentationController?.sourceView = sourceView
//            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
//            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
//        }
//
//        self.presentationController?.present(alertController, animated: true)
//    }
//
//    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
//        controller.dismiss(animated: true, completion: nil)
//
//        self.delegate?.didSelect(image: image)
//    }
//}
//
//extension ImagePicker: UIImagePickerControllerDelegate {
//
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.pickerController(picker, didSelect: nil)
//    }
//
//    public func imagePickerController(_ picker: UIImagePickerController,
//                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        guard let image = info[.editedImage] as? UIImage else {
//            return self.pickerController(picker, didSelect: nil)
//        }
//        self.pickerController(picker, didSelect: image)
//    }
//}
//
//extension ImagePicker: UINavigationControllerDelegate {
//
//}
