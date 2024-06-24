//
//  EditUserVC.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 21/06/24.
//

import UIKit

class EditUserVC: UIViewController {
    
    
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
    @IBOutlet weak var photoProfileButton: UIButton!
    
    @IBOutlet weak var updateUserButton: UIButton!
    
    private lazy var viewModel = EditUserVM()
    var completion: (() -> Void)?
    
    var gender: String?
    var dob : String?
    
    private var data : UserDetailModel?
    
    init(data: UserDetailModel) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        botView.roundCorners(corners: [.topLeft, .topRight], radius: 24)
        
    }
    
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == backButton{
            self.dismiss(animated: true, completion: nil)
        }else if sender == maleButton{
            sender.setImage(UIImage(named: "Checkbox_Check"), for: .normal)
            femaleButton.setImage(UIImage(named: "Checkbox_Uncheck"), for: .normal)
            gender = "male"
        }else if sender == femaleButton{
            sender.setImage(UIImage(named: "Checkbox_Check"), for: .normal)
            maleButton.setImage(UIImage(named: "Checkbox_Uncheck"), for: .normal)
            gender = "female"
        }else if sender == dobButton{
            let date = Functions.dateFromString(dob ?? "") ?? Date()
            let vc = CalendarVC(date: date)
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
        }else if sender == photoProfileButton{
            let vc = TapImageVC(image: Functions.convertUTF64ToImage(stringIMG: data?.photo ?? ""))
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
        }else if sender == updateUserButton{
            updateUser()
        }
    }
    
    
    private func setupUI(){
        topView.setGradientBackground(colorOne: UIColor.init(hex: "F05A2A"), colorTwo: UIColor.init(hex: "F89576"))
        
        nameTF.layer.cornerRadius = 20
        nameTF.layer.borderWidth = 1
        nameTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        nameTF.layer.masksToBounds = true
        nameTF.text = "\(data?.first_name ?? "") \(data?.last_name ?? "")"
        
        emailTF.layer.cornerRadius = 20
        emailTF.layer.borderWidth = 1
        emailTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        emailTF.layer.masksToBounds = true
        emailTF.text = data?.email
        
        phoneNumberTF.layer.cornerRadius = 20
        phoneNumberTF.layer.borderWidth = 1
        phoneNumberTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        phoneNumberTF.layer.masksToBounds = true
        phoneNumberTF.text = data?.phone
        
        addressTF.layer.cornerRadius = 20
        addressTF.layer.borderWidth = 1
        addressTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        addressTF.layer.masksToBounds = true
        addressTF.text = data?.address
        
        dobButton.layer.cornerRadius = 20
        dobButton.layer.borderWidth = 1
        dobButton.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        dobButton.layer.masksToBounds = true
        
        dob = data?.date_of_birth
        dobButton.setTitle(dob?.toFormattedDate(format: "dd MMM YYYY"), for: .normal)
        dobButton.setFont(size: 14, weight: .regular)
        dobButton.setTitleColor(.black, for: .normal)
        
        
        gender = data?.gender
        if gender == "male" {
            maleButton.setImage(UIImage(named: "Checkbox_Check"), for: .normal)
        }else{
            femaleButton.setImage(UIImage(named: "Checkbox_Check"), for: .normal)
        }
        
        let imageFilename = Functions.convertUTF64ToImage(stringIMG: data?.photo ?? "")
        
        photoProfileButton.layer.cornerRadius = 20
        photoProfileButton.layer.borderWidth = 1
        photoProfileButton.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        photoProfileButton.layer.masksToBounds = true
        
        updateUserButton.layer.cornerRadius = 20
        updateUserButton.layer.masksToBounds = true
    }
    
    private func updateUser(){
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
            let userId = data?._id,
            let currentFirstName = data?.first_name,
            let currentLastName = data?.last_name,
            let currentGender = data?.gender,
            let currentDOBString = data?.date_of_birth,
            let currentDOB = Functions.dateFromString(currentDOBString),
            let currentEmail = data?.email,
            let currentPhone = data?.phone,
            let currentAddress = data?.address
        else {
            return
        }
        
        let selectedDOB = dob.flatMap { Functions.dateFromString($0) }
        
        let calendar = Calendar.current
        let currentDOBDateOnly = calendar.startOfDay(for: currentDOB)
        let selectedDOBDateOnly = selectedDOB.flatMap { calendar.startOfDay(for: $0) }
        
        if nameTF.text == "\(currentFirstName) \(currentLastName)",
           gender == currentGender,
           selectedDOBDateOnly == currentDOBDateOnly,
           emailTF.text == currentEmail,
           phoneNumberTF.text == currentPhone,
           addressTF.text == currentAddress {
            showToast(message: "No data change")
            return
        }
        
        updateUserButton.isEnabled = false
        viewModel.updateUser(id: userId, first_name: firstName, last_name: lastName, gender: gender ?? "", date_of_birth: dob ?? "", email: email, phone: phone, address: address)
        { [weak self] message, success in
            guard let self = self else {return}
            updateUserButton.isEnabled = true
            showToast(message: message ?? (success ? "" : "unknown error"))
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.dismiss(animated: false)
                    self.view.dismissLeftRight()
                    self.completion?()
                }
            }
            
        }
        
        
        
    }
    
    
}
