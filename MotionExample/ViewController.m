//
//  ViewController.m
//  MotionExample
//
//  Created by Erick Bennett on 2/2/15.
//  Copyright (c) 2015 Erick Bennett. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //Motion effect for backgroundImage
    
    //Create our animator, this is what renders all the view changes depending on the behaviors added.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //Create our imagview that holds the ball image
    self.ballImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - 25, 0, 50, 50)];
    
    self.ballImage.image = [UIImage imageNamed:@"ball"];
    [self.view addSubview:self.ballImage];
    
    //This code will add a gravity behavior to the object it is applied too
    //UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.ballImage]];
    //[self.animator addBehavior:gravity];
    

    //Create a UIView on the screen and make it red.
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    barView.center = self.view.center;
    barView.backgroundColor = [UIColor redColor];
    [self.view addSubview:barView];
    
    
    
    //Create a collision behavior and init it with the objects to be affected,
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.ballImage, barView]];
    //This creates a collision boundry around our views boundry
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    
    
    //Create the motion effect for the x axis
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    //This sets the min/max movement in this direction
    xAxis.minimumRelativeValue = @(50);
    xAxis.maximumRelativeValue = @(-50);
    
    
    //Create the motion effect for the y axis
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    //This sets the min/max movement in this direction
    yAxis.minimumRelativeValue = @(50);
    yAxis.maximumRelativeValue = @(-50);
    
    
    //Group the above UIInterpolatingMotionEffects into an effects group so we can add them to our background view. The view you add it too is the view that gets moved around.
    UIMotionEffectGroup *backgroundMotionEffect = [[UIMotionEffectGroup alloc] init];
    backgroundMotionEffect.motionEffects = @[xAxis, yAxis];
    [self.backgroundView addMotionEffect:backgroundMotionEffect];
    
    
    //Create some additional behavior for the ball image
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballImage]];
    //This afects the bounce rate.
    itemBehaviour.elasticity = 1;
    //This also affects the bounce rate.
    itemBehaviour.resistance = .25;
    [self.animator addBehavior:itemBehaviour];
    
    
    //We are going to create a collision boundry by drawing a line from one point to another.
    CGPoint rightEdge = CGPointMake(barView.frame.origin.x +
                                    barView.frame.size.width, barView.frame.origin.y);
    
    [collision addBoundaryWithIdentifier:@"horizontalObsticle"
                               fromPoint:barView.frame.origin
                                 toPoint:rightEdge];

    
    //Create our motion manager so we can get accelerometer updates
    self.motionManager = [[CMMotionManager alloc] init];
    
    //The update interval (in seconds) of the accelerometer data
    self.motionManager.accelerometerUpdateInterval = .1;
    
    //Start accelerometer updates and pass data to push method
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self push:accelerometerData];
    }];
  
}

-(void) push:(CMAccelerometerData *)accelerometerData {
    
    //Create push behavior to nudge the ball image. Push behaviors can be instantaneous or continuous
    UIPushBehavior *pushMe = [[UIPushBehavior alloc] initWithItems:@[self.ballImage] mode:UIPushBehaviorModeInstantaneous];
    
    //Use the accelerometer data passed to this method to nudge the ball some factor of x and y.
    pushMe.pushDirection = CGVectorMake(accelerometerData.acceleration.x, -accelerometerData.acceleration.y);
    //Used activate the push force
    pushMe.active = YES;
    
    [self.animator addBehavior:pushMe];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
