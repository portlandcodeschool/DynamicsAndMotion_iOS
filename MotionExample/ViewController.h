//
//  ViewController.h
//  MotionExample
//
//  Created by Erick Bennett on 2/2/15.
//  Copyright (c) 2015 Erick Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

@property (nonatomic, strong) UIDynamicAnimator* animator;

@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) UIImageView *ballImage;

@end

