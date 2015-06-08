//
//  HomeViewController.m
//  GettingLocationWhenSuspended
//
//  Created by meiyalagan ramadurai on 5/24/15.
//  Copyright (c) 2015 Rick. All rights reserved.
//

#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"
#import <MapKit/MapKit.h>

@interface HomeViewController ()
{
  CLLocationManager *locationManager;
  
  IBOutlet MKMapView *map;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  map.delegate = self;
  map.showsUserLocation = YES;
  [map setCenterCoordinate:map.userLocation.location.coordinate animated:YES];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
  [map setRegion:[map regionThatFits:region] animated:YES];
  
  
  MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
  point.coordinate = userLocation.coordinate;
  point.title = @"Current Location";
  point.subtitle = @"I'm here!!!";
  [map addAnnotation:point];
  
}





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
