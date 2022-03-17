//
//  URLs.swift
//  BASICX SPORT
//
//  Created by Somesh K on 03/12/21.
//

import Foundation
struct URLs {
    static let BASE_URL = "https://dev.basicxsport.com/basicX/"
    private static let BASICX_LINK = "https://www.basicxsport.com/links/"
    private static let SPORTS_RESOURCES = "res/"
    private static let API_VERSION = "v1/"
    private static let AWARE_IM_RESOURCES = "REST/BXSPORTS/"

    private static let REST_API_URL = SPORTS_RESOURCES + API_VERSION
    private static let AWARE_API_URL = AWARE_IM_RESOURCES

    static let FAQ = BASICX_LINK + "faq.html"
    static let TERM_AND_CONDITION = BASICX_LINK + "tos.html"
    static let PRIVACY_POLICY = BASICX_LINK + "pp.html"
    static let ABOUT_APP = BASICX_LINK + "abs.html"

    static let DISTRICTS = REST_API_URL + "district/list"
    static let STATES = REST_API_URL + "state/list"
    static let SIGN_IN = REST_API_URL + "member/signin"
    static let NEWS = REST_API_URL + "custom/news"

    static let UPDATE_APP_VERSION = REST_API_URL + "device-info/app-ver/update"

    static let SHOP_PRODUCTS = REST_API_URL + "merchandise/list"
    static let SHOP_PRODUCT_DETAIL = REST_API_URL + "merchandise/detail/"
    static let PROMO_CODES = REST_API_URL + "coupon/list"
    static let CART = REST_API_URL + "cart/list/"
    static let PAYTM_TOKEN = REST_API_URL + "payment/paytm-token"
    static let ORDER_HISTORY = REST_API_URL + "order/history"
    static let RAZOR_PAY_ORDER_ID = REST_API_URL + "payment/razorpay-orderid/"

    static let MY_CIRCLE_SCREEN = REST_API_URL + "custom/home"
    static let CIRCLE_SEARCH = REST_API_URL + "circle/search"
    static let CIRCLE_INFO = REST_API_URL + "circle/info"
    static let GALLERY = REST_API_URL + "gallery/list"
    static let GALLERY_COMMENT = REST_API_URL + "gallery-comments/list/{galleryPhotoId}"
    static let ORGANISATION_INFO = REST_API_URL + "organization/info/{organizationId}"
    static let MY_WALL = REST_API_URL + "custom/my-wall"
    static let CIRCLE_REVIEW_LIST = REST_API_URL + "circle-review/{circleId}"

    static let UPDATE_PREFERRED_CIRCLE = REST_API_URL + "member/preferred-circle/update"

    static let MY_BATCHES = REST_API_URL + "batch-membership/list/{circleId}"

    static let DOCUMENT_UPLOAD = REST_API_URL + "member-document/upload"
    static let DOCUMENT_UPDATE = REST_API_URL + "member-document/update"
    static let DOCUMENT_LIST = REST_API_URL + "member-document/list"
    static let UPDATE_DOCUMENT_DETAIL = REST_API_URL + "member-document/info/update"

    static let TOURNAMENTS = REST_API_URL + "tournament/list/"
    static let TOURNAMENT_CATEGORIES = REST_API_URL + "tournament-category/list/"
    static let TOURNAMENT_RULES = REST_API_URL + "tournament-rules/{tournamentId}"
    static let TOURNAMENT_PLAYERS = REST_API_URL + "member/tournament-players/{tournamentCategoryId}"
    static let FIND_PLAYERS = REST_API_URL + "member/tournament-players/search/{circleId}"
    static let TEAMS = REST_API_URL + "team/list/{tournamentCategoryId}"
    static let TEAM_INFO = REST_API_URL + "team/info/{tournamentCategoryId}"
    static let TEAM_PLAYERS = REST_API_URL + "member/team-players/{teamId}"
    static let MATCH_LIST = REST_API_URL + "match/list"
    static let PLAYER_STATISTICS = REST_API_URL + "team/member-stats/{tournamentCategoryId}"
    static let MATCH_DRAWS = REST_API_URL + "match/draws/{tournamentCategoryId}"
    static let TEAM_LOGO_UPLOAD = REST_API_URL + "team/logo/upload"

