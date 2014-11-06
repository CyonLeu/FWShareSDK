//
//  FWShareView.h
//  FWShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击取消按钮时index= -1，选择的分享项index=0, 1，2，3...
typedef void(^MenuActionHandler)(NSInteger index);

@interface FWShareView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *itemTitles;
@property (nonatomic, strong) NSMutableArray *itemImages;

@property (nonatomic) NSInteger itemCount;
@property (nonatomic, strong) void (^actionHandle)(NSInteger);

/**
 *  @brief  图标列数
 *   default is 4
 */
@property (nonatomic) NSUInteger numOfColumns;

/**
 *  @brief  每一项的大小（包含图标和标题） iconHeight = itemSize.Height - titleHeight
 *  default is (80, 80), default titleLabel height is 20px, so iconSize is (60, 60)
 *  You should supply UIImage size is （60，60），if retina screen (120，120）
 */
@property (nonatomic) CGSize itemSize;

/**
 *  @brief  titleLabel height; default is 20
 */
@property (nonatomic) NSInteger titleHeight;

/**
 *  @brief  title font :Default is [UIFont systemFontOfSize:12]
 */
@property (nonatomic, strong) UIFont *titleFont;


/**
 *  @brief  Description
 *
 *  @param handler handler description
 *
 *  @return return value description
 */

- (id)initWithTitle:(NSString *)title
         itemTitles:(NSArray *)itemTitles
             images:(NSArray *)images
    selectedHandler:(MenuActionHandler)handler;

- (void)setupItemTitles:(NSArray *)itemTitles
                 images:(NSArray *)images;


- (BOOL)addItemTitles:(NSArray *)itemTitles images:(NSArray *)images;
- (BOOL)addItemTitle:(NSString *)itemTitle image:(UIImage *)image;

//- (void)removeItemTitle:(NSString *)itemTitle image:(UIImage *)image;

- (void)showInview:(UIView *)parentView;
- (void)dismiss;

@end
