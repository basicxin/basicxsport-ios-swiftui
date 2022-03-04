//
//  API.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 12/01/22.
//

import Combine
import Foundation
import Networking

class NetworkSetup {
    lazy var network: NetworkingClient = {
        var client = NetworkingClient(baseURL: URLs.BASE_URL)
        client.timeout = 20
        client.logLevels = .debug
        client.parameterEncoding = ParameterEncoding.json
        let token = UserDefaults.jwtKey
        let memberId = UserDefaults.memberId
        let isLoggedIn = UserDefaults.isLoggedIn
        if !token.isEmpty, isLoggedIn {
            client.headers["Authorization"] = token
            client.headers["memberId"] = memberId.description
        } else {
            client.headers["Authorization"] = "Bearer \(Constants.DEFAULT_TOKEN)"
        }

        return client
    }()
}

struct API: NetworkingService {
    var network = NetworkSetup().network

    var cancellables: Set<AnyCancellable> = []

    // MARK: Login / Forget Password

    func login(_ request: SignInRequest) -> AnyPublisher<BaseResponse<SignInResponse>, Error> {
        post(URLs.SIGN_IN, params: ["emailAddress": request.emailAddress,
                                    "password": request.password,
                                    "os": request.os,
                                    "appVer": request.appVer,
                                    "deviceType": request.deviceType,
                                    "fcmToken": request.fcmToken])
    }

    func forgetPassword(emailAddress: String, apiKey: String) -> AnyPublisher<DefaultResponseAIM, Error> {
        post(URLs.FORGOT_PASSWORD, params: ["emailAddress": emailAddress,
                                            "apiKey": apiKey])
    }

    // MARK: Sign in / Sign up

    func getDistricts(withStateId stateId: Int) -> AnyPublisher<BaseResponse<DistrictResponse>, Error> {
        get("\(URLs.DISTRICTS)/\(stateId)")
    }

    func getStates() -> AnyPublisher<BaseResponse<StateResponse>, Error> {
        get(URLs.STATES)
    }

    func getSportList() -> AnyPublisher<BaseResponse<SportsListResponse>, Error> {
        get(URLs.SPORTS)
    }

    func getOTP(mobile: String, apiKey: String) -> AnyPublisher<MobileOtpResponse, Error> {
        get(URLs.MOBILE_OTP, params: ["mobile": mobile, "apiKey": apiKey])
    }

