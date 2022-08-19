//
//  LoginViewController.swift
//  Plog
//
//  Created by HR on 2022/08/08.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {
    
    var nickname: String!
    var profileImage: UIImage!
    
    @IBAction func kakaoLoginBtn(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오 로그인 성공")
                    // do something
                    _ = oauthToken
                    // 로그인 관련 메소드 추가
                    let accessToken = oauthToken?.accessToken
                    
                    // 카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                    self.setUserInfo()
                    self.goToTabBarController()
                }
            }
        }
        // 카카오 계정으로 로그인
        else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오 로그인 성공")
                    
                    // do something
                    _ = oauthToken
                    // 로그인 관련 메소드 추가
                    let accessToken = oauthToken?.accessToken
                    
                    // 카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                    self.setUserInfo()
                    self.goToTabBarController()
                }
            }
        }
    }
    
    func setUserInfo() {
                UserApi.shared.me() {(user, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("me() success.")
                        //do something
                        _ = user
                        self.nickname = user?.kakaoAccount?.profile?.nickname
                        print("nickname: \(String(describing: self.nickname))")
                        
//                        if let url = user?.kakaoAccount?.profile?.profileImageUrl,
//                            let data = try? Data(contentsOf: url) {
//                            self.profileImage = UIImage(data: data)
//                        }
                    }
                }
            }
        
    func goToTabBarController() {
        let newVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
        newVC.modalPresentationStyle = .fullScreen // 전체화면으로 보이게
        newVC.modalTransitionStyle = .crossDissolve // 전환 애니메이션 설정
        self.present(newVC, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}


//// 로그아웃
//UserApi.shared.logout {(error) in
//    if let error = error {
//        print(error)
//    }
//    else {
//        print("로그아웃 성공")
//    }
//}
