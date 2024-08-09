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
        var client = NetworkingClient(baseURL: DynamicValues.baseURL)
        client.timeout = 20
        client.logLevels = .debug
        client.parameterEncoding = .json
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

    // MARK: Sign in / Sign up

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

    func addNewChild(_ request: RegisterNewChildRequest) -> AnyPublisher<DefaultResponseAIM, Error> {
        post(URLs.NEW_RELATION_REGISTRATION, params: ["firstName": request.firstName,
                                                      "lastName": request.lastName,
                                                      "title": request.title,
                                                      "gender": request.gender,
                                                      "dob": request.dob,
                                                      "os": request.os,
                                                      "apiKey": request.apiKey,
                                                      "memberId": request.memberId,
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
 

    func getOrderId(trxId: String, amount: Int) -> AnyPublisher<BaseResponse<OrderIdResponse>, Error> {
        post(URLs.RAZOR_PAY_ORDER_ID, params: ["trxId": trxId,
                                               "amount": amount])
    }

    // MARK: User  APIs

    func forgetPassword(emailAddress: String, apiKey: String) -> AnyPublisher<DefaultResponseAIM, Error> {
        post(URLs.FORGOT_PASSWORD, params: ["emailAddress": emailAddress,
                                            "apiKey": apiKey])
    }

    func getDistricts(withStateId stateId: Int) -> AnyPublisher<BaseResponse<DistrictResponse>, Error> {
        get("\(URLs.DISTRICTS)/\(stateId)")
    }

    func getStates() -> AnyPublisher<BaseResponse<StateResponse>, Error> {
        get(URLs.STATES)
    }

    func getSportList() -> AnyPublisher<BaseResponse<SportsListResponse>, Error> {
        get(URLs.SPORTS)
    }

    func checkEmailOnServer(emailAddress: String, apiKey: String) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.VALIDATE_EMAIL, params: ["emailAddress": emailAddress,
                                          "apiKey": apiKey])
    }

    func checkMobileOnServer(mobile: String, apiKey: String) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.VALIDATE_MOBILE, params: ["mobile": mobile,
                                           "apiKey": apiKey])
    }

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

    func getDocuments() -> AnyPublisher<BaseResponse<DocumentListResponse>, Error> {
        get(URLs.DOCUMENT_LIST)
    }

    func sendPaymentTransaction(request: PaymentTransaction) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.PAYMENT_CONFIRMED, params: ["apiKey": request.apiKey,
                                             "memberid": request.memberid,
                                             "paymentMethod": request.paymentMethod,
                                             "TXNID": request.TXNID,
                                             "BANKNAME": request.BANKNAME,
                                             "BANKTXNID": request.BANKTXNID,
                                             "CURRENCY": request.CURRENCY,
                                             "GATEWAYNAME": request.GATEWAYNAME,
                                             "MID": request.MID,
                                             "ORDERID": request.ORDERID,
                                             "PAYMENTMODE": request.paymentMethod,
                                             "RESPCODE": request.RESPCODE,
                                             "RESPMSG": request.RESPMSG,
                                             "STATUS": request.STATUS])
    }

    func getMemberProfile() -> AnyPublisher<BaseResponse<MemberProfileResponse>, Error> {
        get(URLs.MEMBER_PROFILE_INFO)
    }

    func updateMemberProfile(firstName: String, lastName: String, title: String, gender: String, dob: String) -> AnyPublisher<BaseResponse<EmptyData>, Error> {
        post(URLs.UPDATE_MEMBER_PROFILE_INFO, params: ["firstName": firstName,
                                                       "lastName": lastName,
                                                       "title": title,
                                                       "gender": gender,
                                                       "dob": dob])
    }

    // MARK: User Address

    func getAddresses() -> AnyPublisher<BaseResponse<AddressListResponse>, Error> {
        get(URLs.ADDRESSES)
    }

    func makeDefaultAddress(objectId: Int) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.SET_DEFAULT_ADDRESS, params: ["apiKey": UserDefaults.jwtKey,
                                               "memberId": UserDefaults.memberId,
                                               "objectId": objectId])
    }

    func deleteAddress(objectId: Int) -> AnyPublisher<DefaultResponseAIM, Error> {
        get(URLs.DELETE_ADDRESS, params: ["apiKey": UserDefaults.jwtKey,
                                          "memberId": UserDefaults.memberId,
                                          "objectId": objectId])
    }

    func addAddress(memberId: Int, apiKey: String, countryId: String, stateId: Int, districtId: Int, city: String, postalCode: String, streetAddress: String, addressType: String) -> AnyPublisher<DefaultResponseAIM, Error>
    {
        get(URLs.ADD_ADDRESS, params: ["memberId": memberId,
                                       "apiKey": apiKey,
                                       "countryId": countryId,
                                       "stateId": stateId,
                                       "districtId": districtId,
                                       "city": city,
                                       "postalcode": postalCode,
                                       "streetAddress": streetAddress,
                                       "addressType": addressType])
    }

    func updateAddress(memberId: Int, apiKey: String, countryId: String, stateId: Int, districtId: Int, city: String, postalCode: String, streetAddress: String, addressType: String, addressId: Int) -> AnyPublisher<DefaultResponseAIM, Error>
    {
        get(URLs.UPDATE_ADDRESS, params: ["memberId": memberId,
                                          "apiKey": apiKey,
                                          "countryId": countryId,
                                          "stateId": stateId,
                                          "districtId": districtId,
                                          "city": city,
                                          "postalcode": postalCode,
                                          "streetAddress": streetAddress,
                                          "addressType": addressType,
                                          "objectId": addressId])
    }

    // MARK: Tournament APIs

    func getTournaments(circleId: Int) -> AnyPublisher<BaseResponse<TournamentListResponse>, Error> {
        get(URLs.TOURNAMENTS.appending(circleId.string))
    }

    func getTournamentCategories(tournamentId: Int) -> AnyPublisher<BaseResponse<TournamentCategoryListResponse>, Error> {
        get(URLs.TOURNAMENT_CATEGORIES.appending(tournamentId.string))
    }

    func getTournamentRules(tournamentId: Int) -> AnyPublisher<BaseResponse<TournamentRulesResponse>, Error> {
        get(URLs.TOURNAMENT_RULES.appending(tournamentId.string))
    }

    func getMyMatches(matchType: String) -> AnyPublisher<BaseResponse<MyMatchesListResponse>, Error> {
        get(URLs.MATCH_LIST, params: ["matchStatus": matchType])
    }

    func getMyWall() -> AnyPublisher<BaseResponse<MyWallResponse>, Error> {
        get(URLs.MY_WALL)
    }
}
