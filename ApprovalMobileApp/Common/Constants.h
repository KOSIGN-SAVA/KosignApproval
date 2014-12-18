/*
 *  Constants.h
 *  Constants
 *
 *  Created by 종욱 윤 on 10. 6. 7..
 *  Copyright 2010 (주) 쿠콘. All rights reserved.
 *
 */
#pragma mark-
#pragma mark WCPush constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// WCPush constants
////////////////////////////////////////////////////////////////////////////////////////////////////
#if _DEBUG_
#define kPushServerAddress      @"http://112.187.199.29/push/standard_gateway/gateway.jsp?"//@"http://112.187.199.29/push/gateway/gateway.jsp"
#define kAuthenticationKey      @"429c1bae-04ed-4c93-97f7-14cb8c5a1ec3"
#else
#define kPushServerAddress      @"https://sws.webcash.co.kr/wcp/gateway/gateway.jsp?"//@"http://112.187.199.29/push/gateway/gateway.jsp"
#define kAuthenticationKey      @"8c6ad040-d831-4193-9492-cd534b8996b2"
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////
// image Url constants
////////////////////////////////////////////////////////////////////////////////////////////////////
#if _DEBUG_
#define kImageAddress      @"http://112.187.198.188:8070"//@"http://112.187.199.29/push/gateway/gateway.jsp"
#else
#define kImageAddress      @"https://www.imore.co.kr"//@"http://112.187.199.29/push/gateway/gateway.jsp"
#endif

#define kDeviceToken            @"_deviceToken" //디바이스 토큰값

#define kPushOnOff                 @"pushOnOff"                 // 푸쉬
#define kMailPush                  @"mailPush"                  // 메일푸쉬
#define kPaymentPush               @"paymentPush"               // 결재푸쉬
#define kSchdulePush               @"schdulePush"               // 일정푸쉬
#define kPushSettingNotification   @"PushSettingNotification"   // 푸쉬설정 켜기
#define kPushSaveId                @"PushSaveId"                // 푸쉬 세이브 아이디


#pragma mark-
#pragma mark Application constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// Application constants
////////////////////////////////////////////////////////////////////////////////////////////////////
#define kFileFormatIndex		5

#define AREA_NAV_CLIENT			CGRectMake(0.0f, 0.0f, 320.0f, 363.0f)
#define AREA_MAIN_SHADOW_NAVI	CGRectMake(0.0f, 0.0f, 320.0f, 5.0f)
#define AREA_MAIN_SHADOW_TAB	CGRectMake(0.0f, 362.0f, 320.0f, 5.0f)
#define AREA_MAIL_SHADOW_NAVI	CGRectMake(0.0f, 64.0f, 320.0f, 5.0f)
#define AREA_MAIL_SHADOW_TAB	CGRectMake(0.0f, 475.0f, 320.0f, 5.0f)

#define RGB(r, g, b)			[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)		[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kDefaultFontName				@"Apple SD Gothic Neo"
#define kBoldStyleFontName				@"Helvetica-Bold"
#define kSemiBoldStyleFontName				@"Helvetica-Bold"

#define kItalicStyleFontName			@"Helvetica-Oblique"
#define kBoldItalicStyleFontName		@"Helvetica-BoldOblique"
#define kDefaultFontSize				17.0f
#define kDefaultFontMiddleSize          13.0f
#define kMainTabViewHeight              49.0f


////////////////////////////////////////////////////////////////////////////////////////////////////
// 비밀번호 2회 오류
////////////////////////////////////////////////////////////////////////////////////////////////////
#define kSecondFailedLoginErrorCode		@"CM0001_CM000117"
#define kSecondFailedCorpLoginErrorCode	@"CM0001_CM000126"
#define kThirdFailedLoginErrorCode      @"CM0001_5619008"


#pragma mark-
#pragma mark Database constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// Database constants
////////////////////////////////////////////////////////////////////////////////////////////////////
#define kUserPreferencesFileName		@"UserPreferences.dat"
#define kDatabasePath					@"database/"
#define kDataPath						@"data/"
#define kTempPath						@"tmp/"
#define kImagesPath						@"images/"

