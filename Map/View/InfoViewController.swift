//
//  InfoViewController.swift
//  Map
//
//  Created by Евгений Фирман on 28.08.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    var temperatureLabel = UILabel()
    var regionLabel = UILabel()
    var buttonReset = UIButton()
    var spinner = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        initialize()
    }
    
// MARK: - Initialize Function
    
    private func initialize() {
        
        view.backgroundColor = UIColor(red: 0/250, green: 0/250, blue: 0/250, alpha: 0.8)
        
        view.layer.cornerRadius = 30
        
        addTempLabel()
        
        addRegionLabel()
        
        addButtonReset()
        
        addSpinner()
    }
  
    
// MARK: - Add Temperature Label
    
    private func addTempLabel() {
        
        view.addSubview(temperatureLabel)
        
        temperatureLabel.font = UIFont.systemFont(ofSize: 90,weight: .thin)
        
        temperatureLabel.textColor = .white
        
        temperatureLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.view).offset(20)
            maker.left.equalTo(self.view).offset(40)
            
        }
    }
    
// MARK: - Add Region Label
    
    private func addRegionLabel() {
        
        view.addSubview(regionLabel)
        
        regionLabel.font = UIFont.systemFont(ofSize: 30,weight: .thin)
        
        regionLabel.textColor = .white
        
        regionLabel.snp.makeConstraints { maker in
            
            maker.top.equalTo(temperatureLabel.snp.bottom).offset(10)
            
            maker.left.equalTo(self.view).offset(40)
            
        }
    }
   
    
// MARK: - Add ButtonReset
    private func addButtonReset() {
        
        // Config reset button
        view.addSubview(buttonReset)

        buttonReset.clipsToBounds = true
        
        buttonReset.layer.cornerRadius = 30.0
        
        // Config Refresh Icon
        let boldConfig = UIImage.SymbolConfiguration(pointSize: 40)
        
        let boldXmark = UIImage(systemName: "arrow.clockwise", withConfiguration: boldConfig)
        
        buttonReset.tintColor = .black
        
        buttonReset.setImage(boldXmark, for: .normal)
        
        // Background button color
        buttonReset.setBackgroundColor(UIColor(red: 255/255, green: 173/255, blue: 7/255, alpha: 1), forState: .normal)
        
        buttonReset.setBackgroundColor(UIColor(red: 242/250, green: 204/250, blue: 93/250, alpha: 1), forState: .highlighted)
        
        buttonReset.snp.makeConstraints { maker in
            
            maker.top.equalTo(self.view.snp.top).offset(30)
            
            maker.right.equalTo(self.view).offset(-40)
            
            maker.width.equalTo(100)
            
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        
        }
        
        buttonReset.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    
    @objc func buttonTapped(){
        
    
    }
    
// MARK: - Add Spinnner
    func addSpinner() {
        
        view.addSubview(spinner)
        
        spinner.style = UIActivityIndicatorView.Style.large
        
        spinner.color = .white
        
        spinner.snp.makeConstraints { maker in
            
            maker.centerY.equalTo(self.view)
            
            maker.left.equalTo(90)
        }
        spinner.startAnimating()
    }
    
// MARK: - Func Remove Spinner
    
    func removeSpinner() {
        
        spinner.removeFromSuperview()
    }
}



