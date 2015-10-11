//
//  FMAEditProfileVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/31/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAEditProfileVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABackgroundSetting.h"

#define PLACEHOLDER_ENTER_COMPANY_NAME      @"Enter Company Name"
#define PLACEHOLDER_ENTER_STREE_ADDRESS     @"Enter Street Address"
#define PLACEHOLDER_ENTER_PHONE_NUMBER      @"Enter Phone Number"
#define PLACEHOLDER_HOUR1                   @"Open Hour"
#define PLACEHOLDER_HOUR2                   @"Close Hour"
#define PLACEHOLDER_DAY1                    @"Weekday"
#define PLACEHOLDER_DAY2                    @"Weekday"

#define COMMON_DATE_FORMAT_HOUR             @"hh:mm a"

#define SEGID_EDITBACKGROUNDS               @"SEGID_EditBackgrounds"

@interface FMAEditProfileVC ()

@end

@implementation FMAEditProfileVC
{
    PFObject *companyProfile;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAEditProfileVC) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
    
    [self unregisterNotifications];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
    [self initCompanyProfile];
    [self registerNotifications];
}

- (void)viewDidLayoutSubviews
{
    [self printLogWith:@"viewDidLayoutSubviews"];
    [super viewDidLayoutSubviews];
    
    [FMAThemeManager relayoutTableviewForApp:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Init Company Profile
- (void)initCompanyProfile
{
    [self printLogWith:@"initCompanyProfile"];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMCompanyClassKey];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             companyProfile = objects[0];
             [self setCompanyProfileWithObject:objects[0]];
         }
     }];
}

- (void)setCompanyProfileWithObject:(PFObject *)profile
{
    [self printLogWith:@"setCompanyProfileWithObject"];
    
    _imageviewCompanyLogo.image = nil;
    _imageviewCompanyLogo.file  = profile[kFMCompanyLogoKey];
    [_imageviewCompanyLogo loadInBackground:^(UIImage *image, NSError *error)
     {
         imageCompanyLogo = image;
     }];
    
    _txtCompanyName.text    = profile[kFMCompanyNameKey];
    _txtStreetAddress.text  = profile[kFMCompanyStreetAddressKey];
    _txtPhoneNumber.text    = profile[kFMCompanyPhoneNumberKey];
    _txtStartDay.text       = profile[kFMCompanyStartWeekdayKey];
    _txtEndDay.text         = profile[kFMCompanyEndWeekdayKey];
    _txtStartHour.text      = profile[kFMCompanyOpenHourKey];
    _txtEndHour.text        = profile[kFMCompanyCloseHourKey];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initViewBackground];
    
    [self initTextFieldsPlaceholder];
    
    [self initDatePickers];
    [self setupInputAccessoryViews];
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameSettings delegate:self];
    
    [FMAThemeManager setBorderToView:_imageviewCompanyLogo width:1.f Color:[UIColor lightGrayColor]];
    
    for (UILabel *label in self.labelContainers)
    {
        label.backgroundColor = [UIColor clearColor];
        [FMAThemeManager setBorderToView:label width:1.f Color:RGBHEX(0x747376, 1.f)];
    }
}

- (void)initTextFieldsPlaceholder
{
    [self printLogWith:@"initTextFieldsPlaceholder"];
    
    [FMAThemeManager setPlaceholder:PLACEHOLDER_ENTER_COMPANY_NAME      toTextField:_txtCompanyName     color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:PLACEHOLDER_ENTER_STREE_ADDRESS     toTextField:_txtStreetAddress   color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:PLACEHOLDER_ENTER_PHONE_NUMBER      toTextField:_txtPhoneNumber     color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:PLACEHOLDER_HOUR1                   toTextField:_txtStartHour       color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:PLACEHOLDER_HOUR2                   toTextField:_txtEndHour         color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:PLACEHOLDER_DAY1                    toTextField:_txtStartDay        color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:PLACEHOLDER_DAY2                    toTextField:_txtEndDay          color:[UIColor whiteColor]];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[_txtCompanyName, _txtStreetAddress, _txtPhoneNumber, _txtStartHour, _txtEndHour, _txtStartDay, _txtEndDay];
}

- (void)setupInputAccessoryViews
{
    [self printLogWith:@"setupInputAccessoryViews"];
    
    [FMAUtil setupInputAccessoryViewWithPrevNextHideButtonsForTextControls:[self textControlsForInputAccessoryView]
                                                                    target:self
                                                 selectorForPreviousButton:@selector(onBtnPrevInInputAccessoryView:)
                                                     selectorForNextButton:@selector(onBtnNextInInputAccessoryView:)
                                                     selectorForDoneButton:nil];
}