#define kCardCompanyIconCodesFileName	@"CardCompIconCodes"
#define kKeyNameOfCheckCardCompany		@"CheckCardCompanyIconCodes"
#define kKeyNameOfCreditCardCompany		@"CreditCardCompanyIconCodes"

#define kBackupHtmlFileName				@"backup"
#define kRestoreHtmlFileName			@"restore"

#pragma mark -
#pragma mark KCalendar ImageCode
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////
// KCalendar ImageCode
////////////////////////////////////////////////////////////////////////////////////////////////////

// -- calendar common
#define AREA_headerMonth_ImageRect  	CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)   // header1Image Rect (년월 표시 부분)
#define kCalendarheaderMonthImageName   @"q10000"                               // header1ImageCode
#define AREA_headerWeek_ImageRect  		CGRectMake(0.0f, 0.0f, 320.0f, 20.0f)  // header2Image Rect (요일 표시 부분)
#define kCalendarheaderWeekImageName    @"e01600"                               // header2ImageCode

#define kMainCalendardaycolumnWidth         42
#define kMainCalendardayrowHeight           33.5       // grid의 한칸 (일자표시되는 tile의 Height)
#define kLocaleIdentifierKOR            @"ko_KR"                                //localeIdentifier -- NSDate -> NSString

#define kCalendarselectedImageCode      @"e05100"   // 선택표시 이미지
#define kCalendarbadgeImageCode         @"e00800"   // badge 이미지
#define kCalendartodayImageCode         @"e05110"   // 오늘표시 이미지
#define kCalendardayrowHeight           33.5       // grid의 한칸 (일자표시되는 tile의 Height)

//#define kCalendartodaybuttonImageCode   @"e01200"   // 오늘이동 버튼 이미지
//#define kCalendarcancelbuttonImageCode  @"e01300"   // 취소버튼 이미지



// -- Monthly calendar (default)
#define AREA_calendar_CLIENT			CGRectMake(0.0f, 45.0f, 320.0f, 336.5f)  // 달력전체(월간) Rect (header1, header2, grid 포함)
#define AREA_custom_calendar_CLIENT		CGRectMake(0.0f, 0.0f, 320.0f, 336.5f)  // 커스텀 달력전체(월간) Rect (header1, header2, grid 포함)
#define AREA_grid_ImageRect  		    CGRectMake(0.0f, 60.0f, 320.0f, 176.0f)  // 달력(월간) gridImageRect (실제 일자 표시 부분)
//#define kCalendargridImageName          @"f00300"                               // 달력(월간) gridImageCode
#define kCalendargridImageName          @"e16300"                               // 달력(월간) gridImageCode

// -- Weekly calendar
#define AREA_calendar_Weekly_CLIENT		CGRectMake(0.0f, 45.0f, 320.0f, 44.0f)   // 달력전체(주간) Rect (header1, header2, grid 포함)
#define AREA_Weekly_grid_ImageRect  	CGRectMake(0.0f, 0.0f, 320.0f, 0.0f)   // 달력(주간) gridImageRect (실제 일자 표시 부분)
#define kCalendarWeeklygridImageName    @"f00500"                               // 달력(주간) gridImageCode

#define kIdentityKOR                    @"Ko_KR"                                //localeIdentifier -- NSDate -> NSString 으로 바꿀때, Korea locale..