    static let UPLOAD_PROFILE_PICTURE = REST_API_URL + "member/profile-pic/upload"
    static let UPDATE_PREFERRED_SPORT = REST_API_URL + "member/preferred-sport/update"
    static let UPDATE_MEMBER_PROFILE_INFO = REST_API_URL + "member/info/update"
    static let GET_BADGE_DETAILS = REST_API_URL + "member/badge/info"
    static let MEMBER_PROFILE_INFO = REST_API_URL + "member/info"
    static let SPORTS = REST_API_URL + "sport/list"
    static let ADDRESSES = REST_API_URL + "address/list"
    static let ORGANISATION_FAQ = REST_API_URL + "faq/list/{organizationId}"
    static let MEMBER_BODY_PROFILE = REST_API_URL + "member-bodydata"
    static let UPDATE_BODY_PROFILE = REST_API_URL + "member-bodydata/update"
    static let CHANGE_PASSWORD = REST_API_URL + "member/change-password"

    static let WELLNESS_SUBSCRIPTION_HISTORY = REST_API_URL + "custom/wellness/subscription-history/{circleId}"
    static let WELLNESS_REPORT_DETAIL = REST_API_URL + "wellness/report/{reportId}"
    static let WELLNESS_QUESTIONS = REST_API_URL + "wellness/questions"

    static let METFLUX_SUBMIT_ANSWERS: String = "https://metflux-basicx.herokuapp.com/health_report"

    static let FORGOT_PASSWORD = AWARE_API_URL + "forgotPassword"
    static let VALIDATE_EMAIL = AWARE_API_URL + "validateEmail"
    static let VALIDATE_MOBILE = AWARE_API_URL + "validateMobile"
    static let CHANGE_MOBILE_NO = AWARE_API_URL + "changeMobileNo"
    static let CHANGE_EMAIL_ADDRESS = AWARE_API_URL + "changeEmailAddress"
    static let MOBILE_OTP = AWARE_API_URL + "mobileOTP"
    static let VALIDATE_OTP_FOR_SIGNUP = AWARE_API_URL + "validateOTP"
    static let FEEDBACK = AWARE_API_URL + "feedback"
    static let ADD_ADDRESS = AWARE_API_URL + "addAddress"
    static let UPDATE_ADDRESS = AWARE_API_URL + "updateAddress"
    static let DELETE_ADDRESS = AWARE_API_URL + "deleteAddress"
    static let SET_DEFAULT_ADDRESS = AWARE_API_URL + "defaultAddress"
    static let DELETE_MEMBER_DOCUMENT = AWARE_API_URL + "deleteDocument"
    static let ADD_TEAM_PLAYER = AWARE_API_URL + "addTeamPlayer"
    static let UPDATE_TEAM_NAME = AWARE_API_URL + "updateTeamName"
    static let REMOVE_TEAM_PLAYER = AWARE_API_URL + "removeTeamPlayer"
    static let GALLERY_MEDIA_COMMENT = AWARE_API_URL + "galleryMediaComment"
    static let LIKE_GALLERY_PHOTO = AWARE_API_URL + "galleryMediaLike"
    static let UNLIKE_GALLERY_PHOTO = AWARE_API_URL + "galleryMediaUnlike"
    static let NEWS_LIKE = AWARE_API_URL + "likeNews"
    static let NEWS_UNLIKE = AWARE_API_URL + "unlikeNews"
    static let ADD_TO_CART = AWARE_API_URL + "addCartLineItem"
    static let UPDATE_CART_ITEM_QUANTITY = AWARE_API_URL + "updateCartLineItemQty"
    static let REMOVE_CART_ITEM = AWARE_API_URL + "removeCartItem"
    static let APPLY_PROMO_CODE = AWARE_API_URL + "applyCartPromo"
    static let CLEAR_PROMO_CODE = AWARE_API_URL + "clearCartPromo"
    static let POST_ANSWERS_SERVER = AWARE_API_URL + "addWellnessData"
    static let UPDATE_FCM_TOKEN = AWARE_API_URL + "updateFCMToken"
    static let NEW_RELATION_REGISTRATION = AWARE_API_URL + "addChildMember"
    static let SIGN_UP = AWARE_API_URL + "memberRegistration"
    static let PAYMENT_CONFIRMED = AWARE_API_URL + "paymentConfirmed"
    static let UPDATE_SPORT_CLUB_NAME = AWARE_API_URL + "memberSportClub"
    static let NEW_CIRCLE_REVIEW = AWARE_API_URL + "newCircleReview"
}
