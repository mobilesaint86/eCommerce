//
//  FMAData.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/15/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

// --------------------------------------------------------------------------------------
// Debug constants to turn on debug console messages
// --------------------------------------------------------------------------------------
static const int debugFMAUtil                       = 1;
static const int debugFMAUserUtil                   = 1;
static const int debugFMAProductUtil                = 1;
static const int debugFMAScanUtil                   = 1;
static const int debugFMAUserSetting                = 1;
static const int debugFMACoreLocationController     = 1;
static const int debugFMAThemeManager               = 1;
static const int debugAppDelegate                   = 1;
static const int debugFMALoginVC                    = 1;
static const int debugFMABrowseVC                   = 1;
static const int debugFMASideMenuVC                 = 1;
static const int debugFMASocialShareVC              = 1;
static const int debugFMAImageCaptionCVCell         = 1;
static const int debugFMABrowseCVCell               = 1;
static const int debugFMAPriceRangeVC               = 1;
static const int debugFMAFilterCategoryVC           = 1;
static const int debugFMAFilterCategoryCVCell       = 1;
static const int debugFMASignupVC                   = 1;
static const int debugFMAResetPasswordVC            = 1;
static const int debugFMADashboardVC                = 1;
static const int debugFMARevenueVC                  = 1;
static const int debugFMATabView                    = 1;
static const int debugFMATotalOrdersVC              = 1;
static const int debugFMAPendingOrdersVC            = 1;
static const int debugFMACustomerReviewsVC          = 1;
static const int debugFMACustomerReviewsCell        = 1;
static const int debugFMASecurityCamerasVC          = 1;
static const int debugFMASecurityCamerasCVCell      = 1;
static const int debugFMAEmployeesVC                = 1;
static const int debugFMAEmployeesCVCell            = 1;
static const int debugFMAPayrollVC                  = 1;
static const int debugFMAWorkScheduleVC             = 1;
static const int debugFMAMessagesVC                 = 1;
static const int debugFMAMessageCustomersVC         = 1;
static const int debugFMAMessageCustomersCell       = 1;
static const int debugFMAMessageEmployeesVC         = 1;
static const int debugFMAMessageEmployeesCell       = 1;
static const int debugFMACustomerMessageVC          = 1;
static const int debugFMAEmployeeMessageVC          = 1;
static const int debugFMAMessageBoardVC             = 1;
static const int debugFMAReceiptVC                  = 1;
static const int debugFMAERegisterVC                = 1;
static const int debugFMABankListView               = 1;
static const int debugFMACardListView               = 1;
static const int debugFMABankListCVCell             = 1;
static const int debugFMACardListCVCell             = 1;
static const int debugFMAAddBankVC                  = 1;
static const int debugFMAERegisterUtil              = 1;
static const int debugFMAAddCardVC                  = 1;
static const int debugFMAWithdrawVC                 = 1;
static const int debugFMAChooseBankVC               = 1;
static const int debugFMACompanyProfileVC           = 1;
static const int debugFMAEditProfileVC              = 1;
static const int debugFMAWeekdayPickerView          = 1;
static const int debugFMAImagePickerAM              = 1;
static const int debugFMAEditBackgroundsVC          = 1;
static const int debugFMAEditBackgroundsCVCell      = 1;
static const int debugFMAAddItemVC                  = 1;
static const int debugFMACameraVC                   = 1;
static const int debugFMACreateItemVC               = 1;
static const int debugFMACreateItemImageListView    = 1;
static const int debugFMAChooseCategoryVC           = 1;
static const int debugFMAChooseCategoryCVCell       = 1;
static const int debugFMAChooseColorVC              = 1;
static const int debugFMAChooseColorCVCell          = 1;
static const int debugFMAEditPackageDimensionsVC    = 1;
static const int debugFMAScanVC                     = 1;
static const int debugFMACheckoutVC                 = 1;
static const int debugFMAItemBarcodeScanVC          = 1;
static const int debugFMABrowseUtil                 = 1;
static const int debugFMACheckoutProductCell        = 1;
static const int debugFMACheckoutUtil               = 1;
static const int debugFMAMessageEmployeesUtil       = 1;
static const int debugFMAEmployeeMessageUtil        = 1;
static const int debugFMAMessageBoardUtil           = 1;
static const int debugFMADashboardUtil              = 1;
static const int debugFMAEmployeesUtil              = 1;
static const int debugFMATotalOrdersUtil            = 1;
static const int debugFMATotalOrdersCVCell          = 1;
static const int debugFMAPendingOrdersUtil          = 1;
static const int debugFMAPendingOrdersCVCell        = 1;
static const int debugFMADeliveryMethodsView        = 1;
static const int debugFMADeliveryMethodsCVCell      = 1;
static const int debugFMAMessageCustomersUtil       = 1;
static const int debugFMACustomerMessageUtil        = 1;
static const int debugFMACustomerReviewsUtil        = 1;
static const int debugFMARevenueUtil                = 1;
static const int debugFMAShareUtil                  = 1;
static const int debugFMABackgroundSetting          = 1;
static const int debugFMABackgroundUtil             = 1;
static const int debugFMAAboutVC                    = 1;
static const int debugFMATotalOrders2VC             = 1;
static const int debugFMATotalOrders2Cell           = 1;
static const int debugFMAPendingOrders2VC           = 1;
static const int debugFMAPendingOrders2Cell         = 1;
static const int debug = 1;

