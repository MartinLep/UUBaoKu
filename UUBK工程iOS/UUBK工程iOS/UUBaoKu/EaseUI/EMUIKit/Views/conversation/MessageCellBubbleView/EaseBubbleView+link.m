//
//  EaseBubbleView+link.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "EaseBubbleView+link.h"

@implementation EaseBubbleView (link)

- (void)_setupLinkBubbleMarginConstraints
{
    NSLayoutConstraint *titleLabMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.titleLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *linkLabMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.linkLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLab attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSLayoutConstraint *linkLabMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.linkLab attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    NSLayoutConstraint *titleLabMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLab attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    NSLayoutConstraint *titleLabMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.titleLab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *linkLabMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.linkLab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *linkLabMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.linkLab attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right- 50];
    NSLayoutConstraint *imageViewMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.image attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLab attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSLayoutConstraint *imageViewMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.image attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    NSLayoutConstraint *imageViewMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.image attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.linkLab attribute:NSLayoutAttributeRight multiplier:1.0 constant:5];
    NSLayoutConstraint *imageVIewMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.image attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    
    
    [self.marginConstraints removeAllObjects];
    [self.marginConstraints addObject:titleLabMarginTopConstraint];
    [self.marginConstraints addObject:linkLabMarginBottomConstraint];
    [self.marginConstraints addObject:titleLabMarginLeftConstraint];
    [self.marginConstraints addObject:titleLabMarginRightConstraint];
    [self.marginConstraints addObject:linkLabMarginTopConstraint];
    [self.marginConstraints addObject:linkLabMarginLeftConstraint];
    [self.marginConstraints addObject:linkLabMarginRightConstraint];
    [self.marginConstraints addObject:imageViewMarginTopConstraint];
    [self.marginConstraints addObject:imageViewMarginLeftConstraint];
    [self.marginConstraints addObject:imageVIewMarginRightConstraint];
    [self.marginConstraints addObject:imageViewMarginBottomConstraint];
    [self addConstraints:self.marginConstraints];
}


- (void)_setupLinkBubbleConstraints
{
    [self _setupLinkBubbleMarginConstraints];
}
#pragma mark - public

- (void)setupLinkBubbleView{
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.accessibilityIdentifier = @"title_label";
    self.titleLab.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.titleLab.numberOfLines = 2;
    [self.backgroundImageView addSubview:self.titleLab];
    
    self.linkLab = [[UILabel alloc]init];
    self.linkLab.accessibilityIdentifier = @"link_label";
    self.linkLab.translatesAutoresizingMaskIntoConstraints = NO;
    self.linkLab.backgroundColor = [UIColor clearColor];
    self.linkLab.numberOfLines = 2;
    [self.backgroundImageView addSubview:self.linkLab];
    self.image = [[UIImageView alloc]init];
    self.image.backgroundColor = [UIColor clearColor];
    self.image.contentMode = UIViewContentModeScaleAspectFit;
    self.image.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImageView addSubview:self.image];
    [self _setupLinkBubbleConstraints];
}

- (void)updateLinkMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupLinkBubbleMarginConstraints];
}
@end
