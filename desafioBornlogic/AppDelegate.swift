//
//  AppDelegate.swift
//  desafioBornlogic
//
//  Created by Marcos Henrique Rossi Paes on 13/05/24.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Crie uma nova UIWindow com o tamanho da tela do dispositivo
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // Defina o controlador de navegação com o controlador de vista inicial
        let initialViewController = ArticlesViewController()
        let navigationController = UINavigationController(rootViewController: initialViewController)

        // Defina o rootViewController da UIWindow para o navigationController
        self.window?.rootViewController = navigationController

        // Faça esta UIWindow visível
        self.window?.makeKeyAndVisible()

        return true
    }
}

