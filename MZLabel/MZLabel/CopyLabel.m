//
//  CopyLabel.m
//  JscriptEvaluate
//
//  Created by Pillian on 2016/12/15.
//  Copyright © 2016年 彭柯柱. All rights reserved.
//

#import "CopyLabel.h"


#define Default_Hilight_Color [UIColor lightGrayColor]
@implementation CopyLabel

- (instancetype)init {
  self = [super init];
  if (self) {
	[self addLongPressGesture];
  }
  return self;
}

- (void)addLongPressGesture {
  UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
  self.userInteractionEnabled = YES;
  [self addGestureRecognizer:ges];
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  NSArray *methodNameArr = @[@"copyWaybillId:"];
  if ([methodNameArr containsObject:NSStringFromSelector(action)]) {
	return YES;
  }
  return NO;
}

//implement copy paste est
- (void)copy:(id)sender {
  UIPasteboard *board = [UIPasteboard generalPasteboard];
  [board setString:self.text];
  [self removeHighLight];
}

- (void)longPress:(UILongPressGestureRecognizer *)tapGes {
  [self becomeFirstResponder];
  if (tapGes.state == UIGestureRecognizerStateBegan) {
	UIPasteboard *board = [UIPasteboard generalPasteboard];
	UIMenuController *menuVC = [UIMenuController sharedMenuController];
	[menuVC setTargetRect:self.frame inView:self];
	menuVC.menuItems = @[[[UIMenuItem alloc] initWithTitle:@"复制运单号" action:@selector(copyWaybillId:)]];
	[menuVC setMenuVisible:YES animated:YES];
	[board setString:self.text];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeHighLight) name:UIMenuControllerWillHideMenuNotification object:nil];
	self.hilightWhenFocus?[self highLight]:nil;
  }
}

- (void)copyWaybillId:(id)sender {
  UIPasteboard *board = [UIPasteboard generalPasteboard];
  [board setString:self.text];
  [self removeHighLight];
}

- (void)highLight {
  self.backgroundColor = self.hilightColor?:Default_Hilight_Color;
}

- (void)removeHighLight {
  self.backgroundColor = [UIColor clearColor];
}

@end
