//
//  HomeViewController.h
//  GettingLocationWhenSuspended
//
//  Created by meiyalagan ramadurai on 5/24/15.
//  Copyright (c) 2015 Rick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface HomeViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end
