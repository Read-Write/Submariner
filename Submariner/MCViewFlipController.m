
// Released by Drew McCormack into the pubic domain (2010).

#import "MCViewFlipController.h"

@implementation CAAnimation (MCAdditions)

+(CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)aDuration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGFloat)scaleFactor {    
    // Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    CGFloat startValue = beginsOnTop ? 0.0f : M_PI;
    CGFloat endValue = beginsOnTop ? -M_PI : 0.0f;
    flipAnimation.fromValue = [NSNumber numberWithDouble:startValue];
    flipAnimation.toValue = [NSNumber numberWithDouble:endValue];
    
    // Shrinking the view makes it seem to move away from us, for a more natural effect
    // Can also grow the view to make it move out of the screen
    CABasicAnimation *shrinkAnimation = nil;
    if ( scaleFactor != 1.0f ) {
        shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrinkAnimation.toValue = [NSNumber numberWithFloat:scaleFactor];
        
        // We only have to animate the shrink in one direction, then use autoreverse to "grow"
        shrinkAnimation.duration = aDuration * 0.5;
        shrinkAnimation.autoreverses = YES;
    }
    
    // Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];
    
    // As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = aDuration;
    
    // Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    
    return animationGroup;
}

@end


@implementation NSView (MCAdditions)

-(CALayer *)layerFromContents
{
    CALayer *newLayer = [CALayer layer];
    newLayer.bounds = NSRectToCGRect(self.bounds);
    NSBitmapImageRep *bitmapRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmapRep];
    newLayer.contents = (id)bitmapRep.CGImage;
    return newLayer;
}

@end


@implementation MCViewFlipController

@synthesize isFlipped;
@synthesize duration;

-(id)initWithHostView:(NSView *)newHostView frontView:(NSView *)newFrontView backView:(NSView *)newBackView
{
    if ( self = [super init] ) {
    	hostView = newHostView;
        frontView = newFrontView;
        backView = newBackView;
        duration = 0.75;
    }
    return self;
}

-(IBAction)flip:(id)sender
{
	if ( isFlipped ) {
        topView = backView;
        bottomView = frontView;
    }
    else {
        topView = frontView;
        bottomView = backView;
    }
    
	CAAnimation *topAnimation = [CAAnimation flipAnimationWithDuration:duration forLayerBeginningOnTop:YES scaleFactor:1.3f];
    CAAnimation *bottomAnimation = [CAAnimation flipAnimationWithDuration:duration forLayerBeginningOnTop:NO scaleFactor:1.3f];
    
    bottomView.frame = topView.frame;
    topLayer = [topView layerFromContents];
    bottomLayer = [bottomView layerFromContents];
    
    CGFloat zDistance = 1500.0f;
    CATransform3D perspective = CATransform3DIdentity; 
    perspective.m34 = -1. / zDistance;
    topLayer.transform = perspective;
    bottomLayer.transform = perspective;
    
    bottomLayer.frame = NSRectToCGRect(topView.frame);
    bottomLayer.doubleSided = NO;
    [hostView.layer addSublayer:bottomLayer];
    
    topLayer.doubleSided = NO;
    topLayer.frame = NSRectToCGRect(topView.frame);
    [hostView.layer addSublayer:topLayer];
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    [[topView retain] removeFromSuperview];
    [CATransaction commit];
    
    topAnimation.delegate = self;
    [CATransaction begin];
    [topLayer addAnimation:topAnimation forKey:@"flip"];
    [bottomLayer addAnimation:bottomAnimation forKey:@"flip"];
    [CATransaction commit];
}

-(void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
{
	isFlipped = !isFlipped;
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    [hostView addSubview:bottomView];
    [topLayer removeFromSuperlayer];
    [bottomLayer removeFromSuperlayer];
    topLayer = nil; bottomLayer = nil;
    [CATransaction commit];
}    

-(NSView *)visibleView 
{
    return (isFlipped ? backView : frontView);
}

@end
