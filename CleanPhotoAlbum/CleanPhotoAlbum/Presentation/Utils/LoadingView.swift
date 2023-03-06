//
//  LoadingView.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 03/03/23.
//

import UIKit

public class LoadingView {

    internal static var spinner: UIActivityIndicatorView?

    public static func show() {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
            var window: UIWindow?
            if #available(iOS 13.0, *) {
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                window = windowScene?.windows.first
            } else {
                // Fallback on earlier versions
                window = UIApplication.shared.keyWindow
            }
            
            if spinner == nil, let window = window {
                let frame = UIScreen.main.bounds
                let spinner = UIActivityIndicatorView(frame: frame)
                spinner.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                spinner.style = .large
                window.addSubview(spinner)

                spinner.startAnimating()
                self.spinner = spinner
            }
        }
    }

    public static func hide() {
        DispatchQueue.main.async {
            guard let spinner = spinner else { return }
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            self.spinner = nil
        }
    }

    @objc public static func update() {
        DispatchQueue.main.async {
            if spinner != nil {
                hide()
                show()
            }
        }
    }
}