// --------------------------------------------------------------------------------------
// Storyboard IDs
// --------------------------------------------------------------------------------------
#pragma mark - Storyboard IDs

#define SBID_FMALOGIN_VC                    @"SBID_FMALoginVC"
#define SBID_FMABROWSE_NC                   @"SBID_FMABrowseNC"
#define SBID_FMABROWSE_VC                   @"SBID_FMABrowseVC"
#define SBID_FMASIDEMENU_VC                 @"SBID_FMASideMenuVC"
#define SBID_FMASOCIALSHARE_VC              @"SBID_FMASocialShareVC"
#define SBID_FMAPRICERANGE_VC               @"SBID_FMAPriceRangeVC"
#define SBID_FMAFILTERCATEGORY_VC           @"SBID_FMAFilterCategoryVC"
#define SBID_FMASIGNUP_NC                   @"SBID_FMASignupNC"
#define SBID_FMASIGNUP_VC                   @"SBID_FMASignupVC"
#define SBID_FMARESETPASSWORD_NC            @"SBID_FMAResetPasswordNC"
#define SBID_FMARESETPASSWORD_VC            @"SBID_FMAResetPasswordVC"
#define SBID_FMADASHBOARD_NC                @"SBID_FMADashboardNC"
#define SBID_FMADASHBOARD_VC                @"SBID_FMADashboardVC"
#define SBID_FMAREVENUE_NC                  @"SBID_FMARevenueNC"
#define SBID_FMAREVENUE_VC                  @"SBID_FMARevenueVC"
#define SBID_FMATOTALORDERS_NC              @"SBID_FMATotalOrdersNC"
#define SBID_FMATOTALORDERS_VC              @"SBID_FMATotalOrdersVC"
#define SBID_FMAPENDINGORDERS_NC            @"SBID_FMAPendingOrdersNC"
#define SBID_FMAPENDINGORDERS_VC            @"SBID_FMAPendingOrdersVC"
#define SBID_FMACUSTOMERREVIEWS_NC          @"SBID_FMACustomerReviewsNC"
#define SBID_FMACUSTOMERREVIEWS_VC          @"SBID_FMACustomerReviewsVC"
#define SBID_FMASECURITYCAMERAS_NC          @"SBID_FMASecurityCamerasNC"
#define SBID_FMASECURITYCAMERAS_VC          @"SBID_FMASecurityCamerasVC"
#define SBID_FMAEMPLOYEES_NC                @"SBID_FMAEmployeesNC"
#define SBID_FMAEMPLOYEES_VC                @"SBID_FMAEmployeesVC"
#define SBID_FMAPAYROLL_NC                  @"SBID_FMAPayrollNC"
#define SBID_FMAPAYROLL_VC                  @"SBID_FMAPayrollVC"
#define SBID_FMAWORKSCHEDULE_NC             @"SBID_FMAWorkScheduleNC"
#define SBID_FMAWORKSCHEDULE_VC             @"SBID_FMAWorkScheduleVC"
#define SBID_FMAMESSAGES_NC                 @"SBID_FMAMessagesNC"
#define SBID_FMAMESSAGES_VC                 @"SBID_FMAMessagesVC"
#define SBID_FMAMESSAGECUSTOMERS_NC         @"SBID_FMAMessageCustomersNC"
#define SBID_FMAMESSAGECUSTOMERS_VC         @"SBID_FMAMessageCustomersVC"
#define SBID_FMAMESSAGEEMPLOYEES_NC         @"SBID_FMAMessageEmployeesNC"
#define SBID_FMAMESSAGEEMPLOYEES_VC         @"SBID_FMAMessageEmployeesVC"
#define SBID_FMACUSTOMERMESSAGE_NC          @"SBID_FMACustomerMessageNC"
#define SBID_FMACUSTOMERMESSAGE_VC          @"SBID_FMACustomerMessageVC"
#define SBID_FMAEMPLOYEEMESSAGE_NC          @"SBID_FMAEmployeeMessageNC"
#define SBID_FMAEMPLOYEEMESSAGE_VC          @"SBID_FMAEmployeeMessageVC"
#define SBID_FMAMESSAGEBOARD_NC             @"SBID_FMAMessageBoardNC"
#define SBID_FMAMESSAGEBOARD_VC             @"SBID_FMAMessageBoardVC"
#define SBID_FMARECEIPT_NC                  @"SBID_FMAReceiptNC"
#define SBID_FMARECEIPT_VC                  @"SBID_FMAReceiptVC"
#define SBID_FMAEREGISTER_NC                @"SBID_FMAERegisterNC"
#define SBID_FMAEREGISTER_VC                @"SBID_FMAERegisterVC"
#define SBID_FMAADDBANK_NC                  @"SBID_FMAAddBankNC"
#define SBID_FMAADDBANK_VC                  @"SBID_FMAAddBankVC"
#define SBID_FMAADDCARD_NC                  @"SBID_FMAAddCardNC"
#define SBID_FMAADDCARD_VC                  @"SBID_FMAAddCardVC"
#define SBID_FMAWITHDRAW_NC                 @"SBID_FMAWithdrawNC"
#define SBID_FMAWITHDRAW_VC                 @"SBID_FMAWithdrawVC"
#define SBID_FMACHOOSEBANK_NC               @"SBID_FMAChooseBankNC"
#define SBID_FMACHOOSEBANK_VC               @"SBID_FMAChooseBankVC"
#define SBID_FMACOMPANYPROFILE_NC           @"SBID_FMACompanyProfileNC"
#define SBID_FMACOMPANYPROFILE_VC           @"SBID_FMACompanyProfileVC"
#define SBID_FMAEDITPROFILE_NC              @"SBID_FMAEditProfileNC"
#define SBID_FMAEDITPROFILE_VC              @"SBID_FMAEditProfileVC"
#define SBID_FMAEDITBACKGROUNDS_NC          @"SBID_FMAEditBackgroundsNC"
#define SBID_FMAEDITBACKGROUNDS_VC          @"SBID_FMAEditBackgroundsVC"
#define SBID_FMAADDITEM_NC                  @"SBID_FMAAddItemNC"
#define SBID_FMAADDITEM_VC                  @"SBID_FMAAddItemVC"
#define SBID_FMACREATEITEM_NC               @"SBID_FMACreateItemNC"
#define SBID_FMACREATEITEM_VC               @"SBID_FMACreateItemVC"
#define SBID_FMACHOOSECATEGORY_VC           @"SBID_FMAChooseCategoryVC"
#define SBID_FMACHOOSECOLOR_VC              @"SBID_FMAChooseColorVC"
#define SBID_FMAEDITPACKAGEDIMENSIONS_VC    @"SBID_FMAEditPackageDimensionsVC"
#define SBID_FMASCAN_NC                     @"SBID_FMAScanNC"
#define SBID_FMASCAN_VC                     @"SBID_FMAScanVC"
#define SBID_FMACHECKOUT_NC                 @"SBID_FMACheckoutNC"
#define SBID_FMACHECKOUT_VC                 @"SBID_FMACheckoutVC"
#define SBID_FMAITEMBARCODESCAN_NC          @"SBID_FMAItemBarcodeScanNC"
#define SBID_FMAITEMBARCODESCAN_VC          @"SBID_FMAItemBarcodeScanVC"
#define SBID_FMAABOUT_NC                    @"SBID_FMAAboutNC"
#define SBID_FMAABOUT_VC                    @"SBID_FMAAboutVC"
#define SBID_FMATOTALORDERS2_NC             @"SBID_FMATotalOrders2NC"
#define SBID_FMATOTALORDERS2_VC             @"SBID_FMATotalOrders2VC"
#define SBID_FMAPENDINGORDERS2_NC           @"SBID_FMAPendingOrders2NC"
#define SBID_FMAPENDINGORDERS2_VC           @"SBID_FMAPendingOrders2VC"

