//
//  WallPostProvider.swift
//  VK Client
//
//  Created by Денис Львович on 20.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

class WallPostProvider {
    
    let router: Router

    init(withRouter router: Router) {
        self.router = router
    }

    func upload(photoToVK image: UIImage, completion: @escaping (_ imageObject: SaveImageResponseVK.Success) -> Void) {

        let queue = DispatchQueue.global(qos: .userInitiated)

        Promise { seal in
            queue.async {
                self.getPhotosServer().pipe(to: seal.resolve) }
            }.then(on: queue) { url in
                self.upload(photo: image, toUrl: url)
            }.then(on: queue) { response in
                self.savePhoto(withParams: response)
            }.done(on: DispatchQueue.main) { imageObjectVK in
                completion(imageObjectVK)
            }.catch { error in
                assertionFailure(error.localizedDescription)
        }
    }

    private func getPhotosServer() -> Promise<URL> {

        return Promise { seal in

            let config = self.router.getRequestConfig(byRequestType: .getPhotoServer)
            Alamofire.request(config.url, method: .get, parameters: config.params)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        do {
                            guard let data = response.data else {
                                let error = StringErrors(errorCode: nil, description: "В ответе сервера отсутствуют данные")
                                seal.reject(error)
                                return
                            }
                            let responseObject = try JSONDecoder().decode(UploadServerResponseVK.self, from: data)

                            if let successResponse = responseObject.successResponse,
                                let url = URL(string: successResponse.url)
                            {
                                seal.fulfill(url)
                            } else if let errorResponse = responseObject.error {
                                let error = StringErrors(errorCode: errorResponse.code, description: errorResponse.message)
                                seal.reject(error)
                            } else {
                                assertionFailure("Этого не может быть!")
                                let error =  StringErrors(errorCode: nil, description: "Неожиданный ответ от сервера. Что-то не то с парсером.")
                                seal.reject(error)
                            }
                        } catch {
                            assertionFailure()
                            seal.reject(error)
                        }

                    case .failure:
                        seal.reject(response.error!)
                    }
            }
        }
    }

    private func upload(photo: UIImage, toUrl url: URL) -> Promise<UploadFileResponseVK> {

        return Promise { seal in
            Alamofire.upload(
                multipartFormData: { multipartFormData in

                    multipartFormData.append(photo.jpegToData!, withName: "photo", fileName: "swift_file.jpeg", mimeType: "image/jpeg")

            }, to: url) { result in

                switch result {
                case .success(let upload, _, _):
                    upload.validate()
                        .responseJSON { response in
                            do {
                                guard let data = response.data else {
                                    let error = StringErrors(errorCode: nil, description: "В ответе сервера отсутствуют данные")
                                    seal.reject(error)
                                    return
                                }
                                let responseObject = try JSONDecoder().decode(UploadFileResponseVK.self, from: data)
                                seal.fulfill(responseObject)
                            } catch {
                                assertionFailure()
                                seal.reject(error)
                            }
                    }

                case .failure(let encodingError):
                    seal.reject(encodingError)
                }
            }
        }
    }

    private func savePhoto(withParams params: UploadFileResponseVK) -> Promise<SaveImageResponseVK.Success> {
        return Promise { seal in

            let config = self.router.getRequestConfig(byRequestType: .saveWallPhoto)
            let url = URL(string: "https://api.vk.com/method/photos.saveWallPhoto")!
            var requestParams: [String: Any] = ["photo": params.photo, "server": params.server, "hash": params.hash]
            requestParams.update(other: config.params)

            Alamofire.request(url, method: .post, parameters: requestParams)
                .validate()
                .responseJSON { response in

                    switch response.result {
                    case .success:
                        do {
                            guard let data = response.data else {
                                let error = StringErrors(errorCode: nil, description: "В ответе сервера отсутствуют данные")
                                assertionFailure(error.localizedDescription)
                                seal.reject(error)
                                return
                            }

                            let responseObject = try JSONDecoder().decode(SaveImageResponseVK.self, from: data)
                            if let successResponse = responseObject.successResponse
                            {
                                seal.fulfill(successResponse[0])
                            } else if let errorResponse = responseObject.error {
                                let error = StringErrors(errorCode: errorResponse.code, description: errorResponse.message)
                                seal.reject(error)
                            } else {
                                assertionFailure("Этого не может быть!")
                                let error =  StringErrors(errorCode: nil, description: "Неожиданный ответ от сервера. Что-то не то с парсером.")
                                seal.reject(error)
                            }
                        } catch {
                            assertionFailure()
                            seal.reject(error)
                        }

                    case .failure:
                        seal.reject(response.error!)
                    }
            }
        }
    }

    func post(withParams params: [String: Any], completion: @escaping (_ success: Bool, _ error: PostResponseVK.Error?) -> Void) {

        var config = self.router.getRequestConfig(byRequestType: .messagePost)
        config.params.update(other: params)

        Alamofire.request(config.url, method: .get, parameters: config.params)
            .validate()
            .responseData(queue: .global(qos: .userInitiated)) { response in

                guard
                    let data = response.value,
                    let response = try? JSONDecoder().decode(PostResponseVK.self, from: data)
                    else {
                        assertionFailure()
                        return
                }

                if response.response != nil  {
                    DispatchQueue.main.async { completion(true, nil) }
                } else if let error = response.error {
                    DispatchQueue.main.async { completion(false, error) }
                } else {
                    assertionFailure("Этого не может быть!")
                    DispatchQueue.main.async { completion(false, nil) }
                }
        }
    }

    struct StringErrors : LocalizedError
    {
        var errorDescription: String? { return msg }
        var errorCode: Int? { return code }

        private var code: Int?
        private var msg: String

        init(errorCode: Int?, description: String)
        {
            code = errorCode
            msg = description
        }
    }
}
