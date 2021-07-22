//
//  LaunchView.swift
//  KadamaVnext
//
//  Created by mobile on 22/07/21.
//

import UIKit

class LaunchView: UIViewController {
    
    
    
    let splashImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var labelPositionisLeft = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.systemBackground
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animate()
    }
    
    func setupViews(){
        view.addSubview(splashImgView)
        splashImgView.anchorCenterXToSuperview()
        splashImgView.anchor(widthConstant: 200, heightConstant: 200)
        splashImgView.anchor(bottom: self.view.bottomAnchor, bottomConstant: -200)
    }
    
    func animate() {
        
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if self.labelPositionisLeft {
                self.splashImgView.center.y = (self.view.frame.height / 2 )
            }
            else {
                self.splashImgView.center.y = 458
            }
            self.labelPositionisLeft = !(self.labelPositionisLeft)
        }, completion: { _ in
            sleep(1)
            SceneDelegate.loadHome()
        })
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
