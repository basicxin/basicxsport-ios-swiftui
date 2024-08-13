//
//  Constants.swift
//  BASICX SPORT
//
//  Created by Somesh K on 03/12/21.
//

import Foundation

struct Constants {
    static let NA = "NA"
    static let NoData = "No data available"
    static let PLACEHOLDER_IMAGE = "basicxPlaceholder"
    static let RUPEE = "₹"
    static let DEFAULT_COUNTRY_ID = "145682"
    static let DEFAULT_COUNTRY_NAME = "INDIA"

    static let ITEM_TYPE_TOURNAMENT = "TOURNAMENT"
    static let ITEM_TYPE_MERCHANDISE = "MERCHANDISE"
    static let ITEM_TYPE_SUBSCRIPTION = "SUBSCRIPTION"
    static let ITEM_TYPE_BATCH_MEMBERSHIP = "BATCHMEMBERSHIP"
    static let ITEM_TYPE_WELLNESS_SUBSCRIPTION = "WELLNESS_SUBSCRIPTION"

    static let VIEW_TO_SHOW_MY_CIRCLE = "CIRCLE"
    static let VIEW_TO_SHOW_SUBSCRIPTION = "SUBSCRIPTION"
    static let VIEW_TO_SHOW_WELLNESS_SUBSCRIPTION = "SUBSCRIPTION"
    static let VIEW_TO_SHOW_CATEGORY = "CATEGORY"
    static let VIEW_TO_SHOW_SHOP = "SHOP"
    static let VIEW_TO_SHOW_BATCHES = "BATCHES"

    static let SLIDESHOW_TIME_PRODUCT_IMAGES_SECONDS = 4
    static let SLIDESHOW_TIME_BANNERS_SECONDS = 4

    enum Device {
        static let OS = "iOS" 
    }

    enum Size {
        static let DEFAULT_CORNER_RADIUS = 6.0
    }

    enum DateFormats {
        static let STANDARD_DATE_FORMAT = "dd MMM, yyyy"
        static let STANDARD_DATE_TIME_FORMAT = "dd MMM, yyyy HH:mm"
        static let DOB_DATE_FORMAT = "dd MMMM, yyyy"
        static let DOB_DATE_FORMAT_FOR_SERVER = "dd-MM-yyyy"
    }

    enum Predicate {
        static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")

        static let mobilePredicate = NSPredicate(format: "SELF MATCHES %@", "^[6-9]\\d{9}$")
    }

    enum DocumentStatus {
        static let STATUS_ADDED = "ADDED"
        static let STATUS_VALID = "VALIDATED"
        static let STATUS_PENDING = "PENDING"
        static let STATUS_REJECTED = "REJECTED"
        static let STATUS_UNNEEDED = "UNNEEDED"
    }

    enum TournamentStatus {
        static let TOURNAMENT_STATUS_OPEN = "OPEN"
        static let TOURNAMENT_STATUS_NEW = "NEW"
    }

    enum Tournament {
        static let CATEGORY_STATUS_OPEN = "OPEN"
        static let CATEGORY_STATUS_IN_PLAY = "IN-PLAY"
        static let CATEGORY_STATUS_COMPLETED = "COMPLETED"
        static let CATEGORY_STATUS_CLOSED = "CLOSED"
        static let MATCH_FORMAT_DOUBLE = "Double"
        static let SEAT_TYPE_DOUBLE = "Double"
        static let SEAT_TYPE_TEAM = "TEAM"
        static let SEAT_TYPE_SINGLE = "Single"
        static let SEAT_TYPE_MIXED = "Mixed"
        static let MATCH_FORMAT_SINGLE_ELIMINATION = "SINGLE ELIMINATION"
        static let SPORT_TYPE_SINGLE_ELIMINATION = "SINGLE ELIMINATION"
    }

    enum Circle {
        static let STATUS_ACTIVE = "Active"
    }

    enum Matches {
        static let MATCH_STATUS_OPEN = "OPEN"
        static let MATCH_STATUS_IN_PLAY = "IN-PLAY"
        static let MATCH_STATUS_COMPLETED = "COMPLETED"
    }
}
