//
//  Utils.h
//  PlayMusicTool
//
//  Created by 陈 宏 on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//typedef enum {
//    NONE=0, //没有网络
//    IS3G, //3G网络
//    ISWIFI,  //
//    ERROR //顺序循环
//} NetWorkType;
//
//
//typedef enum {
//    WeekType=0,
//    MonthType,
//}TimeStateType;

@interface Utils : NSObject

+(Utils *)sharesInstance;

+(NSString *)getDefaultFilePathString:(NSString *)fileName;

+(NSString *)getDocumentFilePathString:(NSString *)fileName;

+(NSString *)getLibraryFilePathString:(NSString *)fileName;

+(NSString *)getCacheFilePathString:(NSString *)fileName;

+(NSString *)getCachePathString;

+(NSString *)getTempPathString;

+(NSString *)getTempFilePathString:(NSString *)fileName;

+(NSString *)getResourceFilePathString:(NSString *) resourceName ofType:(NSString*)typeName;

#pragma mark -- ///删除目录下所有文件
+(void)removeFile:(NSString *)folderPath;

#pragma mark -- //获得存储文件的路径
+ (NSString *)getSaveFilePath:(NSString *)fileName;

#pragma mark -- ///保存文件
+ (void)saveFilePath:(NSString *)filepath fileData:(id)info andEncodeObjectKey:(NSString *)key;
#pragma mark -- ///读取文件
+ (NSData *)loadDataFromFile:(NSString *)fileName anddencodeObjectKey:(NSString *)key;
#pragma mark -- ///获得配置信息
+ (NSString *)loadClientVersionKey:(NSString *)key;

#pragma mark -- //文件是否存在在某路径下
+ (BOOL)isHaveFileAtPath:(NSString *)path;

#pragma mark -- //判断文件夹是否存在
+(BOOL)judgeFileExist:(NSString * )fileName;

+(long long) fileSizeAtPath:(NSString*) filePath;
+(long long)folderSize:(const char *)folderPath ;

+(NSInteger)weiBoCountWord:(NSString*)s;
#pragma mark -- //去掉前后空格
+ (NSString *) getDisposalStr:(NSString *)s;
+ (NSString *)md5:(NSData *)data;

#pragma mark -- //判断密码8-16位且同时包含数字和字母
+(BOOL)judgePassWordLegal:(NSString *)pass;
////判断是否是邮箱
//+(BOOL)isEmail:(NSString *)input;
#pragma mark -- //判断是否是手机号码
+(BOOL)isMobileNum:(NSString *)input;
#pragma mark -- //判断是否是身份证号码
+(BOOL)isIdentityCardNo:(NSString *)input;
#pragma mark -- //判断是否是邮编
+(BOOL)isYouBian:(NSString*)input;
#pragma mark -- /// 判断是不是数字
+(BOOL)isNumber:(NSString *)input;
#pragma mark-- ///密码 长度6-18位，只能包含字符、数字和下划线
+(BOOL)isPassWord:(NSString *)input;
#pragma mark--//判断是否是银行卡号
+(BOOL)isBankCardNumber:(NSString *)input;

#pragma mark -- ///  把 毫秒 转为时间 yyyy-mm-dd HH:mm:ss
+ (NSString *)millisecondConvertedToDay:(unsigned long long )time;

+ (NSString *)millisecondToDateByFormatter:(unsigned long long)time formattter:(NSString * ) format;

#pragma mark -- ///  把 秒 转为时间 yyyy-mm-dd HH:mm:ss
+ (NSString *)secondToDateByFormatter:(unsigned long long)time formattter:(NSString * ) format;

#pragma mark -- ///把字符串时间转为指定的格式
+ (NSString *)translateDateString:(NSString *)translateDateString format:(NSString *)format toFormat:(NSString *)tofarmt;
#pragma mark -- ///根据指定日期返回周几 从周日开始，周日为0
+ (NSString *)getWeekdayFromDate:(NSString *)dateStr formatter:(NSString *)matter;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

