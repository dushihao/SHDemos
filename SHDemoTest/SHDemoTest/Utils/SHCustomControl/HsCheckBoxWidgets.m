//
//  HsCheckBoxWidgets.m
//  TZYJ_IPhone
//
//  Created by cheng zhang on 12-2-28.
//  Copyright (c) 2012年 hundsun. All rights reserved.
//

#import "HsCheckBoxWidgets.h"

#define CHECKBOXIMG           @"unselect"
#define CHECKBOXIMG_CLICK     @"selected"

@implementation HsCheckBoxWidgets

@synthesize isChecked = _isChecked;
@synthesize deletegate = _deletegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;		
		[self setImage:[UIImage imageNamed:CHECKBOXIMG] forState:UIControlStateNormal];
		[self addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.titleLabel.numberOfLines = 0;
        _isChecked = NO;
        _repeat = YES;
	}
    return self;
}

- (id)initWithFrame:(CGRect)frame onrepeatclick :(BOOL)repeat
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;		
		[self setImage:[UIImage imageNamed:CHECKBOXIMG] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
         
        _repeat = repeat;
        _isChecked = NO;
	}
    return self;
}

-(void)checkBoxClicked:(id)sender
{
	if(_isChecked)
    {
        if (_repeat) {
            _isChecked = NO;
            [self setImage:[UIImage imageNamed:CHECKBOXIMG] forState:UIControlStateNormal];
        }
	}
    else
    {
		self.isChecked = YES;
		[self setImage:[UIImage imageNamed:CHECKBOXIMG_CLICK] forState:UIControlStateNormal];
		
	}
  
    if (_deletegate && [_deletegate respondsToSelector:@selector(onCheckBoxClick:)]) {
        [_deletegate onCheckBoxClick:self];
    }
}

-(void)setIsChecked:(BOOL)isChecked
{   
	_isChecked = isChecked;
    
	if (_isChecked) {
		[self setImage:[UIImage imageNamed:CHECKBOXIMG_CLICK] forState:UIControlStateNormal];
		
	}
	else {
		[self setImage:[UIImage imageNamed:CHECKBOXIMG] forState:UIControlStateNormal];
	}
}


@end
