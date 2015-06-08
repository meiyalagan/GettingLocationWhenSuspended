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

@interface HomeViewController () <MKMapViewDelegate>
{
  CLLocationManager *locationManager;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.mapView.delegate = self;
  self.mapView.mapType = MKMapTypeStandard;
  self.mapView.showsUserLocation = YES;
  self.searchButton.hidden = YES;
  
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)setMapType:(UISegmentedControl *)sender {
  switch (sender.selectedSegmentIndex) {
    case 0:
      self.mapView.mapType = MKMapTypeStandard;
      break;
    case 1:
      self.mapView.mapType = MKMapTypeSatellite;
      break;
    case 2:
      self.mapView.mapType = MKMapTypeHybrid;
      break;
    default:
      break;
  }
}

- (IBAction)zoomToCurrentLocation:(UIBarButtonItem *)sender {
  float spanX = 0.00725;
  float spanY = 0.00725;
  MKCoordinateRegion region;
  region.center.latitude = self.mapView.userLocation.coordinate.latitude;
  region.center.longitude = self.mapView.userLocation.coordinate.longitude;
  region.span.latitudeDelta = spanX;
  region.span.longitudeDelta = spanY;
  self.searchButton.hidden = YES;
  [self.mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  self.searchButton.hidden = NO;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
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