#pragma mark-
#pragma mark Limited and minimum value constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// Limited and minimum value constants
////////////////////////////////////////////////////////////////////////////////////////////////////
#define kLimitedValueAcctNo					20	// 계좌번호
#define kLimitedValuePersonNo				13	// 주민등록번호
#define kLimitedValueFrontPartOfPersonNo	6	// 주민등록번호 (앞쪽)
#define kLimitedValueRearPartOfPersonNo		7	// 주민등록번호 (뒷쪽)
#define kLimitedValueBizNo					10	// 사업자등록번호
#define kLimitedValueFrontPartOfBizNo		3	// 사업자등록번호 (앞쪽)
#define kLimitedValueCenterPartOfBizNo		2	// 사업자등록번호 (중간)
#define kLimitedValueRearPartOfBizNo		5	// 사업자등록번호 (뒷쪽)
#define kLimitedValueAcctPassword			4	// 계좌비밀번호
#define kLimitedValueOTPResponse			6	// OTP 응답값

#define kMinimumValueCertPassword			8	// 인증서 비밀번호 최소 자리수
#define KMaximumValueCertPassword           30  // 인증서 비밀번호 최대 자리수
#define kMinimumValueOTPResponse			6	// OTP 응답값의 최소 자리수



#pragma mark-
#pragma mark Common constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// Common constants
////////////////////////////////////////////////////////////////////////////////////////////////////
#define kParamItemTargetURL				@"_URL"
#define kParamItemTargetMenuID			@"_MenuID"
#define kParamItemTargetData			@"_Data"
#define kParamItemTargetBack			@"_Back"
#define kParamItemImageMaxPage			@"_IMGMAXPAGE"
#define kParamItemImageOpen				@"_IMAGE"

#define kTagNumberOfTheFirstPageOfMenu	9991

#define kMsgAttachViewerAuthorization   @"첨부파일뷰어 사용권한이 없습니다."   // 첨부파일 뷰어 사용권한없음 메시지



/*
 모바일웹페이지 설정을 위한 Meta 태그
 
 width : 넓이 – device-width | N px (200~10000 px, default 980 px)
 height : 높이 – device-height | N px (223~10000 px)
 initial-scale : 초기 확대/축소 배율
 minimum-scale : 최소 축소 배율 – N (0~10, default 0.25)
 maximum-scale : 최대 확대 배율 – N (0~10, default 1.6)
 user-scalable : 확대/축소 가능 여부 – yes | no (default yes)
 
 참고: http://easymicro.egloos.com/5462135
 
 */

#define kMobileWebHeader                @"<meta name=\"viewport\" content=\"user-scalable=yes, initial-scale=1.0, maximum-scale=4.0, minimum-scale=0.5, width=320, height=274\" />"


#pragma mark-
#pragma mark Application notification constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// Application notification constants definition
////////////////////////////////////////////////////////////////////////////////////////////////////

#define kAutoLoginNotification                  @"AutoLoginNotification"
#define kShowWaitingViewNotification			@"ShowWaitingView"
#define kCloseWaitingViewNotification			@"CloseWaitingView"
#define kShowActivityAlertNotification			@"ShowActivityAlert"
#define kCloseActivityAlertNotification			@"CloseActivityAlert"
#define kExecuteErrorActionNotification			@"ExecuteErrorAction"
#define kCallMenuNotification					@"CallMenu"
#define kExtraCallMenuNotification				@"ExtraCallMenu"
#define kCopyKTCetification						@"KTCertification"
#define kRequestCheckingSession					@"RequestCheckingSession"
#define kChangedHomeMenuTypeNotification		@"ChangedHomeMenuType"
#define kChangedTabMenuNotification				@"ChangedTabMenu"
#define kRequestLogin							@"RequestLogin"
#define kShowSubMenuNotification				@"ShowSubMenu"
#define kGoBackNotification						@"GoBack"
#define kGoHomeNotification						@"GoHome"
#define kHideLeftSubMenuNotification			@"HideLeftSubMenu"
#define kHideMenuLinkNotification				@"HideMenuLink"
//#define kInitializeServiceNotification
#define kStartMenuServie						@"StartMenuService"
#define kHomeRefreshScreen						@"HomeRefreshScreen"
#define kHomeMailCalendarClick					@"HomeMailCalendarClick"
#define kHomeMailDetail							@"HomeMailDetail"
#define kScheduleRefreshScreen					@"ScheduleRefreshScreen"
#define kScheduleDetailRefreshScreen            @"kScheduleDetailRefreshScreen"
#define kCallCfMyMenuRegNotification			@"CallMyMenu"
#define kCallUseConfirmNotification				@"CallUseConfirm"
#define kRefrashMyMenuNotification				@"RefrashMyMenu"
#define kToolBarHiddenNotification				@"TooBarHiddenGb"
#define kCalendarRefreshScreen                  @"CalendarRefreshScreen"
#define kNaviBarHiddenNotification				@"NaviBarHiddenNotification"
#define kNaviBarShowNotification				@"NaviBarShowNotification"
#define kCallCfMyPushRegNotification			@"CallMyPush"
#define kNaviRootPop                            @"NaviRootPop"
#define kPopUpClose                             @"PopUpClose"
#define kSelectSns                              @"SelectSns"
#define kTutoPopUpClose                         @"TutoPopUpClose"
#define kRegisterView                           @"RegisterView"
#define kParentsReload                          @"ParentsReload"
#define kSegueOut                               @"SegueOut"

