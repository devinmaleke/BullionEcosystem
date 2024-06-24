//
//  RegistrationVC.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 21/06/24.
//

import UIKit

class RegistrationVC: UIViewController {
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    
    @IBOutlet weak var dobButton: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var revealPasswordButton: UIButton!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var revealConfirmPassButton: UIButton!
    
    @IBOutlet weak var addUserButton: UIButton!
    
    private lazy var viewModel = RegisterUserVM()
    
    var gender: String?
    var dob: String?
    var photoProfile: URL?
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        botView.roundCorners(corners: [.topLeft, .topRight], radius: 24)
        
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == maleButton{
            sender.setImage(UIImage(named: "Checkbox_Check"), for: .normal)
            femaleButton.setImage(UIImage(named: "Checkbox_Uncheck"), for: .normal)
            gender = "male"
        }else if sender == femaleButton{
            sender.setImage(UIImage(named: "Checkbox_Check"), for: .normal)
            maleButton.setImage(UIImage(named: "Checkbox_Uncheck"), for: .normal)
            gender = "female"
        }else if sender == dobButton{
            let vc = CalendarVC(date: Date())
            vc.completion = {[weak self] selectingDate in
                let date = Functions.getISOString(from: selectingDate)
                self?.dob = date
                let formatDate = date.toFormattedDate(format: "dd MMM YYYY")
                self?.dobButton.setTitle(formatDate, for: .normal)
                self?.dobButton.setFont(size: 14, weight: .regular)
                self?.dobButton.setTitleColor(.black, for: .normal)
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }else if sender == choosePhotoButton{
            actionSheet()
        }else if sender == revealPasswordButton{
            Functions.securedField(textField: passwordTF, sender: sender)
        }else if sender == revealConfirmPassButton{
            Functions.securedField(textField: confirmPasswordTF, sender: sender)
        }else if sender == addUserButton{
            prosesRegister()
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupUI(){
        
        topView.setGradientBackground(colorOne: UIColor.init(hex: "F05A2A"), colorTwo: UIColor.init(hex: "F89576"))
        
        nameTF.layer.cornerRadius = 20
        nameTF.layer.borderWidth = 1
        nameTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        nameTF.layer.masksToBounds = true
        
        emailTF.layer.cornerRadius = 20
        emailTF.layer.borderWidth = 1
        emailTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        emailTF.layer.masksToBounds = true
        
        phoneNumberTF.layer.cornerRadius = 20
        phoneNumberTF.layer.borderWidth = 1
        phoneNumberTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        phoneNumberTF.layer.masksToBounds = true
        
        addressTF.layer.cornerRadius = 20
        addressTF.layer.borderWidth = 1
        addressTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        addressTF.layer.masksToBounds = true
        
        passwordTF.layer.cornerRadius = 20
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        passwordTF.layer.masksToBounds = true
        
        confirmPasswordTF.layer.cornerRadius = 20
        confirmPasswordTF.layer.borderWidth = 1
        confirmPasswordTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        confirmPasswordTF.layer.masksToBounds = true
        
        dobButton.layer.cornerRadius = 20
        dobButton.layer.borderWidth = 1
        dobButton.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        dobButton.layer.masksToBounds = true
        
        choosePhotoButton.layer.cornerRadius = 20
        choosePhotoButton.layer.borderWidth = 1
        choosePhotoButton.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        choosePhotoButton.layer.masksToBounds = true
        
        addUserButton.layer.cornerRadius = 20
        addUserButton.layer.masksToBounds = true
    }
    
    private func actionSheet(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (handler) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (handler) in
            self.openGalery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        self.present(alert,animated: true)
    }
    
    private func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
    }
    private func openGalery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
    
    private func prosesRegister(){
        guard
            !nameTF.text.isNilOrEmpty,
            let name = nameTF.text
        else {
            showToast(message: "Name required")
            return
        }
        
        let nameComponents = name.split(separator: " ").map { String($0) }
        
        guard nameComponents.count >= 2 else {
            showToast(message: "Please enter both first name and last name")
            return
        }
        
        var firstName = nameComponents[0]
        let lastName = nameComponents[nameComponents.count-1]
        
        if nameComponents.count > 2 {
            firstName = nameComponents.dropLast().joined(separator: " ")
        }
        guard
            !gender.isNilOrEmpty
        else{
            showToast(message: "Gender required")
            return
        }
        
        guard
            dob != nil
        else{
            showToast(message: "Date of Birth required")
            return
        }
        
        guard
            let email = emailTF.text,
            email.isValidEmail()
        else {
            showToast(message: "Input valid email")
            return
        }
        
        guard
            !phoneNumberTF.text.isNilOrEmpty,
            let phone = phoneNumberTF.text
        else{
            showToast(message: "Phone number required")
            return
        }
        
        guard
            !addressTF.text.isNilOrEmpty,
            let address = addressTF.text
        else{
            showToast(message: "Address required")
            return
        }
        
        guard
            photoProfile != nil
        else{
            showToast(message: "Photo profile required")
            return
        }
        
        guard
            !passwordTF.text.isNilOrEmpty,
            let password = passwordTF.text,
            Functions.isValidPassword(password: password)
        else {
            showToast(message: "Password must be at least 8 characters long, contain a number, a lowercase letter, an uppercase letter")
            return
        }
        
        guard
            !confirmPasswordTF.text.isNilOrEmpty,
            let confirmPass = confirmPasswordTF.text,
            confirmPass == password
        else {
            showToast(message: "Password not match")
            return
        }
        
        let inputData = password.data(using: .utf8)!
        let hashString = Functions.hash(data: inputData)
        
        showLoading(true)
        viewModel.registerUser(first_name: firstName, last_name: lastName, gender: gender ?? "", date_of_birth: dob ?? "", email: email, phone: phone, address: address, photo: photoProfile!, password: hashString){ [weak self] message, success in
            guard let self = self else {return}
            showLoading(false)
            showToast(message: message ?? (success ? "" : "unknown error"))
            
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                    self.completion?()
                }
            }
            
            
        }
        
    }
    
}

extension RegistrationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            showToast(message: "Image required")
            picker.dismiss(animated: true)
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            showToast(message: "Image format must be JPG/JPEG")
            picker.dismiss(animated: true)
            return
        }
        
        let imageSizeMB = Double(imageData.count) / (1024.0 * 1024.0)
        
        guard imageSizeMB <= 5 else {
            showToast(message: "Image size must be less than 5MB")
            picker.dismiss(animated: true)
            return
        }
        
        let imageURL = info[.imageURL] as? URL
        let imageFilename = imageURL?.lastPathComponent ?? "\(UUID().uuidString).jpeg"
        choosePhotoButton.setTitle(imageFilename, for: .normal)
        choosePhotoButton.setFont(size: 14, weight: .regular)
        choosePhotoButton.setTitleColor(.black, for: .normal)
        
        photoProfile = imageURL
        
        picker.dismiss(animated: true)
        
    }
}