// --------------------------------------------------------------------------------------
// Macros
// --------------------------------------------------------------------------------------
#pragma mark - Macros

#define RGB(r,g,b,a)                [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]
#define RGBHEX(rgbValue,a)          [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

// System Version Macros
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// --------------------------------------------------------------------------------------
// Common Values
// --------------------------------------------------------------------------------------

// Common Theme Values
#pragma mark -

#define COMMON_COLOR_FOR_BORDER                 RGBHEX(0xDADADA, 1.f)
#define COMMON_COLOR_FOR_BUTTON_TITLE           RGBHEX(0x1FB0FF, 1.f)
#define COMMON_COLOR_FOR_TEXTFIELD              RGBHEX(0x7E8B8D, 1.f)
#define COMMON_COLOR_FOR_ERROR_TITLE            RGBHEX(0xff0000, 1.f)
#define COMMON_COLOR_FOR_CIRCLE_BORDER          RGBHEX(0x5178b4, 1.f)
#define COMMON_COLOR_FOR_EMPTY_LISTVIEW_LABEL   RGBHEX(0xcccccc, 1.f)

#define COMMON_WIDTH_FOR_BORDER                 1.f
#define COMMON_RADIUS                           5.f
#define COMMON_WIDTH_FOR_CIRCLE_BORDER          2.f

