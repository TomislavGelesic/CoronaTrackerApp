//
//  LoaderHUD.swift
//  CoronaVirusApp
//
//  Created by Ivan Simunovic on 28.04.2021..
//

import UIKit

public class LoaderOverlay {
    var loaderView: LoaderView = {
        let view = LoaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func showLoader(viewController: UIViewController) {
        viewController.navigationController?.isNavigationBarHidden = true
        viewController.view.addSubview(loaderView)
        loaderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        loaderView.startAnimation()
    }
    
    func dismissLoader() {
        loaderView.stopAnimation()
        loaderView.removeFromSuperview()
    }
}