#define kclosePDFviewNotification               @"closePDFviewNotification"
#define kTabbarResetNotification               @"TabbarResetNotification"
#define kTabbarSelectNotification               @"TabbarSelectNotification"
#define kTabbarSelectBtNotification               @"TabbarSelectBtNotification"
#define kTabbarReloadNotification               @"TabbarReloadNotification"
#define kPushStartNotification               @"PushStartNotification"
#define kTabbarCarSelectNotification               @"TabbarCarSelectNotification"
#define kTabbarCarBtSelectNotification               @"TabbarCarBtSelectNotification"

#define kTabbarNotiSelectNotification               @"TabbarNotiSelectNotification"
#define kTabbarNotiSelectBtNotification               @"TabbarNotiSelectBtNotification"

#define kpopFoodView                            @"popFoodView"
#define ksesstionLogout                         @"sesstionLogout"
#define kMainViewChangeNotification             @"MainViewChangeNotification"

#define kDayLogoutNotification                  @"DayLogoutNotification"

#pragma mark-
#pragma mark Error action code constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// Error action code constants definition
////////////////////////////////////////////////////////////////////////////////////////////////////
#define kKeyOfErrorAction						@"_action_type"
#define kKeyOfErrorMessage						@"_err_msg"
#define kErrorActionCodeKeepCurrentPage			@"1000"
#define kErrorActionCodeGoToFirstPage			@"1001"
#define kErrorActionCodeGoToHomeAfterLogout		@"1002"
#define kErrorActionCodeGoToSpecifiedPage		@"1003"
#define kErrorActionCodeGoToHome				@"1004"
#define kErrorActionCodeQuit					@"9999"


#pragma mark-
#pragma mark MAIL constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// Mail Interface constants definition
////////////////////////////////////////////////////////////////////////////////////////////////////
#define kMailFROM                               @"FROM"
#define kMailFROMNAME                           @"FROMNAME"
#define kMailTO									@"TO"
#define kMailCC									@"CC"
#define kMailBCC								@"BCC"
#define kMailSUBJECT							@"SUBJECT"
#define kMailTEXT								@"TEXT"
#define kMailATTACH								@"ATTFILE_REC"
#define kMailBOXID								@"BOXID"
#define kMailUID								@"UID"
#define kMailTYPE								@"MAILTYPE"
#define kMailSTATUS								@"MAILSTATUS"




#pragma mark-
#pragma mark CMS(Contents Management System) constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// Web action constants definition
////////////////////////////////////////////////////////////////////////////////////////////////////
//#define kActionTypeQRCode					@"cs_QRCode()"
//#define kActionTypeBrowserClose				@"cs_close()"
//#define kActionTypeGoHome					@"cs_gohome()"
//#define kActionTypeLogin					@"cs_login()"
//#define kActionTypeCertSign					@"cs_signdata()"