#define COMMON_FONT_FOR_PAGE_TITLE              [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]
#define COMMON_FONT_FOR_EMPTY_LISTVIEW_LABEL    [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]

// Common Values For Alert View
#pragma mark -

#define ALERT_TITLE_WARNING                 @"Warning"
#define ALERT_TITLE_ERROR                   @"Error"
#define ALERT_MSG_FIELDS_EMPTY              @"All fields must be filled!"
#define ALERT_MSG_INVALID_EMAIL             @"Please enter an email of correct format."
#define ALERT_MSG_INVALID_USERNAME_CONTENT  @"The user name field cannot contain whitespace or @ characters."
#define ALERT_MSG_NO_AVAILABLE_PHONE_CALL   @"This function is only available on the iPhone."

// Common Values used for validation process
#pragma mark -

#define SIGNUP_VALID_PASSWORD_MINIMUM_LENGTH    8
#define SIGNUP_VALID_PASSWORD_OK                0
#define SIGNUP_NOVALID_PASSWORD_LENGTH          1

#define SIGNUP_VALID_USERNAME_MINIMUM_LENGTH    6
#define SIGNUP_VALID_USERNAME_OK                0
#define SIGNUP_INVALID_USERNAME_LENGTH          1
#define SIGNUP_INVALID_USERNAME_CONTENT         2

#define VALID_PHONE_NUMBER_LENGTH               10

// Common Image Resource Names
#pragma mark -

#define COMMON_IMAGE_HUD_CHECKMARK          @"00_hud_checkmark"
#define COMMON_IMAGE_BACKGROUND             @"00_background"

// Common Maximum and Minimum Values For Filter Settings
#pragma mark -

#define MIN_PRICE    0
#define MAX_PRICE    2000

#define MAX_COUNT_ITEM_IMAGES       5

// ----------------------------------------------------------------
// App StandardUserDefaults Keys
// ----------------------------------------------------------------
#pragma mark - App StandardUserDefaults Keys

#define APP_SETTING_KEY_CREDIT_CARDS        @"creditcards"
#define APP_SETTING_KEY_BANKS               @"banks"
#define APP_SETTING_KEY_USER_SETTING        @"usersetting"
#define APP_SETTING_KEY_BACKGROUND_SETTING  @"backgroundsetting"

// ----------------------------------------------------------------
// Enumerations
// ----------------------------------------------------------------
typedef enum
{
    FMA_REVENUE_DATASOURCE_TYPE_YEAR    = 2,
    FMA_REVENUE_DATASOURCE_TYPE_MONTH   = 1,
    FMA_REVENUE_DATASOURCE_TYPE_DAY     = 0,
} FMARevenueDataSourceType;

typedef enum
{
    FMA_SHARE_TYPE_FACEBOOK = 0,
    FMA_SHARE_TYPE_TWITTER  = 1,
    FMA_SHARE_TYPE_EMAIL    = 2,
    FMA_SHARE_TYPE_CONTACTS = 3,
    FMA_SHARE_TYPE_APP      = 4,
} FMAShareType;

typedef enum
{
    FMA_BROWSE_MODE_SINGLE = 0,
    FMA_BROWSE_MODE_GRID   = 1,
    FMA_BROWSE_MODE_LINE   = 2,
} FMABrowseMode;