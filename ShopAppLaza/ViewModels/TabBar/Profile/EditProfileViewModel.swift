//
//  ProfileViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 16/08/23.
//
import UIKit

class EditProfileViewModel {
    var profileViewCtr: EditProfileViewController?
    var loading: (() -> Void)?
    
    func putRequest(image: UIImage, accessTokenKey: String, fullname: String, username: String, email: String) {
        print("Calling putRequest...")
        guard let unwrappedVC = profileViewCtr else { return }
        let parameters = ["full_name": fullname,
                          "username": username,
                          "email": email,
        ]
        guard let mediaImage = Media(withImage: image, forKey: "image") else {
            print("Media creation failed")
            return }
        
        guard let url = URL(string: "https://lazaapp.shop/user/update") else {
            print("Invalid URL")
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        let dataBody = createDataBody(withParameters: parameters, media: mediaImage, boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print("ini session response: \(response)")
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                            DispatchQueue.main.async {
                                self.loading?()
                                unwrappedVC.showAlert(title: "Profile Data Changed", message: "Successfully changed your data profile") {
                                    unwrappedVC.backBtn()
                                }
                            }
                            print("ini data response: \(json)")
                        }
                    }
                } catch {
                    print("ini error response: \(error)")
                }
            }
            if let error = error {
                print("Error: \(error)")
            }
        }.resume()
    }
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: Media?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let media = media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.filename)\"\(lineBreak)")
            body.append("Content-Type: \(media.mimeType + lineBreak + lineBreak)")
            body.append(media.data)
            body.append(lineBreak)
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
