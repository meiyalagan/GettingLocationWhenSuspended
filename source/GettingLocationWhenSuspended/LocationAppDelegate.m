//
//  LocationAppDelegate.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//


#import "LocationAppDelegate.h"
#import "TabBarViewController.h"
#import "LocationViewController.h"

@interface LocationAppDelegate()
{
    NSString *deviceUniqueID;
    NSString *latitudeStr;
    NSString *longitudeStr;
    NSString *dateAndTimeStr;
    NSString *accuracyStr;
    NSString *deviceStateStr;
 //   TabBarViewController *tabBarVC;
}
@end
@implementation LocationAppDelegate






- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    
    
    int i = 0;
    while (i < 10) {
        i++;
        NSLog(@"sfgsdfg sdfgdfg  sdfgdsg");
    }
    
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    
    
    UIUserNotificationSettings *mySettings =
    
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
//    NSString *reverseStr = @"Meiyalagan";
//    NSMutableString *mutableStr = [[NSMutableString alloc] init];
//    
//    NSUInteger lengthOfReverseStr = [reverseStr length];
//    
//    while (lengthOfReverseStr > 0) {
//        lengthOfReverseStr --;
//        NSRange testRange = NSMakeRange(lengthOfReverseStr, 1);
//        [mutableStr appendString:[reverseStr substringWithRange:testRange]];
//    }
    

    
    
        //  [self testM];
    
    
   
    NSUserDefaults *userPhoneNumber = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[userPhoneNumber valueForKey:@"PhoneNumber"]);
    
    
    self.shareModel = [LocationShareModel sharedModel];
    self.shareModel.afterResume = NO;
    
    [self addApplicationStatusToPList:@"didFinishLaunchingWithOptions"];
   
    
    if (![userPhoneNumber valueForKey:@"PhoneNumber"]) {
        
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LocationViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"locationViewControllerID"];
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
    else {
        
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        TabBarViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewControllerID"];
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
        
    }
    
    
    
  //  [self presentViewController:vc animated:YES completion:nil];
    
    
     UIAlertView * alert;
        //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{
        
        // When there is a significant changes of the location,
        // The key UIApplicationLaunchOptionsLocationKey will be returned from didFinishLaunchingWithOptions
        // When the app is receiving the key, it must reinitiate the locationManager and get
        // the latest location updates
        
        // This UIApplicationLaunchOptionsLocationKey key enables the location update even when
        // the app has been killed/terminated (Not in th background) by iOS or the user.

        if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
            NSLog(@"UIApplicationLaunchOptionsLocationKey");
            
            // This "afterResume" flag is just to show that he receiving location updates
            // are actually from the key "UIApplicationLaunchOptionsLocationKey"
            self.shareModel.afterResume = YES;
            self.shareModel.anotherLocationManager = [[CLLocationManager alloc]init];
            self.shareModel.anotherLocationManager.delegate = self;
            self.shareModel.anotherLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            self.shareModel.anotherLocationManager.activityType = CLActivityTypeOtherNavigation;
            
            if(IS_OS_8_OR_LATER) {
                [self.shareModel.anotherLocationManager requestAlwaysAuthorization];
            }
            
            [self.shareModel.anotherLocationManager startMonitoringSignificantLocationChanges];
            
            [self addResumeLocationToPList];
        }
    }
    
    return YES;
}


//- (void)startSignificantChangeUpdates
//
//{
//    
//    // Create the location manager if this object does not
//    
//    // already have one.
//    
//    if (nil == locationManager)
//        
//        locationManager = [[CLLocationManager alloc] init];
//    
//    
//    
//    locationManager.delegate = self;
//    
//    [locationManager startMonitoringSignificantLocationChanges];
//    
//}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"locationManager didUpdateLocations: %@",locations);

    for(int i=0;i<locations.count;i++){
        
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        self.myLocation = theLocation;
        self.myLocationAccuracy = theAccuracy;
    }
    
    [self addLocationToPList:self.shareModel.afterResume];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    [self.shareModel.anotherLocationManager stopMonitoringSignificantLocationChanges];
    
    if(IS_OS_8_OR_LATER) {
        [self.shareModel.anotherLocationManager requestAlwaysAuthorization];
    }
    [self.shareModel.anotherLocationManager startMonitoringSignificantLocationChanges];
    
    [self addApplicationStatusToPList:@"applicationDidEnterBackground"];
    
        [self alaramMethod];
    