- (void)initDatePickers
{
    [self printLogWith:@"initDatePickers"];
    
    _datePickerStartHour = [FMAUtil setupDatePickerInputViewByDatePickerMode:UIDatePickerModeTime
                                                                     textControl:_txtStartHour
                                                                      withTarget:self
                                                    selectorForDatePickerChanged:@selector(onDatePickerChanged:)
                                                               selectorForCancel:nil
                                                                 selectorForDone:nil];
    
    [_datePickerStartHour setMinuteInterval:30];
    
    _datePickerEndHour = [FMAUtil setupDatePickerInputViewByDatePickerMode:UIDatePickerModeTime
                                                                     textControl:_txtEndHour
                                                                      withTarget:self
                                                    selectorForDatePickerChanged:@selector(onDatePickerChanged:)
                                                               selectorForCancel:nil
                                                                 selectorForDone:nil];
    
    [_datePickerEndHour setMinuteInterval:30];
    
    _weekdayPickerStartDay = [FMAUtil setupWeekdayPickerInputViewForTextControl:_txtStartDay
                                                                     withTarget:self
                                                              selectorForCancel:nil
                                                                selectorForDone:nil
                                                      weekdayPickerViewDelegate:self];
    
    _weekdayPickerEndDay = [FMAUtil setupWeekdayPickerInputViewForTextControl:_txtEndDay
                                                                     withTarget:self
                                                              selectorForCancel:nil
                                                                selectorForDone:nil
                                                      weekdayPickerViewDelegate:self];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Notification Functions
- (void)registerNotifications
{
    [self printLogWith:@"registerNotifications"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundImageChanged:)
                                                 name:FMABackgroundSettingDidUpdateNotification object:nil];
}

- (void)unregisterNotifications
{
    [self printLogWith:@"unregisterNotifications"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FMABackgroundSettingDidUpdateNotification object:nil];
}

