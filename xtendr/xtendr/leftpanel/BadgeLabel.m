//
//  BadgeLabel.m
//  Badge
//
//  Created by Yonat Sharon on 11/1/11.
//

#import "BadgeLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface BadgeLabel () {
	CAGradientLayer *gloss;
}
@end

@implementation BadgeLabel

#pragma mark - Style Properties

@synthesize minWidth;

- (void)setHasBorder:(BOOL)hasBorder
{
    [self layer].borderWidth = hasBorder ? 2.0f : 0.0f;
}

- (BOOL)hasBorder
{
    return [self layer].borderWidth > 0;
}

- (void)setHasShadow:(BOOL)hasShadow
{
    CALayer *layer = [self layer];
    if (hasShadow) {
        layer.shadowOpacity = 0.5;
        layer.shadowColor   = [UIColor blackColor].CGColor;
        layer.shadowOffset  = CGSizeMake(0, -1);
        layer.shadowRadius  = 1;
        layer.masksToBounds = NO;
    }
    else {
        layer.masksToBounds = YES;
    }
    
    layer.shouldRasterize = YES;
}

- (BOOL)hasShadow
{
    return [self layer].shadowOpacity && ![self layer].masksToBounds;
}

- (void)setHasGloss:(BOOL)hasGloss
{
    if (hasGloss) {
        if (gloss == nil) {
            CALayer *layer = [self layer];
            gloss = [[CAGradientLayer alloc] init];
            gloss.frame = layer.bounds;
            gloss.cornerRadius = layer.cornerRadius;
            CGColorRef white = [UIColor whiteColor].CGColor;
            CGColorRef clear = CGColorCreateCopyWithAlpha(white, 0);
            gloss.colors = [NSArray arrayWithObjects:(__bridge id)white, (__bridge id)clear, nil];
            CFRelease(clear);
            gloss.startPoint = CGPointMake(0.5, -0.15);
            gloss.endPoint = CGPointMake(0.5, 0.65);
            [layer addSublayer:gloss];
        }
        else {
            gloss.hidden = NO;
        }
    }
    else {
        if (gloss) gloss.hidden = YES;
    }
}

- (BOOL)hasGloss
{
    return gloss && !gloss.hidden;
}

- (void)setStyle:(BadgeLabelStyle)style
{
    switch (style) {
        case BadgeLabelStyleAppIcon:
            self.backgroundColor = [UIColor colorWithRed:214.0f/255 green:0 blue:0 alpha:1];
            self.hasBorder = YES;
            self.hasShadow = YES;
            self.hasGloss = YES;
            self.minWidth = 0.0f;
            break;
            
        case BadgeLabelStyleMail:
            self.backgroundColor = [UIColor colorWithRed:142.0f/255 green:156.0f/255 blue:183.0f/255 alpha:1.0];
            self.hasBorder = NO;
            self.hasShadow = YES;
            self.hasGloss = NO;
            self.minWidth = 40.0f;
            break;
            
    }
}

#pragma mark - Initialization

- (void)initBadge
{
    CALayer *layer = [self layer];
    super.backgroundColor = [UIColor clearColor];
    layer.cornerRadius = self.bounds.size.height / 2;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.shouldRasterize = YES;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) 
    {
		[self initBadge];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = UITextAlignmentCenter;
        self.backgroundColor = [UIColor blueColor];
	}

	return self;
}

- (void)awakeFromNib
{
    [self initBadge];
}

#pragma mark - UILabel Overrides

- (void)setBackgroundColor:(UIColor *)color
{
    if ([color isEqual:[UIColor clearColor]]) return; // to avoid disappearing in selected/deselected UITableViewCell
    super.backgroundColor = [UIColor clearColor];
	self.layer.backgroundColor = color.CGColor;
}

- (UIColor *)backgroundColor
{
    return [UIColor colorWithCGColor:self.layer.backgroundColor];
}

-(void)setFrame:(CGRect)frame 
{
    [super setFrame:frame];
    
    CGFloat border = self.layer.borderWidth;
    CGRect newFrame = self.frame;
    
    newFrame.size.height += 2*border;
    newFrame.size.width += 2*border;
    
    gloss.cornerRadius = self.layer.cornerRadius = self.bounds.size.height / 2;
	gloss.frame = self.layer.bounds;
}

@end
