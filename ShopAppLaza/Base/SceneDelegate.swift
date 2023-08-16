//
//  SceneDelegate.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 25/07/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//    private let screen2VM = Screen2ViewModel()
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Pastikan ini adalah UIWindowScene
//               guard let windowScene = (scene as? UIWindowScene) else { return }
//
//               // Inisialisasi window
//               let window = UIWindow(windowScene: windowScene)
//               self.window = window
//
//               // Buat instance dari ViewController sesuai kebutuhan Anda
//               let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
//               let storyboardTabBar = UIStoryboard(name: "TabBar", bundle: nil)
//               let initialViewController: UIViewController
//
//               let isLoggedIn = screen2VM.isLoggedIn() // Ganti screen2VM dengan instance yang sesuai
//               if isLoggedIn {
//                   // Jika pengguna sudah login, arahkan ke TabBarController
//                   initialViewController = storyboardTabBar.instantiateViewController(withIdentifier: "TabBarControllerViewController")
//               } else {
//                   // Jika pengguna belum login, arahkan ke ViewController lain atau sesuai kebutuhan
//                   initialViewController = storyboardMain.instantiateViewController(withIdentifier: "LoginViewController")
//               }
//
//               // Set root view controller
//               window.rootViewController = initialViewController
//
//               // Tampilkan window
//               window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

