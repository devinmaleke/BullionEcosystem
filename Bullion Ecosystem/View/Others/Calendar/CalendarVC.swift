//
//  CalendarVC.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import UIKit

class CalendarVC: UIViewController {
    
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var completion: ((Date)->Void)?
    
    private var date : Date?
    
    init(date: Date) {
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        dismissView.backgroundColor = .black.withAlphaComponent(0.5)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDismiss))
        dismissView.addGestureRecognizer(tapGesture)
        
        datePicker.date = date ?? Date()
    }
    
    @objc func viewDismiss() {
        dismiss(animated: true)
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        dismiss(animated: true){[weak self] in
            self?.completion?(self?.datePicker.date ?? Date())
        }
    }
    
}

