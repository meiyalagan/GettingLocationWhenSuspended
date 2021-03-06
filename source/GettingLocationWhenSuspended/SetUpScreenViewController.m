//
//  LocationViewController.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import "SetUpScreenViewController.h"
#import "TabBarViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"
#import "HomeViewController.h"

@interface SetUpScreenViewController ()
{
  CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *userBloodGroup;
@property (strong,nonatomic) LocationShareModel * shareModel;

@end

@implementation SetUpScreenViewController

- (IBAction)btnForBloodGroup:(id)sender {
  
  
  
}
- (IBAction)btnForNextView:(id)sender {
  
  self.shareModel = [LocationShareModel sharedModel];
  
  locationManager = [[CLLocationManager alloc] init];
  locationManager.distanceFilter = kCLDistanceFilterNone;
  locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
  [locationManager startUpdatingLocation];
  
  NSString *strLat = [NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
  NSString *strLong = [NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
  
  NSUserDefaults *userName = [NSUserDefaults standardUserDefaults];
  [userName objectForKey:@"UserName"];
  [userName setObject:self.userNameTextField.text forKey:@"UserName"];
  NSUserDefaults *userPhoneNumber = [NSUserDefaults standardUserDefaults];
  [userPhoneNumber objectForKey:@"PhoneNumber"];
  [userPhoneNumber setObject:self.userPhoneNumberTextField.text forKey:@"PhoneNumber"];
  
  NSString *urlString = [NSString stringWithFormat:@"http://www.meiy.5gbfree.com/servicequery.php?name=%@&phnum=%@&bg=%@&devid=001&lat=%@&long=%@&acc=%@&appstate=%@",self.userNameTextField.text,self.userPhoneNumberTextField.text,self.userBloodGroup.text,strLat,strLong,[self.shareModel.myLocationDictInPlist objectForKey:@"Accuracy"],[self.shareModel.myLocationDictInPlist objectForKey:@"AppState"]];
  urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
  urlString = [urlString stringByReplacingOccurrencesOfString:@"/n" withString:@"%0A"];
  NSHTTPURLResponse *response = nil;
  NSError *error = nil;
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
  NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  NSLog(@"~~~~~ Status code: %ld", (long)[response statusCode]);
  
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  HomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewControllerID"];
  [self presentViewController:viewController animated:YES completion:nil];
  
}







- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  
  // Do any additional setup after loading the view, typically from a nib.
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