//    int i = 0;
//    while (i < 10) {
//        i++;
//        [self alaramMethod];
//        
//    }
    
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    
    [self addApplicationStatusToPList:@"applicationDidBecomeActive"];
    
    //Remove the "afterResume" Flag after the app is active again.
    self.shareModel.afterResume = NO;

    if(self.shareModel.anotherLocationManager)
        [self.shareModel.anotherLocationManager stopMonitoringSignificantLocationChanges];
    
    self.shareModel.anotherLocationManager = [[CLLocationManager alloc]init];
    self.shareModel.anotherLocationManager.delegate = self;
    self.shareModel.anotherLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.shareModel.anotherLocationManager.activityType = CLActivityTypeOtherNavigation;
    
    if(IS_OS_8_OR_LATER) {
        [self.shareModel.anotherLocationManager requestAlwaysAuthorization];
    }
    [self.shareModel.anotherLocationManager startMonitoringSignificantLocationChanges];
}


-(void)applicationWillTerminate:(UIApplication *)application{
    NSLog(@"applicationWillTerminate");
    [self addApplicationStatusToPList:@"applicationWillTerminate"];
}


///////////////////////////////////////////////////////////////
// Below are 3 functions that add location and Application status to PList
// The purpose is to collect location information locally

-(void)addResumeLocationToPList{
    
    NSLog(@"addResumeLocationToPList");
    UIApplication* application = [UIApplication sharedApplication];
    
    NSString * appState;
    if([application applicationState]==UIApplicationStateActive)
        appState = @"UIApplicationStateActive";
    if([application applicationState]==UIApplicationStateBackground)
        appState = @"UIApplicationStateBackground";
    if([application applicationState]==UIApplicationStateInactive)
        appState = @"UIApplicationStateInactive";
    
    self.shareModel.myLocationDictInPlist = [[NSMutableDictionary alloc]init];
    [self.shareModel.myLocationDictInPlist setObject:@"UIApplicationLaunchOptionsLocationKey" forKey:@"Resume"];
    [self.shareModel.myLocationDictInPlist setObject:appState forKey:@"AppState"];
    [self.shareModel.myLocationDictInPlist setObject:[NSDate date] forKey:@"Time"];
    
    
    NSString *plistName = [NSString stringWithFormat:@"LocationArray.plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docDir, plistName];
    
    NSMutableDictionary *savedProfile = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    
    if (!savedProfile){
        savedProfile = [[NSMutableDictionary alloc] init];
        self.shareModel.myLocationArrayInPlist = [[NSMutableArray alloc]init];
    }
    else{
        self.shareModel.myLocationArrayInPlist = [savedProfile objectForKey:@"LocationArray"];
    }
    
    if(self.shareModel.myLocationDictInPlist)
    {
        [self.shareModel.myLocationArrayInPlist addObject:self.shareModel.myLocationDictInPlist];
        [savedProfile setObject:self.shareModel.myLocationArrayInPlist forKey:@"LocationArray"];
    }
    
    if (![savedProfile writeToFile:fullPath atomically:FALSE] ) {
        NSLog(@"Couldn't save LocationArray.plist" );
    }
    
    NSLog(@"Dict: %@",self.shareModel.myLocationDictInPlist);
    
    [self callWebService];
    
}



-(void)addLocationToPList:(BOOL)fromResume{
    NSLog(@"addLocationToPList");
    
    UIApplication* application = [UIApplication sharedApplication];
    
    NSString * appState;
    if([application applicationState]==UIApplicationStateActive)
        appState = @"UIApplicationStateActive";
    if([application applicationState]==UIApplicationStateBackground)
        appState = @"UIApplicationStateBackground";
    if([application applicationState]==UIApplicationStateInactive)
        appState = @"UIApplicationStateInactive";
    
    self.shareModel.myLocationDictInPlist = [[NSMutableDictionary alloc]init];
    [self.shareModel.myLocationDictInPlist setObject:[NSNumber numberWithDouble:self.myLocation.latitude]  forKey:@"Latitude"];
    [self.shareModel.myLocationDictInPlist setObject:[NSNumber numberWithDouble:self.myLocation.longitude] forKey:@"Longitude"];
    [self.shareModel.myLocationDictInPlist setObject:[NSNumber numberWithDouble:self.myLocationAccuracy] forKey:@"Accuracy"];
    
    
    [self.shareModel.myLocationDictInPlist setObject:appState forKey:@"AppState"];
    
    if(fromResume)
        [self.shareModel.myLocationDictInPlist setObject:@"YES" forKey:@"AddFromResume"];
    else
        [self.shareModel.myLocationDictInPlist setObject:@"NO" forKey:@"AddFromResume"];
    
    [self.shareModel.myLocationDictInPlist setObject:[NSDate date] forKey:@"Time"];
    
    NSString *plistName = [NSString stringWithFormat:@"LocationArray.plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docDir, plistName];
    
    NSMutableDictionary *savedProfile = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    
    if (!savedProfile){
        savedProfile = [[NSMutableDictionary alloc] init];
        self.shareModel.myLocationArrayInPlist = [[NSMutableArray alloc]init];
    }
    else{
        self.shareModel.myLocationArrayInPlist = [savedProfile objectForKey:@"LocationArray"];
    }
    
    NSLog(@"Dict: %@",self.shareModel.myLocationDictInPlist);
    
    if(self.shareModel.myLocationDictInPlist)
    {
        [self.shareModel.myLocationArrayInPlist addObject:self.shareModel.myLocationDictInPlist];
        [savedProfile setObject:self.shareModel.myLocationArrayInPlist forKey:@"LocationArray"];
    }
    
    if (![savedProfile writeToFile:fullPath atomically:FALSE] ) {
        NSLog(@"Couldn't save LocationArray.plist" );
    }
    
    [self callWebService];
    
    NSLog(@"Dict: %@",self.shareModel.myLocationDictInPlist);
}



-(void)addApplicationStatusToPList:(NSString*)applicationStatus{
    
    NSLog(@"addApplicationStatusToPList");
    UIApplication* application = [UIApplication sharedApplication];
    
    NSString * appState;
    if([application applicationState]==UIApplicationStateActive)
        appState = @"UIApplicationStateActive";
    if([application applicationState]==UIApplicationStateBackground)
        appState = @"UIApplicationStateBackground";
    if([application applicationState]==UIApplicationStateInactive)
        appState = @"UIApplicationStateInactive";
    
    self.shareModel.myLocationDictInPlist = [[NSMutableDictionary alloc]init];
    [self.shareModel.myLocationDictInPlist setObject:applicationStatus forKey:@"applicationStatus"];
    [self.shareModel.myLocationDictInPlist setObject:appState forKey:@"AppState"];
    [self.shareModel.myLocationDictInPlist setObject:[NSDate date] forKey:@"Time"];
    
    NSString *plistName = [NSString stringWithFormat:@"LocationArray.plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docDir, plistName];
    
    NSMutableDictionary *savedProfile = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    
    if (!savedProfile){
        savedProfile = [[NSMutableDictionary alloc] init];
        self.shareModel.myLocationArrayInPlist = [[NSMutableArray alloc]init];
    }
    else{
        self.shareModel.myLocationArrayInPlist = [savedProfile objectForKey:@"LocationArray"];
    }
    
    if(self.shareModel.myLocationDictInPlist)
    {
        [self.shareModel.myLocationArrayInPlist addObject:self.shareModel.myLocationDictInPlist];
        [savedProfile setObject:self.shareModel.myLocationArrayInPlist forKey:@"LocationArray"];
    }
    
    if (![savedProfile writeToFile:fullPath atomically:FALSE] ) {
        NSLog(@"Couldn't save LocationArray.plist" );
    }
    
    [self callWebService];
    
    
    
    
}

-(void)callWebService {
    
    
  
    
    accuracyStr     = [self.shareModel.myLocationDictInPlist objectForKey:@"Accuracy"];
    deviceStateStr  = [self.shareModel.myLocationDictInPlist objectForKey:@"AppState"];
    dateAndTimeStr = [self.shareModel.myLocationDictInPlist objectForKey:@"Time"];
    latitudeStr = [[NSNumber numberWithDouble:self.myLocation.latitude] stringValue];
    longitudeStr = [[NSNumber numberWithDouble:self.myLocation.longitude] stringValue];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.meiy.5gbfree.com/updateQuery.php?lat=%@&long=%@&devid=002&acc=%@&appstate=%@ WHERE phnum=8095496009",latitudeStr,longitudeStr,accuracyStr,deviceStateStr];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"/n" withString:@"%0A"];
    NSURL *url = [[NSURL alloc]initWithString:urlString];
//    
//    
//    NSData *data = [NSData dataWithContentsOfURL:url];
    
    
//    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://www.meiy.5gbfree.com/servicequery.php?name=Meiy&phnum=123546589&bg=B&devid=001&lat=%@&long=%@&acc=%@&appstate=%@",latitudeStr,longitudeStr,accuracyStr,dateAndTimeStr]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    
//    int latDecimalValue = [latitudeStr intValue];
//    int longDecimalValue = [longitudeStr intValue];
//    
//    
//    if (![latitudeStr intValue] == 0) {
//        
//        NSRange range = [latitudeStr rangeOfString:@"." options: NSBackwardsSearch];
//        NSString *latRemString = [latitudeStr substringFromIndex:(range.location+1)];
//        NSLog(@"%@",latRemString);
//        
//        NSRange range2 = [longitudeStr rangeOfString:@"." options: NSBackwardsSearch];
//        NSString *longRemString = [latitudeStr substringFromIndex:(range2.location+1)];
//        NSLog(@"%@",longRemString);
//        
//        int topLeftLat      = [latRemString intValue]   + 4000;
//        int topLeftLong     = [longRemString intValue]  - 4000;
//        int bottomRightLat  = [latRemString intValue]   - 4000;
//        int bottomRightLong = [longRemString intValue]  + 4000;
//        
//        NSLog(@"\n\n TopLestLat:::%d",topLeftLat);
//        NSLog(@"\n\n topLeftLong:::%d",topLeftLong);
//        NSLog(@"\n\n bottomRightLat:::%d",bottomRightLat);
//        NSLog(@"\n\n bottomRightLong:::%d",bottomRightLong);
//        
//        
//        NSString *appendStrTopLeftLat = [NSString stringWithFormat:@"%d",latDecimalValue];
//        appendStrTopLeftLat = [appendStrTopLeftLat stringByAppendingString:[NSString stringWithFormat:@".%d",topLeftLat]];
//        
//        NSString *appendStrTopLeftLong = [NSString stringWithFormat:@"%d",longDecimalValue];
//        appendStrTopLeftLong = [appendStrTopLeftLong stringByAppendingString:[NSString stringWithFormat:@".%d",topLeftLong]];
//        
//        NSString *appendStrBottomRightLat = [NSString stringWithFormat:@"%d",latDecimalValue];
//        appendStrBottomRightLat = [appendStrBottomRightLat stringByAppendingString:[NSString stringWithFormat:@".%d",bottomRightLat]];
//        
//        NSString *appendStrBottomRightLong = [NSString stringWithFormat:@"%d",longDecimalValue];
//        appendStrBottomRightLong = [appendStrBottomRightLong stringByAppendingString:[NSString stringWithFormat:@".%d",bottomRightLong]];
//        
//        
//        if (([appendStrTopLeftLat intValue] < [latitudeStr intValue]) && ([appendStrBottomRightLat intValue] > [latitudeStr intValue]) && ([appendStrTopLeftLong intValue] < [longitudeStr intValue]) && ([appendStrBottomRightLong intValue] > [longitudeStr intValue])) {
//            
//            [self alaramMethod];
//        }
//    }
}

- (void)testM {
    
    latitudeStr = @"12.910321"; //12.910321,77.626884
    longitudeStr = @"77.626884";//77.622743
    
    NSRange range = [latitudeStr rangeOfString:@"." options: NSBackwardsSearch];
    NSString *currentLatPoint = [latitudeStr substringFromIndex:(range.location+1)];
    NSLog(@"%@",currentLatPoint);
    
    NSRange range2 = [longitudeStr rangeOfString:@"." options: NSBackwardsSearch];
    NSString *currentLongPoint = [longitudeStr substringFromIndex:(range2.location+1)];
    NSLog(@"%@",currentLongPoint);
    
    
    NSString *destinationSelectedLat = @"12.917276";
    NSString *destinationSelectedLong = @"77.622743";
    
    
//    int latDecimalValue = [latitudeStr intValue];
//    int longDecimalValue = [longitudeStr intValue];
    
    
    if (![latitudeStr intValue] == 0) {
        
        NSRange range = [destinationSelectedLat rangeOfString:@"." options: NSBackwardsSearch];
        NSString *latRemString = [destinationSelectedLat substringFromIndex:(range.location+1)];
        NSLog(@"%@",latRemString);
        
        NSRange range2 = [destinationSelectedLong rangeOfString:@"." options: NSBackwardsSearch];
        NSString *longRemString = [destinationSelectedLong substringFromIndex:(range2.location+1)];
        NSLog(@"%@",longRemString);
        
        int topLeftLat      = [latRemString intValue]   + 10000;
        int topLeftLong     = [longRemString intValue]  - 10000;
        int bottomRightLat  = [latRemString intValue]   - 10000;
        int bottomRightLong = [longRemString intValue]  + 10000;
        
        
        NSLog(@"\n\n TopLestLat:::%d",topLeftLat);
        NSLog(@"\n\n topLeftLong:::%d",topLeftLong);
        NSLog(@"\n\n bottomRightLat:::%d",bottomRightLat);
        NSLog(@"\n\n bottomRightLong:::%d",bottomRightLong);
        
        if ((topLeftLat > [currentLatPoint intValue] && bottomRightLat < [currentLatPoint intValue]) && ( topLeftLong < [currentLongPoint intValue] && bottomRightLong > [currentLongPoint intValue])) {

            [self alaramMethod];
        }
        
        
        
//        NSString *appendStrTopLeftLat = [NSString stringWithFormat:@"%d",latDecimalValue];
//        appendStrTopLeftLat = [appendStrTopLeftLat stringByAppendingString:[NSString stringWithFormat:@".%d",topLeftLat]];
//        
//        NSString *appendStrTopLeftLong = [NSString stringWithFormat:@"%d",longDecimalValue];
//        appendStrTopLeftLong = [appendStrTopLeftLong stringByAppendingString:[NSString stringWithFormat:@".%d",topLeftLong]];
//        
//        NSString *appendStrBottomRightLat = [NSString stringWithFormat:@"%d",latDecimalValue];
//        appendStrBottomRightLat = [appendStrBottomRightLat stringByAppendingString:[NSString stringWithFormat:@".%d",bottomRightLat]];
//        
//        NSString *appendStrBottomRightLong = [NSString stringWithFormat:@"%d",longDecimalValue];
//        appendStrBottomRightLong = [appendStrBottomRightLong stringByAppendingString:[NSString stringWithFormat:@".%d",bottomRightLong]];
//        
//        NSNumber *latOrgNum = [NSNumber numberWithFloat:[latitudeStr floatValue]];
//        NSNumber *longOrgNum = [NSNumber numberWithFloat:[longitudeStr floatValue]];
//
//        NSNumber *appendTopLeftLatNum = [NSNumber numberWithFloat:[appendStrTopLeftLat floatValue]];
//        NSNumber *appendTopLeftLongNum = [NSNumber numberWithFloat:[appendStrTopLeftLong floatValue]];
//        NSNumber *appendBottomRightLatNum = [NSNumber numberWithFloat:[appendStrBottomRightLat floatValue]];
//        NSNumber *appendBottomRightLongNum = [NSNumber numberWithFloat:[appendStrBottomRightLong floatValue]];
//        
//        
//        
//        NSLog(@"\n\n TopLestLat:::%@",appendTopLeftLatNum);
//        NSLog(@"\n\n topLeftLong:::%@",appendTopLeftLongNum);
//        NSLog(@"\n\n bottomRightLat:::%@",appendBottomRightLatNum);
//        NSLog(@"\n\n bottomRightLong:::%@",appendBottomRightLongNum);
        
        
        
    }
    
}


- (void) alaramMethod {
    
    UILocalNotification *local = [[UILocalNotification alloc] init];
    
    // create date/time information
    local.fireDate = [NSDate dateWithTimeIntervalSinceNow:0]; //time in seconds
    local.timeZone = [NSTimeZone defaultTimeZone];
    
    // set notification details
    local.alertBody = @"Alarm!";
    local.alertAction = @"Okay!";
    
    
    local.soundName = [NSString stringWithFormat:@"Annoying.caf"];
    
    // Gather any custom data you need to save with the notification
    NSDictionary *customInfo =
    [NSDictionary dictionaryWithObject:@"ABCD1234" forKey:@"yourKey"];
    local.userInfo = customInfo;
    
    // Schedule it!
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    
}


@end
