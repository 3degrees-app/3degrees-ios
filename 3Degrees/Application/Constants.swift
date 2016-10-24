//
//  Constants.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/27/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit

struct Constants {
    struct Api {
        static let SessionKeyHeader = "session-key"
    }

    struct Birthday {
        static let dateFormat = "MM/dd/yyyy"
    }

    struct ProgressView {
        static let BackColor = UIColor(r: 0, g: 0, b: 0, a: 0.3)
    }

    struct NavBar {
        static let BarTintColor = UIColor.whiteColor()
        static let ShadowImage = UIImage()
        static let TintColor = UIColor(r: 177, g: 185, b: 173)
        static let Translucent = true
    }

    struct TabBar {
        static let BackgroundImage = "tabBarBack"

        static let AccountButtonImage = "accountButton"

        static let ImageInset = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)

        static let ImageTintColor = UIColor(r: 179, g: 172, b: 160)
    }

    struct ViewOnBackground {
        static let Color = UIColor(r: 238, g: 238, b: 233)
    }

    struct Avatar {
        static let BackgroundColor = UIColor(r: 245, g: 238, b: 229)
        static let FontName = "HelveticaNeue-Thin"
    }

    struct Mode {
        static let BackgroundImageName = "modeScreenBackground"

        static let ButtonBackColor = UIColor.clearColor()
        static let ButtonTextColor = UIColor.whiteColor()

        static let ButtonSelectedBackColor = UIColor(white: 1, alpha: 0.85)
        static let ButtonSelectedTextColor = UIColor.blackColor()

        static let ButtonBorderWidth: CGFloat = 1

        static let ButtonBorderColor = UIColor.whiteColor()

        static let LabelInfoColor = UIColor.whiteColor()
        static let LabelLogoColor = UIColor.blackColor()
    }

    struct Auth {
        static let BackgroundImageName = "authBack"
        static let BackgroundOverlayColor = UIColor(r: 0, g: 0, b: 0, a: 0.5)

        static let LabelColor = UIColor.whiteColor()

        static let FacebookButtonBackgroundColor = UIColor(r: 59, g: 89, b: 152, a: 0.35)
        static let FacebookButtonBorderColor = UIColor.clearColor()
        static let FacebookButtonBorderWidth: CGFloat = 0
        static let ButtonBorderColor = UIColor(white: 1, alpha: 0.6)
        static let ButtonBorderWidth: CGFloat = 1
        static let ButtonBackgroundColor = UIColor.clearColor()
        static let ButtonTitleColor = UIColor.whiteColor()

        static let TextFieldBackground = UIColor(white: 1, alpha: 0.2)
        static let TextFieldPlaceholderColor = UIColor(white: 1, alpha: 0.5)
        static let TextFieldTextColor = UIColor.whiteColor()
    }

    struct Account {
        static let ActionLabelColor = UIColor(r: 35, g: 31, b: 32)
        static let ToggleBackgroundColor = UIColor(r: 150, g: 200, b: 120, a: 0.75)
        static let InfoLabelColor = UIColor.whiteColor()
        static let ActionTableSeparatorColor = UIColor(white: 0.3, alpha: 0.1)
        static let ReturnButtonImageName = "returnButton"
        static let AvatarBorderColor = UIColor(r: 188, g: 153, b: 150, a: 0.5)
    }

    struct Profile {
        static let NameLabelColor = UIColor.whiteColor()
        static let TextShadowColor = UIColor(r: 32, g: 32, b: 32)
        static let InfoLabelColor = UIColor(white: 1, alpha: 1)
        static let BioIconName = "bioIcon"
        static let EducationIconName = "educationIcon"
        static let OccupationIconName = "occupationIcon"
        static let TableBordersColor = UIColor(r: 179, g: 172, b: 160, a: 0.5)
        static let TextPlaceholderColor = UIColor(r: 179, g: 172, b: 160, a: 0.5)

        static let EditTitleColor = UIColor.blackColor()
        static let EditSubtitleColor = UIColor(r: 179, g: 172, b: 160)

        static let TextShadowRadius: CGFloat = 2
    }

    struct SelectValue {
        static let SeparatorColor = UIColor(white: 0.3, alpha: 0.1)
        static let ValueColor = UIColor(r: 35, g: 31, b: 32)
    }

    struct DateProposal {
        static let SubtitleColor = UIColor(r: 179, g: 172, b: 160)
        static let DetailItemBorderColor = UIColor(r: 179, g: 172, b: 160)
        static let DetailItemSelecteBorderColor = UIColor.clearColor()
        static let DetailItemSelectedColor = UIColor(r: 160, g: 109, b: 122)
        static let DetailItemSelectedTextColor = UIColor.whiteColor()
        static let DetailItemColor = UIColor.clearColor()
        static let DetailItemTextColor = UIColor.blackColor()
        static let DetailItemFixedColor = UIColor.whiteColor()
        static let ProceedButtonColor = UIColor(r: 160, g: 109, b: 122)
        static let ProceedButtonTextColor = UIColor.whiteColor()

        static let TimeFormat = "h mm a"
        static let DateFormat = "MMM d"
        static let DayFormat = "d"
    }

    struct ActivityAndHistory {
        static let NameAndBodyLabelColor = UIColor.blackColor()
        static let InfoLabel = UIColor(r: 179, g: 172, b: 160)
        static let MMLabelColor = UIColor(r: 179, g: 172, b: 160)
        static let CellItemBackground = UIColor(white: 1, alpha: 0.2)
        static let BackgroundBorderColor = UIColor(white: 0.5, alpha: 0.3)

        static let AcceptButtonColor = UIColor(r: 160, g: 109, b: 122)
        static let AcceptButtonTextColor = UIColor.whiteColor()

        static let DeclineButtonColor = UIColor.whiteColor()
        static let DeclineButtonTextColor = UIColor.blackColor()
    }


    struct MyNetwork {
        static let CellOverlayBackground = UIColor(r: 233, g: 233, b: 229)
        static let NameLabelColor = UIColor.blackColor()
        static let SeparatorColor = UIColor(r: 226, g: 226, b: 221)
        static let InfoLabelColor = UIColor(r: 179, g: 172, b: 160)

        static let ChatActionButtonColor = UIColor(r: 128, g: 240, b: 184)
        static let MatchActionButtonColor = UIColor(r:240, g: 184, b: 128)
        static let RemoveActionButtonColor = UIColor(r: 240, g: 128, b: 128)
    }

    struct Chat {
        static let MessageBodyColor = UIColor(r: 35, g: 31, b: 32)
        static let MyMessageDateTimeColor = UIColor(r: 174, g: 171, b: 164)
        static let NotMyMessageDateTimeColor = UIColor(r: 203, g: 203, b: 202)
        static let ImageDateTimeColor = UIColor.whiteColor()

        static let MyMessageBackground = UIColor(r: 208, g: 205, b: 196)
        static let NotMyMessageBackground = UIColor.whiteColor()

        static let MessageDateTimeFormat = "h:mm a – MMMM d, YYYY"
    }

    struct PairUp {
        static let NameColor = UIColor.whiteColor()
        static let InfoColor = UIColor(white: 1, alpha: 0.5)

        static let PairUpTextColor = UIColor.whiteColor()
    }

    struct Filter {
        static let ValueColor = UIColor(r: 174, g: 171, b: 164)
        static let CategoryColor = UIColor.blackColor()
        static let BorderColor = UIColor(r: 174, g: 171, b: 164)
    }
}
