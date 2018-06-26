//
//  WVRTopTabViewPresenterImpl.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WVRTopTabViewDelegate <NSObject>

-(void)didSelectSegmentItem:(NSInteger)index;

-(void)didSelectRightItem;

@end

@interface WVRTopTabView : UIView

@property (nonatomic, weak) id<WVRTopTabViewDelegate> delegate;

-(void)updateSegmentSelectIndex:(NSInteger)index;

-(NSInteger)getSelectIndex;

-(void)updateWithTitles:(NSArray*)titles scrollView:(UIScrollView*)scrollView;

-(void)updateRightViewWith:(NSString*)normalImage pressImage:(NSString*)pressImage;

-(void)scrolling:(CGFloat)offsetX flag:(BOOL)bigFlag;


@end
