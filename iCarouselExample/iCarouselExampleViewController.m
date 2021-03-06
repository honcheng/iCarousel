//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "iCarouselExampleViewController.h"


@interface iCarouselExampleViewController () <UIActionSheetDelegate>

@property (nonatomic, assign) BOOL wrap;

@end


@implementation iCarouselExampleViewController

@synthesize carousel;
@synthesize navItem;
@synthesize wrap;

- (void)dealloc
{
    [carousel release];
    [navItem release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    carousel.type = iCarouselTypeCoverFlow;
    wrap = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
    self.navItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)switchCarouselType
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Carousel Type"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Linear", @"Rotary", @"Inverted Rotary", @"Cylinder", @"Inverted Cylinder", @"CoverFlow", @"Custom", nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (IBAction)toggleWrap
{
    wrap = !wrap;
    navItem.rightBarButtonItem.title = wrap? @"Wrap: ON": @"Wrap: OFF";
    [carousel reloadData];
}

#pragma mark -
#pragma mark UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //restore view opacities to normal
    for (UIView *view in carousel.itemViews)
    {
        view.alpha = 1.0;
    }
        
    carousel.type = buttonIndex;
    navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 12;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    //create a numbered view
    UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
    label.text = [NSString stringWithFormat:@"%i", index];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [label.font fontWithSize:50];
    [view addSubview:label];
    return view;
}

- (float)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return 210;
}

- (CATransform3D)carousel:(iCarousel *)carousel transformForItemView:(UIView *)view withOffset:(float)offset
{
    //implement 'flip3D' style carousel
    
    //set opacity based on distance from camera
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    //do 3d transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return wrap;
}

@end