////////////////////////////////////////////////////////////////////////////////////////////////////
// Web action constants definition
////////////////////////////////////////////////////////////////////////////////////////////////////
#define kURLSchemeSecurityKeypad				@"iWebKey"
#define kURLSchemeWebAction						@"iWebActionWB"
#define kURLSchemeWebUI							@"iwebUIWB"
#define kURLSchemeWebCert						@"iWebCertWB"
#define kActionTypeGoBack						@"5001"
#define kActionTypeGoHome						@"5004"
#define kActionTypeGoMenu						@"5005"
#define kActionTypeGoLogOut						@"5101"
#define kActionTypeQRCode						@"5106"
#define kActionTypePDFView						@"5107"
#define kActionTypeMAPView						@"5108"
#define kActionTypeGoSafari                     @"5109"       // go URL safari : (Scheme: http or https 인경우 safari brower 호출 , App Scheme 인경우 앱이동)
#define kActionTypeGoScheme                     @"5110"       // go URLScheme (5109와 동일: 안드로이드에서 사용) : (Scheme: http or https 인경우 safari brower 호출 , App Scheme 인경우 앱이동)
#define kActionTypeResultSMS                    @"5111"       // 이체완료후 SMS 전송 결과 (개인뱅킹의 경우 action_type: "cs_sms()" 로 사용했던 코드)
#define kActionTypeDeviceInfo                   @"5112"       // deviceinfo 요청 ("_udid" .. )
// 5113 //
#define kActionTypeARView                       @"5114"       // AR 호출

#define kActionTypeLogin						@"cs_login()"
#define kActionTypeBrowserClose					@"cs_close()"
#define kActionTypeCertSign						@"cs_signdata()"
#define kWebActionTypeSavePDF					@"cs_savePDF()"



#pragma mark-
#pragma mark CMS(Contents Management System) constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// CMS(Contents Management System) constants definition
////////////////////////////////////////////////////////////////////////////////////////////////////
#define kKeyOfMasterID						@"_master_id"
#define kKeyOfGateMenuID					@"_menu_id"
#define kKeyOfSubMenus						@"_menu_info"
#define kKeyOfMenuID						@"c_menu_id"
#define kKeyOfMenuTitle						@"c_menu_title"

#define kKeyBoxIndex						@"_boxIndex"
#define	kKeyBadgeType						@"_badgeType"
#define kKeyBadgeCount						@"_badgeCount"



#pragma mark-
#pragma mark Trans document constants
#pragma mark-
////////////////////////////////////////////////////////////////////////////////////////////////////
// Trans document constants definition
////////////////////////////////////////////////////////////////////////////////////////////////////
#define kTransCode							@"API_KEY"			// 거래코드
#define kTransRequestData					@"REQ_DATA"	// 요청부
#define kTransResponseData					@"RESP_DATA"	// 응답부
#define kResponseErrorCode					@"RSLT_CD"		// 에러코드
#define kResponseErrorMsg					@"RSLT_MSG"		// 에러 메시지
#define kResponseErrorAction				@"_error_action"	// 오류 처리 방법

#define kDocNameGateMenus					@"MG0001"			// CMS 게이트 전문
#define kDocNameGateSubMenus				@"MM0001"			// 게이트 하위메뉴조회
#define kDocNameCheckLogin					@"P01010"			// 로그인 여부
#define kDocNameCertLogin					@"P01012"			// 인증서 로그인
#define kDocNameRequestInquiryCert			@"P09022"			// 타행인증서 조회
#define kDocNameRequestCertUserInfo			@"P09021"			// 타행인증서 고객정보조회
#define kDocNameRequestCertRegistration		@"P09020"			// 타행인증서 등록 (실행)
#define kDocNameRequestSecurityCard			@"P01040"			// 보안카드 채번(비로그인)
#define kDocNameResultSecurityCard			@"P01050"			// 보안카드 검증(비로그인)
#define kDocNameRequestSecurityValidation	@"P01030"			// 보안카드 / OTP 검증 (로그인)