#pragma mark -- //修改图片的size
+(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size;

+(NSString *)ToHex:(long long int)tmpid;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

#pragma mark -- 得到日期开始和结束时间
+(NSArray *)getStartDayAndEndDay:(TimeStateType)type;

#pragma mark -- 时间戳转时间
+ (NSString *)getTimeByTimeString:(NSString *)timeString;
/**
 * @brief 计算字符串的高度.
 *
 * @param  fontSize  字体型号.
 * @param  width  视图的宽度.
 *
 */
#pragma mark -- 计算字符串的高度.
+ (CGFloat)heightForString:(NSString *)string fontSize:(float)fontSize andWidth:(float)width;

/**
 * @brief 计算字符串的长度.
 *
 * @param  fontSize  字体型号.
 * @param  height  视图的高度.
 *
 */
#pragma mark -- 计算字符串的长度.
+ (CGFloat)widthForString:(NSString *)string fontSize:(float)fontSize andHeight:(float)height;

#pragma mark -- 将字符串转换为按照指定间隔分隔的字符串
+ (NSString *)translateToCardString:(NSString *)string interval:(NSInteger)interval;

#pragma mark -- 设置一段字符串显示两种颜色
+ (NSAttributedString *)getDifferentColorString:(NSString *)totalStr oneStr:(NSString *)oneStr color:(UIColor *)oneColor otherStr:(NSString *)otherStr ortherColor:(UIColor *)otherColor;

#pragma mark -- 设置一段字符串显示两种字体
+ (NSAttributedString *)getDifferentFontString:(NSString *)totalStr oneStr:(NSString *)oneStr font:(NSInteger)oneFont otherStr:(NSString *)otherStr ortherFont:(NSInteger)otherFont;

#pragma mark -- 设置一段字符串显示两种加横线
+(NSAttributedString *)getDifferentUnderLineString:(NSString *)totalStr andRange:(NSRange)myRange andLineColor:(UIColor *)lineColor;
                                      //andLineColor:(UIColor *)lineColor;

#pragma mark -- 设置一段字符，显示不同的字体颜色
/*
*info: @[@[string,color,font],@[string,color,font],@[string,color,font]]
 *totalStr:完整的字符串
 */
+ (NSAttributedString *)getDifferentFontStringWithTotalString:(NSString *)totalStr andInfo:(NSArray *)info;

+ (NSString *)getBankName:(NSString *)bankCode;
+ (NSString *)getBankLogo:(NSString *)bankCode;
+ (NSString *)getBankCardType:(NSString *)bankCardtype;

#pragma mark -- 将多个字符串的结合，按照指定的间隔符进行分割，拼接成一个字符串
+ (NSString *)stringByStepetorStr:(NSString *)str andInfo:(NSString *)info,...NS_REQUIRES_NIL_TERMINATION;
+ (NSMutableAttributedString *)getLineSpaceString:(NSString *)string lineSpace:(CGFloat)space alignment:(NSTextAlignment)alignment;

#pragma mark -- 返回一条线
+ (UILabel *)lineLabelWithFrame:(CGRect)frame color:(UIColor *)color;

#pragma mark -- UILabel设置文本颜色
+ (NSMutableAttributedString *)setTextColor:(UIColor *)textColor  withRange:(NSRange)textRange withString:(NSString *)string;

#pragma mark -- 判断数据是否为空或空对象
+ (BOOL)dataIsNull:(id)string;

#pragma mark -- 登录密码md5
+ (NSString *)getMd5Password:(NSString *)password;

#pragma mark -- 根据UIEvent 获取indexpath
+ (NSIndexPath*)getIndexPathBy:(UIEvent*)event inView:(UITableView*)view;

#pragma mark -- 打电话
+(void)callPeopleBy:(NSString*)call view:(UIView*)view;

#pragma mark -- 获取手机唯一ID
+ (NSString *)getDeviceIdentify;

#pragma mark -- /**获取手机名称、系统名称*/
+(NSMutableArray *)getPhoneInfo;

#pragma mark -- 获取网络图片
+(void)setImgUrl:(NSString *)imgUrl toImgView:(UIImageView *)imgView;

#pragma mark -- 获取按钮的网络图片
+(void)setBtnImgUrl:(NSString *)imgUrl toBtnImgView:(UIButton *)Btn;

#pragma mark - 剪贴图片
+(UIImage *)changeImg:(UIImage*)image;

#pragma mark - url转码解码
+ (NSString*)URLDecodedString:(NSString *)str;
+ (NSString *)URLEncodedString:(NSString *)str;

#pragma mark 过滤 符号
+(NSString*)changeStr:(NSString *)str;


#pragma mark---textfield输入框字数的限制
+(void)mTextFieldDidChangeLimitLetter:(UITextField *)textField andLimitLength:(NSInteger)mLengh;
#pragma mark---TextView 输入框字数的限制
+(void)mTextViewDicChangeRangeLimit:(UITextView *)textView andLimitLenth:(NSInteger)mLengh;
#pragma mark---修改textField placeholder的颜色
+(void)changeTextFieldPlaceholderColor:(UITextField *)textField;

#pragma mark---字符串的处理
+(NSString *)getChangeToFloatType:(NSString *)mStr;

#pragma mark--输入框只能输入一位小数
+(BOOL)isInputOnePoint:(UITextField *)textField;

#pragma mark--/** 判断当前输入的是不是数字*/
+ (BOOL)isNumberInTextField:(UITextField *)startPriceTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
