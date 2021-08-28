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
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        initialize()
    }
    
// MARK: - Initialize Function
    
    private func initialize() {
        
        view.backgroundColor = UIColor(red: 2/250, green: 29/250, blue: 64/250, alpha: 0.9)
        
        view.layer.cornerRadius = 30
        
        addTempLabel()
        
        addRegionLabel()
        
        addButtonReset()
        
    }
  
    
// MARK: - Add Temperature Label
    
    private func addTempLabel() {
        
        view.addSubview(temperatureLabel)
        
        temperatureLabel.text = "20˚"
        
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
        
        regionLabel.text = "Murino"
        
        regionLabel.font = UIFont.systemFont(ofSize: 30,weight: .thin)
        
        regionLabel.textColor = .white
        
        regionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(temperatureLabel.snp.bottom).offset(10)
            maker.left.equalTo(self.view).offset(40)
            
        }
       
        
    }
   
    
// MARK: - Add ButtonReset
    private func addButtonReset() {
        
        view.addSubview(buttonReset)
        
        buttonReset.setTitle("RESET", for: .normal)
        
        buttonReset.setTitleColor(.black, for: .normal)
        
        buttonReset.setBackgroundColor(UIColor(red: 254/250, green: 207/250, blue: 153/250, alpha: 0.7), forState: .normal)
        
        buttonReset.setBackgroundColor(UIColor(red: 242/250, green: 204/250, blue: 93/250, alpha: 1), forState: .highlighted)
        
        buttonReset.snp.makeConstraints { maker in
            
            maker.top.equalTo(self.view.snp.top).offset(30)
            
            maker.right.equalTo(self.view).offset(-40)
            
            maker.left.equalTo(temperatureLabel.snp.right).offset(40)
            
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        
        }
        
        buttonReset.clipsToBounds = true
        
        buttonReset.layer.cornerRadius = 30.0
        
        buttonReset.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    @objc func buttonTapped(){
        
        
        
    }
}



