//
//  FWShareData.h
//  FWShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ShareDataType {
    kShareDataTypeNone          = -1,
    kShareDataTypeText          = 0, //纯文本信息
    kShareDataTypeImage         = 1, //图片：可包含文本
    kShareDataTypeWebPage       = 2, //webpage,网页链接
    
    kShareDataTypeMusic         = 3, //分享音乐 暂不支持
    kShareDataTypeVideo         = 4, //分享视频 暂不支持
    
} ShareDataType;

@class FWBaseMediaObject;
@class FWImageObject;

/**
 一个消息结构由三部分组成：文字、图片和多媒体数据。三部分内容中至少有一项不为空，图片和多媒体数据不能共存。
 */

@interface FWShareData : NSObject

/**
 *  @brief  数据类型：纯文本，图片，网页链接等
 */
@property (nonatomic) ShareDataType dataType;

/**
 消息的文本内容
 
 @warning 长度小于140个汉字
 */
@property (nonatomic, retain) NSString *text;

/**
 *  @brief  是否是纯文本信息
 */
@property (nonatomic) BOOL bText;

/**
 消息的图片内容
 
 @see WBImageObject
 */
//@property (nonatomic, retain) FWImageObject *imageObject;

/**
 消息的多媒体内容
 
 @see WBBaseMediaObject
 */
@property (nonatomic, retain) FWBaseMediaObject *mediaObject;

/**
 返回一个 FWShareData 对象
 
 @return 返回一个*自动释放的*WBMessageObject对象
 */
+ (id)message;

@end



#pragma mark - Message Media Objects

/**
 消息中包含的多媒体数据对象基类
 */
@interface FWBaseMediaObject : NSObject

/**
 对象唯一ID，用于唯一标识一个多媒体内容
 
 当第三方应用分享多媒体内容到微博时，应该将此参数设置为被分享的内容在自己的系统中的唯一标识
 @warning 不能为空，长度小于255
 */
@property (nonatomic, retain) NSString *objectID;

/**
 多媒体内容标题
 @warning 不能为空且长度小于1k
 */
@property (nonatomic, retain) NSString *title;

/**
 多媒体内容描述
 @warning 长度小于1k
 */
@property (nonatomic, retain) NSString *desc;

/**
 多媒体内容缩略图
 @warning 大小小于32k
 */
@property (nonatomic, retain) NSData *thumbnailData;

/**
 点击多媒体内容之后呼起第三方应用特定页面的scheme
 @warning 长度小于255
 */
//@property (nonatomic, retain) NSString *scheme;

/**
 返回一个 FWBaseMediaObject 对象
 
 @return 返回一个*自动释放的*FWBaseMediaObject对象
 */
+ (id)object;

@end


#pragma mark - Message WebPage Objects

/**
 消息中包含的网页数据对象
 */
@interface FWWebpageObject : FWBaseMediaObject

/**
 网页的url地址
 
 @warning 不能为空且长度不能超过255
 */
@property (nonatomic, retain) NSString *webpageUrl;

@end


#pragma mark - ImageObject
/**
 消息中包含的图片数据对象
 */
@interface FWImageObject : FWBaseMediaObject

/**
 图片真实数据内容
 
 @warning 大小不能超过10M
 */
@property (nonatomic, retain) NSData *imageData;

/**
 返回一个 WBImageObject 对象
 
 @return 返回一个*自动释放的*FWImageObject对象
 */
+ (id)object;

/**
 返回一个 UIImage 对象
 
 @return 返回一个*自动释放的*UIImage对象
 */
- (UIImage *)image;

@end