- (void)backgroundImageChanged:(NSNotification *)note
{
    [self printLogWith:@"backgroundImageChanged"];
    
    if ([note.object[kFMBackgroundNameKey] isEqualToString:kFMBackgroundNameSettings])
    {
        if ([note.object objectForKey:kFMBackgroundImageKey])
        {
            [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
        }
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnSave:(id)sender
{
    [self printLogWith:@"onBtnSave"];
    
    if ([self doValidationProcess])
    {
        [self doSave];
    }
}

- (IBAction)onTapCompanyLog:(id)sender
{
    [self printLogWith:@"onTapCompanyLog"];
    
    FMAImagePickerAM *actionMenu = [[FMAImagePickerAM alloc] initActionMenu];
    actionMenu.amdelegate        = self;
    
    [actionMenu showActionMenu];
}

- (void)onDatePickerChanged:(UIDatePicker *)datePicker
{
    [self printLogWith:@"onDatePickerChanged"];
    
    if ([datePicker isEqual:_datePickerStartHour])
    {
        _txtStartHour.text = [FMAUtil stringFromDate:_datePickerStartHour.date WithFormat:COMMON_DATE_FORMAT_HOUR];
    }
    
    if ([datePicker isEqual:_datePickerEndHour])
    {
        _txtEndHour.text = [FMAUtil stringFromDate:_datePickerEndHour.date WithFormat:COMMON_DATE_FORMAT_HOUR];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAWeekdayPickerViewDelegate
- (void)weekdaysPickerView:(FMAWeekdayPickerView *)pickerView didSelectWeekday:(NSString *)weekday
{
    [self printLogWith:@"weekdaysPickerView: didSelectWeekday"];
    
    if ([pickerView isEqual:_weekdayPickerStartDay])
    {
        _txtStartDay.text = weekday;
    }
    else
    {
        _txtEndDay.text = weekday;
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAImagePickerAMDelegate
- (void)imagePickerAMClickedMenuItemTitle:(NSString *)menuItemTitle
{
    [self printLogWith:@"imagePickerAMClickedMenuItemTitle"];
    
    if ([menuItemTitle isEqualToString:IMAGEPICKER_MENU_ITEM_TAKE_PHOTO])
    {
        [self shouldStartCameraController];
    }
    if ([menuItemTitle isEqualToString:IMAGEPICKER_MENU_ITEM_FROM_CAMERAROLL])
    {
        [self shouldStartPhotoLibraryPickerController];
    }
}

- (BOOL)shouldStartCameraController
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerController
{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self printLogWith:@"imagePickerControllerDidCancel"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self printLogWith:@"imagePickerController: didFinishPickingMediaWithInfo"];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImage *image              = [info objectForKey:UIImagePickerControllerEditedImage];
    imageCompanyLogo            = [FMAUtil resizeImage:image bySize:kCompanyLogoSize];
    _imageviewCompanyLogo.image = imageCompanyLogo;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TextFields Functions
- (void)onBtnPrevInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnPrevInInputAccessoryView"];
    
    [FMAUtil onBtnPrevInInputAccessoryViewForTextControls:[self textControlsForInputAccessoryView] activeField:activeField];
}
- (void)onBtnNextInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnNextInInputAccessoryView"];
    
    [FMAUtil onBtnNextInInputAccessoryViewForTextControls:[self textControlsForInputAccessoryView] activeField:activeField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    activeField = textField;
    
    if (textField == _txtStartHour && [FMAUtil isStringNotEmpty:textField.text])
    {
        _datePickerStartHour.date = [FMAUtil dateFromString:textField.text WithFormat:COMMON_DATE_FORMAT_HOUR];
    }
    if (textField == _txtEndHour && [FMAUtil isStringNotEmpty:textField.text])
    {
        _datePickerEndHour.date = [FMAUtil dateFromString:textField.text WithFormat:COMMON_DATE_FORMAT_HOUR];
    }
    if (textField == _txtStartDay && [FMAUtil isStringNotEmpty:textField.text])
    {
        NSInteger row = [_weekdayPickerStartDay indexOfWeekday:textField.text];
        [_weekdayPickerStartDay selectRow:row inComponent:0 animated:NO];
    }
    if (textField == _txtEndDay && [FMAUtil isStringNotEmpty:textField.text])
    {
        NSInteger row = [_weekdayPickerEndDay indexOfWeekday:textField.text];
        [_weekdayPickerEndDay selectRow:row inComponent:0 animated:NO];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [self onBtnSave:nil];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.txtPhoneNumber])
    {
        if (![FMAUtil checkAndFormatPhoneNumberField:textField
                       shouldChangeCharactersInRange:range
                                   replacementString:string])
        {
            return NO;
        }
    }
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Save Functions
- (void)doSave
{
    [self printLogWith:@"doSave"];
    
    [FMAUtil showHUD:self.hud withText:@""];
    
    companyProfile[kFMCompanyNameKey]           = _txtCompanyName.text;
    companyProfile[kFMCompanyStreetAddressKey]  = _txtStreetAddress.text;
    companyProfile[kFMCompanyPhoneNumberKey]    = _txtPhoneNumber.text;
    companyProfile[kFMCompanyStartWeekdayKey]   = _txtStartDay.text;
    companyProfile[kFMCompanyEndWeekdayKey]     = _txtEndDay.text;
    companyProfile[kFMCompanyOpenHourKey]       = _txtStartHour.text;
    companyProfile[kFMCompanyCloseHourKey]      = _txtEndHour.text;
    
    PFFile *file = [PFFile fileWithName:@"company_log.png" data:[FMAUtil dataFromImage:imageCompanyLogo]];
    companyProfile[kFMCompanyLogoKey]           = file;
    
    [companyProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        [FMAUtil hideHUD:_hud withText:@""];
        
        if (!error)
        {
            [_delegate editProfileVC:self didSaveProfile:companyProfile];
        }
    }];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_EDITBACKGROUNDS])
    {
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields =
    @[@{kFMAValidationPlaceholderKey:PLACEHOLDER_ENTER_COMPANY_NAME,    kFMAValidationControlKey:_txtCompanyName},
      @{kFMAValidationPlaceholderKey:PLACEHOLDER_ENTER_STREE_ADDRESS,   kFMAValidationControlKey:_txtStreetAddress},
      @{kFMAValidationPlaceholderKey:PLACEHOLDER_ENTER_PHONE_NUMBER,    kFMAValidationControlKey:_txtPhoneNumber},
      @{kFMAValidationPlaceholderKey:PLACEHOLDER_HOUR1,                 kFMAValidationControlKey:_txtStartHour},
      @{kFMAValidationPlaceholderKey:PLACEHOLDER_HOUR2,                 kFMAValidationControlKey:_txtEndHour},
      @{kFMAValidationPlaceholderKey:PLACEHOLDER_DAY1,                  kFMAValidationControlKey:_txtStartDay},
      @{kFMAValidationPlaceholderKey:PLACEHOLDER_DAY2,                  kFMAValidationControlKey:_txtEndDay},
      ];
    
    return [FMAUtil checkAllFieldsExist:infoFields];
}

- (BOOL)doValidationProcess
{
    [self printLogWith:@"doValidationProcess"];
    
    if (![self checkAllFieldsExist])
    {
        [[FMAUtil generalAlertWithTitle:nil message:ALERT_MSG_FIELDS_EMPTY delegate:self] show];
        return NO;
    }
    
    if (![FMAUtil checkValidPhoneNumberLength:self.txtPhoneNumber.text])
    {
        NSString *msg = [NSString stringWithFormat:@"The length of phone number should be %d.", VALID_PHONE_NUMBER_LENGTH];
        [[FMAUtil generalAlertWithTitle:nil message:msg delegate:self] show];
        [self.txtPhoneNumber becomeFirstResponder];
        
        return NO;
    }
    
    if ([FMAUtil isObjectEmpty:imageCompanyLogo])
    {
        NSString *msg = @"Please choose a company logo.";
        [[FMAUtil generalAlertWithTitle:nil message:msg delegate:self] show];
        return NO;
    }
    
    
    return YES;
}

@end