    func validateOTPForSignup(otpCodeId: Int, otp: String, apiKey: String) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.VALIDATE_OTP_FOR_SIGNUP, params: ["objectId": otpCodeId,
                                                   "otp": otp,
                                                   "apiKey": apiKey])
    }

    func signup(_ request: RegisterNewUserRequest) -> AnyPublisher<SignUpResponse, Error> {
        post(URLs.SIGN_UP, params: ["firstName": request.firstName,
                                    "lastName": request.lastName,
                                    "title": request.title,
                                    "gender": request.gender,
                                    "emailAddress": request.emailAddress,
                                    "password": request.password,
                                    "mobile": request.mobile,
                                    "dob": request.dob,
                                    "os": request.os,
                                    "token": request.token,
                                    "deviceType": request.deviceType,
                                    "appVer": request.appVer,
                                    "apiKey": request.apiKey,
                                    "sportId": request.sportId,
                                    "stateId": request.stateId,
                                    "districtId": request.districtId])
    }

    // MARK: News

    func getNews(isNew: Bool, time: Int64) -> AnyPublisher<BaseResponse<NewsResponse>, Error> {
        get(URLs.NEWS, params: ["isNews": isNew, "time": time])
    }

    // MARK: Circles

    func getCircles(name: String) -> AnyPublisher<BaseResponse<SearchCircleResponse>, Error> {
        get(URLs.CIRCLE_SEARCH, params: ["name": name])
    }

    func getCirclesInfo(circleId: Int) -> AnyPublisher<BaseResponse<CircleInfoResponse>, Error> {
        get(URLs.CIRCLE_INFO+"/"+circleId.string)
    }

    func getPreferedSport() -> AnyPublisher<BaseResponse<SportsListResponse>, Error> {
        get(URLs.SPORTS)
    }

    func updatePreferedSport(sportId: Int) -> AnyPublisher<BaseResponse<EmptyData>, Error> {
        post(URLs.UPDATE_PREFERRED_SPORT, params: ["sportId": sportId])
    }

    // MARK: My Circle

    func getMyCircle() -> AnyPublisher<BaseResponse<MyCircleResponse>, Error> {
        get(URLs.MY_CIRCLE_SCREEN)
    }

    func changePreferredCircle(circleId: Int) -> AnyPublisher<BaseResponse<EmptyData>, Error> {
        post(URLs.UPDATE_PREFERRED_CIRCLE, params: ["circleId": circleId])
    }

    // MARK: Shop

    func getShopProduct() -> AnyPublisher<BaseResponse<ShopResponse>, Error> {
        get(URLs.SHOP_PRODUCTS, params: ["pageNo": "1"])
    }

    func getShopProductDetail(productId: Int) -> AnyPublisher<BaseResponse<ShopProductDetailResponse>, Error> {
        get(URLs.SHOP_PRODUCT_DETAIL+"/"+productId.string)
    }

    func addToCart(apiKey: String, memberId: Int, objectId: Int, itemType: String) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.ADD_TO_CART, params: ["apiKey": apiKey,
                                       "memberId": memberId,
                                       "objectId": objectId,
                                       "itemType": itemType])
    }

    func getCart(cartType: String) -> AnyPublisher<BaseResponse<CartResponse>, Error> {
        get(URLs.CART+"/"+cartType)
    }

    func changeCartItemQuantity(apiKey: String, memberId: Int, lineItemId: Int, qty: Int) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.UPDATE_CART_ITEM_QUANTITY, params: ["apiKey": apiKey,
                                                     "memberId": memberId,
                                                     "lineItemId": lineItemId,
                                                     "qty": qty])
    }

    func removeItemFromCart(apiKey: String, memberId: Int, lineItemId: Int, objectId: Int) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.REMOVE_CART_ITEM, params: ["apiKey": apiKey,
                                            "memberId": memberId,
                                            "lineItemId": lineItemId,
                                            "objectId": objectId])
    }

    // MARK: Gallery List

    func getGalleryList() -> AnyPublisher<BaseResponse<GalleryResponse>, Error> {
        get(URLs.GALLERY)
    }

    // MARK: Payment

    func getPaytmToken(orderId: String, callbackUrl: String, value: String, currency: String, custId: String) -> AnyPublisher<BaseResponse<PaytmTokenResponse>, Error> {
        post(URLs.PAYTM_TOKEN, params: ["orderId": orderId,
                                        "callbackUrl": callbackUrl,
                                        "value": value,
                                        "currency": currency,
                                        "custId": custId])
    }

    // MARK: User  APIs

    func changePassword(newPassword: String, oldPassword: String) -> AnyPublisher<BaseResponse<EmptyData>, Error> {
        post(URLs.CHANGE_PASSWORD, params: ["newPassword": newPassword,
                                            "oldPassword": oldPassword])
    }

    func getUserBadge() -> AnyPublisher<BaseResponse<UserBadgeResponse>, Error> {
        get(URLs.GET_BADGE_DETAILS)
    }

    func getPromoCodes() -> AnyPublisher<BaseResponse<PromoCodesResponse>, Error> {
        get(URLs.PROMO_CODES)
    }

    func applyCoupon(apiKey: String, memberId: Int, couponCode: String, salesId: Int) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.APPLY_PROMO_CODE, params: ["apiKey": apiKey,
                                            "memberId": memberId,
                                            "couponCode": couponCode,
                                            "objectId": salesId])
    }

    func clearCouponCode(apiKey: String, memberId: Int, objectId: Int) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.CLEAR_PROMO_CODE, params: ["apiKey": apiKey,
                                            "memberId": memberId,
                                            "objectId": objectId])
    }

    func getOrderHistory(pageNo: Int) -> AnyPublisher<BaseResponse<OrderHistoryResponse>, Error> {
        get(URLs.ORDER_HISTORY, params: ["pageNo": pageNo])
    }
}
