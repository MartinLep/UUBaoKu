//
//  UIImage+Stretch.m
//
//  Created by 李 家明 on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+uuMStretch.h"

@implementation UIImage (UUMStretch)

- (UIImage *)uum_stretchableImageByCenter
{
	CGFloat leftCapWidth = floorf(self.size.width / 2);
	if (leftCapWidth == self.size.width / 2)
	{
		leftCapWidth--;
	}
	
	CGFloat topCapHeight = floorf(self.size.height / 2);
	if (topCapHeight == self.size.height / 2)
	{
		topCapHeight--;
	}
	
	return [self stretchableImageWithLeftCapWidth:leftCapWidth 
									 topCapHeight:topCapHeight];
}

- (UIImage *)uum_stretchableImageByWidthCenter
{
	CGFloat leftCapWidth = floorf(self.size.width / 2);
	if (leftCapWidth == self.size.width / 2)
	{
		leftCapWidth--;
	}
	
	return [self stretchableImageWithLeftCapWidth:leftCapWidth 
									 topCapHeight:0];
}

- (NSInteger)uum_rightCapWidth
{
	return (NSInteger)self.size.width - (self.leftCapWidth + 1);
}


- (NSInteger)uum_bottomCapHeight
{
	return (NSInteger)self.size.height - (self.topCapHeight + 1);
}


@end
