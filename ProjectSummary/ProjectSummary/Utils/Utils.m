//
//  Utils.m     工具类
//  PlayMusicTool
//
//  Created by 陈 宏 on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import <dirent.h>
#import <sys/stat.h>
#import "NSString+MD5.h"


//#import "config.h"

#define MAX_STARWORDS_LENGTH 15
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

//const NSString* REG_EMAIL = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
//const NSString* REG_MOBILE = @"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$";
//const NSString* REG_PHONE = @"^(([0\\+]\\d{2,3}-?)?(0\\d{2,3})-?)?(\\d{7,8})";

@implementation Utils

static Utils * _instance;

+(Utils *)sharesInstance
{
    @synchronized(self)
    {
        if (_instance==nil) {
            _instance=[[super allocWithZone:NULL] init];
        }
    }
    return _instance;
}

+(NSString *)getDefaultFilePathString:(NSString *)fileName;
{
    NSString *defaultPathString = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    return defaultPathString;
}

+(NSString *)getDocumentFilePathString:(NSString *)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(NSString *)getLibraryFilePathString:(NSString *)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return [libraryDirectory stringByAppendingPathComponent:fileName];
    
}

+(NSString *)getCacheFilePathString:(NSString *)fileName;
{
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
    NSString *cachePath = [cache objectAtIndex:0] ;
    return [cachePath stringByAppendingPathComponent:fileName];
    
}
//仅仅得到cache的路径
+(NSString *)getCachePathString;
{
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
    NSString *cachePath = [cache objectAtIndex:0] ;
    return cachePath;
}

+(NSString *)getTempPathString {
    return NSTemporaryDirectory();
}

+(NSString *)getTempFilePathString:(NSString *)fileName;
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
}

+(NSString *)getResourceFilePathString:(NSString *) resourceName ofType:(NSString*)typeName;
{
    return [[NSBundle mainBundle] pathForResource: resourceName ofType: typeName];
}

+(void)removeFile:(NSString *)folderPath {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:folderPath error:NULL];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [enumerator nextObject])) {
        [fileManager removeItemAtPath:[folderPath stringByAppendingPathComponent:filename] error:NULL];
    }
}


+ (NSString *)getSaveFilePath:(NSString *)fileName
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (void)saveFilePath:(NSString *)filepath fileData:(id)info andEncodeObjectKey:(NSString *)key {

    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver= [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:info forKey:key];
    [archiver finishEncoding];
    [data writeToFile:filepath atomically:YES];
}

+ (NSData *)loadDataFromFile:(NSString *)fileName anddencodeObjectKey:(NSString *)key {

    NSString *filePath = [Utils getSaveFilePath:fileName];

    if ([Utils isHaveFileAtPath:filePath]) {
        
        NSData *data1 = [NSData dataWithContentsOfFile:[Utils getDocumentFilePathString:fileName]];
        NSKeyedUnarchiver *archiver= [[NSKeyedUnarchiver alloc] initForReadingWithData:data1];
        id info = [archiver decodeObjectForKey:key];
        [archiver finishDecoding];
        return info;
    }
    return nil;
}

+ (NSString *)loadClientVersionKey:(NSString *)key {
    
    NSDictionary *configCenterDic = (NSDictionary *)[Utils loadDataFromFile:@"configCenter.json" anddencodeObjectKey:@"configCenter"];
    NSPredicate *bobPredicate = [NSPredicate predicateWithFormat:key];
    NSArray *configcenterArray = [[configCenterDic objectForKey:@"configCenterList"] filteredArrayUsingPredicate:bobPredicate];
    NSDictionary *legalServiceDic = [NSDictionary dictionaryWithDictionary:[configcenterArray firstObject]];
    return [legalServiceDic objectForKey:@"value"];
}

+ (BOOL)isHaveFileAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

//判断文件夹是否存在
+(BOOL)judgeFileExist:(NSString * )fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * filePath=[documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager * fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

//去掉前后空格
+ (NSString *) getDisposalStr:(NSString *)s;
{
    if (![@"" isEqualToString:s]) {
        return [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return @"";
}

+(NSInteger)weiBoCountWord:(NSString*)s {
    NSUInteger i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;            
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

//获取数据MD5值
+ (NSString *)md5:(NSData *)data
{
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5,[data bytes],[data length]);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1], 
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

////判断是否是有效的email
//+(BOOL)isEmail:(NSString *)input{
//    return [input isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
//
//}

//判断密码8-16位且同时包含数字和字母
+(BOOL)judgePassWordLegal:(NSString *)pass{
 
//    ^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$
//    
//    分开来注释一下：
//    ^ 匹配一行的开头位置
//    (?![0-9]+$) 预测该位置后面不全是数字
//    (?![a-zA-Z]+$) 预测该位置后面不全是字母
//    [0-9A-Za-z] {8,16} 由8-16位数字或这字母组成
//    $ 匹配行结尾位置
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符(?![0-9]+$)(?![a-zA-Z]+$)
        NSString * regex = @"^[0-9A-Za-z]{6,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}

+(BOOL)isMobileNum:(NSString *)input{
    //普通手机号码
    NSString *emailRegex = @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
    //座机
    NSString *phone=@"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSPredicate *phoneRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    if (([emailTest evaluateWithObject:input]==YES)||([phoneRegex evaluateWithObject:input]==YES)) {
        return YES;
    }else{
        return NO;
    }


//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
//    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
//    NSString * CT = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
//    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
//    
//    
//    
//    if (([regextestcm evaluateWithObject:input] == YES)
//        
//        || ([regextestct evaluateWithObject:input] == YES)
//        
//        || ([regextestcu evaluateWithObject:input] == YES)
//        
//        || ([regextestphs evaluateWithObject:input] == YES))
//        
//    {
//        
//        return YES;
//        
//    }
//    
//    else
//        
//    {
//        
//        return NO;
//        
//    }
////    if ([input length] == 0) {
//
//        return NO;
//        
//    }
//    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,3,5-9]))\\d{8}$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch = [pred evaluateWithObject:input];
//    if (!isMatch) {
//        return NO;
//    }
//    return YES;
}

+(BOOL)isIdentityCardNo:(NSString *)input {
    NSString *emailRegex = @"\\d{15}|(\\d{17}([0-9]|X|x)$)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];
}

#pragma mark--//判断是否是银行卡号
+(BOOL)isBankCardNumber:(NSString *)input{
    NSString *emailRegex = @"^[0-9]{16,19}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];
}

+(BOOL)isYouBian:(NSString *)input
{
    
    NSString *emailRegex = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];
}
+(BOOL)isNumber:(NSString *)input {
    NSString *emailRegex = @"[0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];
}
#pragma mark-- ///密码 长度6-18位，只能包含字符、数字和下划线
+(BOOL)isPassWord:(NSString *)input{
    NSString *emailRegex = @"^\\w{6,18}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];

}


+ (NSString *)millisecondConvertedToDay:(unsigned long long )time {
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)millisecondToDateByFormatter:(unsigned long long)time formattter:(NSString * ) format {
    
    if (format==nil||[format isEqualToString:@""]) {
        format=@"yyyy-MM-dd HH:mm:ss";
    }
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)secondToDateByFormatter:(unsigned long long)time formattter:(NSString * ) format {
    if (format==nil||[format isEqualToString:@""]) {
        format=@"yyyy-MM-dd HH:mm:ss";
    }
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)translateDateString:(NSString *)translateDateString format:(NSString *)format toFormat:(NSString *)tofarmt {
    if (translateDateString==nil || format==nil || tofarmt == nil) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *translateDate = [dateFormatter dateFromString:translateDateString];
    
    NSDateFormatter *translateDateFormatter = [[NSDateFormatter alloc] init];
    [translateDateFormatter setDateFormat:tofarmt];
    NSString *string = [translateDateFormatter stringFromDate:translateDate];
    
    return string;
}
+ (NSString *)getTimeByTimeString:(NSString *)timeString {
    timeString = [NSString stringWithFormat:@"%@",timeString];
    if (timeString.length>0) {
        timeString = [timeString substringWithRange:NSMakeRange(0,timeString.length-3)];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setTimeZone:timeZone];
        NSTimeInterval timeS=[timeString doubleValue];
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeS];
        NSString *timestr = [formatter stringFromDate:detaildate];
        return timestr;
    }else{
        return @"";
    }
}
+ (NSString *)getWeekdayFromDate:(NSString *)dateStr formatter:(NSString *)matter {

    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
   
    NSInteger unitFlags = NSCalendarUnitYear |
   
                             NSCalendarUnitMonth |
    
                            NSCalendarUnitDay |
   
                            NSCalendarUnitWeekday |
   
                            NSCalendarUnitHour |
 
                          NSCalendarUnitMinute |
  
                            NSCalendarUnitSecond;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:matter];
    NSDate *date = [formatter dateFromString:dateStr];
   
    if (date == nil) {
        return @"";
    }
    components = [calendar components:unitFlags fromDate:date];
 
    NSUInteger weekday = [components weekday];
    
    switch (weekday) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
    return @"";
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


+(NSString *)ToHex:(long long int)tmpid
{
    //    NSString *endtmp=@"";
    NSString *nLetterValue;
    //    NSString *nStrat;
    NSString *str =@"";
    //    tmpid = 13621631651;
    long long int ttmpig;
    
    
    
    for (int i = 0; i<9; i++) {
        
        
        ttmpig=tmpid%16;
        
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    
    //        } while (tmpid == 0);
    //
    return str;
}


//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//得到日期开始和结束时间
+(NSArray *)getStartDayAndEndDay:(TimeStateType)type{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday|NSCalendarUnitMonth|kCFCalendarUnitYear) fromDate:today];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
    if (type==WeekType) {
        NSInteger weekday = [dayComponents weekday];
        NSInteger week = [dayComponents week];
        NSLog(@"week :%ld",(long)week);
        NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-weekday*60*60*24];
        NSString *startString = [formatter stringFromDate:startDate];
        
        for(int i = 1;i<5;i++){
            NSDate *endDate = [NSDate dateWithTimeInterval:-(7*i*60*60*24) sinceDate:startDate];
            NSString *endString = [formatter stringFromDate:endDate];
            startString = [startString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            endString = [endString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            [temp addObject:[NSString stringWithFormat:@"%@-%@",endString,startString]];
            startString = endString;
            startDate = endDate;
        }
    }else if(type==MonthType){
        NSInteger month  =  [dayComponents month];
        NSInteger year= [dayComponents year];
        for (int i=1; i<5; i++) {
            if (month==1) {
                year--;
            }
            month = month==1?12:month-1;
            
            dayComponents.day = 1;
            dayComponents.year=year;
            dayComponents.month = month;
            NSRange range = [gregorian rangeOfUnit:NSCalendarUnitDay
                                            inUnit:NSCalendarUnitMonth
                                           forDate:[gregorian dateFromComponents:dayComponents]];
            NSDate *firstDate = [gregorian dateFromComponents:dayComponents];
            [dayComponents setDay:range.length];
            NSDate *lastDate = [gregorian dateFromComponents:dayComponents];
            NSString *startString = [formatter stringFromDate:firstDate];
            NSString *endString = [formatter stringFromDate:lastDate];
            startString = [startString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            endString = [endString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            [temp addObject:[NSString stringWithFormat:@"%@-%@",startString,endString]];
        }
        
        
    }

return temp;
}


+(long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


//获取文件夹大小
+(long long)folderSize:(const char *)folderPath {
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) {
        return 0;
    }
    struct dirent* child;
    while ((child = readdir(dir)) != NULL) {
        if (child->d_type == DT_DIR
            && (child->d_name[0] == '.' && child->d_name[1] == 0)) {
            continue;
        }
        
        if (child->d_type == DT_DIR
            && (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0)) {
            continue;
        }
        
        NSUInteger folderPathLength = strlen(folderPath);
        char childPath[1024];
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength - 1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        
        stpcpy(childPath + folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){
            folderSize += [self folderSize:childPath];
            struct stat st;
            if (lstat(childPath, &st) == 0) {
                folderSize += st.st_size;
            }
        } else if (child->d_type == DT_REG || child->d_type == DT_LNK){
            struct stat st;
            if (lstat(childPath, &st) == 0) {
                folderSize += st.st_size;
            }
        }
    }
    
    return folderSize;
}


// 计算字符串的高度
+ (CGFloat)heightForString:(NSString *)string fontSize:(float)fontSize andWidth:(float)width
{
    if (string==nil) {
        return 0;
    }
    if (IOS7) {
        if ((NSNull *)string == [NSNull null]) {
            return 0;
        }
        if (string!=nil && string.length>1) {
            UIFont * tfont = [UIFont systemFontOfSize:fontSize];
            CGSize size = CGSizeMake(width,CGFLOAT_MAX);
            NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
            CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
            return actualsize.height;
        }
        return 0;

    }
    else {
        if (string!=nil && string.length>1) {

            CGSize sizeToFit = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
            return sizeToFit.height;
        }
        return 0;
    }
    
}
 // 计算字符串长度
+ (CGFloat)widthForString:(NSString *)string fontSize:(float)fontSize andHeight:(float)height
{
    if (string==nil) {
        return 0;
    }
    if (IOS7) {
        UIFont * tfont = [UIFont systemFontOfSize:fontSize];
        CGSize size = CGSizeMake(CGFLOAT_MAX,height);
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
        CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        return actualsize.width;
    }
    else {

        CGSize sizeToFit = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
        return sizeToFit.width;
    }
}

+ (NSString *)translateToCardString:(NSString *)string interval:(NSInteger)interval
{
    if (!string) {
        return @"";
    }
    NSMutableString *translateStr = [NSMutableString stringWithString:string];
    
    NSInteger tempNum = 0;
    for (int i = 0; i < string.length; i++) {
        
        if (i%interval==0 && i>0) {
            ///插入空格
            [translateStr insertString:@" " atIndex:i+tempNum];
            tempNum++;
        }
    }
    return translateStr;
}

+ (NSAttributedString *)getDifferentColorString:(NSString *)totalStr oneStr:(NSString *)oneStr color:(UIColor *)oneColor otherStr:(NSString *)otherStr ortherColor:(UIColor *)otherColor {

    NSMutableAttributedString *registerStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    if (oneStr) {
        NSRange range1 = NSMakeRange(0, oneStr.length);
        [registerStr addAttribute:NSForegroundColorAttributeName value:oneColor range:range1];
    }
    if (otherStr) {
        NSRange range2 = NSMakeRange(oneStr.length, otherStr.length);
        [registerStr addAttribute:NSForegroundColorAttributeName value:oneColor range:range2];
        //[registerStr setAttributes:@{NSForegroundColorAttributeName:otherColor,
//                                     NSFontAttributeName:[UIFont systemFontOfSize:10.0]}
//                             range:range2];
    }

    return registerStr;
}

+ (NSAttributedString *)getDifferentFontString:(NSString *)totalStr oneStr:(NSString *)oneStr font:(NSInteger)oneFont otherStr:(NSString *)otherStr ortherFont:(NSInteger)otherFont {
    NSMutableAttributedString *registerStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    if (oneStr) {
        NSRange range1 = NSMakeRange(0, oneStr.length);
        [registerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:oneFont] range:range1];
    }
    if (otherStr) {
        NSRange range2 = NSMakeRange(oneStr.length, otherStr.length);
        [registerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:otherFont] range:range2];
    }
    return registerStr;
}

//设置一段字符串显示两种加横线
+(NSAttributedString *)getDifferentUnderLineString:(NSString *)totalStr andRange:(NSRange)myRange andLineColor:(UIColor *)lineColor{
     NSMutableAttributedString *registerStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    //[registerStr setAttributes:@{NSForegroundColorAttributeName:otherColor,
    //                                     NSFontAttributeName:[UIFont systemFontOfSize:10.0]}
    //                             range:range2];
    //
//       [rightLineAttri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, _rightOldPrice.text.length)];
    [registerStr setAttributes:@{NSForegroundColorAttributeName:lineColor,
                                 NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) } range:myRange];
    return registerStr;
}

+ (NSAttributedString *)getDifferentFontStringWithTotalString:(NSString *)totalStr andInfo:(NSArray *)info {

    NSMutableAttributedString *registerStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    @try {
        CGFloat tempLength = 0;

        for (int i =0; i < info.count; i++) {
            NSArray *tempArray = [info objectAtIndex:i];
            NSString *str = [tempArray firstObject];
            UIColor *color = [tempArray objectAtIndex:1];
            UIFont *font = [tempArray lastObject];
            
            NSRange range = NSMakeRange(tempLength, str.length);
            [registerStr setAttributes:@{NSForegroundColorAttributeName:color,
                                         NSFontAttributeName:font}
                                 range:range];
            
            tempLength+=str.length;
        }
    }
    @catch (NSException *exception) {
        ///
    }
    @finally {
        ///
    }

    
    return registerStr;
}

+ (NSMutableAttributedString *)getLineSpaceString:(NSString *)string lineSpace:(CGFloat)space alignment:(NSTextAlignment)alignment {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];//调整行间距
    paragraphStyle.alignment = alignment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
}

+ (NSString *)getBankName:(NSString *)bankCode {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BankLogoList" ofType:@"plist"];
    NSMutableDictionary *bankDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *bankInfo = [bankDic objectForKey:bankCode];
    
    if (bankInfo==nil) {
        return @"";
    }
    return [bankInfo objectForKey:@"name"];
    
}

+ (NSString *)getBankLogo:(NSString *)bankCode {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BankLogoList" ofType:@"plist"];
    NSMutableDictionary *bankDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *bankInfo = [bankDic objectForKey:bankCode];
    
    if (bankInfo==nil) {
        return @"";
    }
    return [bankInfo objectForKey:@"logo"];
    
}

+ (NSString *)getBankCardType:(NSString *)bankCardtype {
    
    NSDictionary *bankCardTypeDic = @{@"00": @"未知",
                          @"01": @"借记账户",
                          @"02": @"贷记账户",
                          @"03": @"准贷记账户",
                          @"04": @"借贷合一账户",
                          @"05": @"预付费账户",
                          @"06": @"半开放预付费账户"};
    NSString *temp = [bankCardTypeDic objectForKey:bankCardtype];
    return temp==nil?@"":temp;
}

+ (NSString *)stringByInfoArray:(NSArray *)array stepetorStr:(NSString *)str {
    
    NSString *tempStr = [NSString string];
    for (int i = 0; i < array.count; i++) {
        NSString *string = array[i];
        if (string&&string.length>0) {
            if (i!=0) {
                tempStr = [tempStr stringByAppendingString:str];
            }
            tempStr = [tempStr stringByAppendingString:string];
        }
    }
    return tempStr;
}

+ (NSString *)stringByStepetorStr:(NSString *)str andInfo:(NSString *)info, ... {
    
    NSString *tempStr = [NSString string];

    
    va_list args;
    va_start(args, info);

    NSUInteger i = 0;
    NSString *otherString;
    if (info&&info.length>0) {
        tempStr = [tempStr stringByAppendingString:info];
        i = 1;
    }
    while ((otherString = va_arg(args, NSString *)))
    {
        //依次取得所有参数
        if (otherString&&otherString.length>0) {
            if (i!=0) {
                tempStr = [tempStr stringByAppendingString:str];
            }
            tempStr = [tempStr stringByAppendingString:otherString];
            i++;

        }
    }

    va_end(args);
    
    return tempStr;
}

+ (UILabel *)lineLabelWithFrame:(CGRect)frame color:(UIColor *)color {
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = color;
    lineLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0.5);
    
    return lineLabel;
}

+ (NSMutableAttributedString *)setTextColor:(UIColor *)textColor  withRange:(NSRange)textRange withString:(NSString *)string
{
    NSMutableAttributedString *mutableString =[[NSMutableAttributedString alloc] initWithString:string];
    [mutableString addAttribute:NSForegroundColorAttributeName value:textColor range:textRange];
    return mutableString;
}

// 判断数据是否为空或空对象
+ (BOOL)dataIsNull:(id)string {
    if ([string isEqual:[NSNull null]] || string == nil) {
        return YES;
    }
    return NO;
}

+ (NSString*)getMd5Password:(NSString *)password {
    return [NSString md5:password];
}


+ (NSIndexPath*)getIndexPathBy:(UIEvent*)event inView:(UITableView*)view{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:view];
    NSIndexPath *indexPath = [view indexPathForRowAtPoint:point];
    return indexPath;
}
#pragma mark- 拨打电话
+(void)callPeopleBy:(NSString*)call view:(UIView*)view
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",call];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    
    [view addSubview:callWebview];
}



#pragma mark ---- 
+(NSMutableArray *)getPhoneInfo{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *phoneName = [[UIDevice currentDevice]name];
    NSString *systemName = [[UIDevice currentDevice]systemName];
    [array addObject:phoneName];
    [array addObject:systemName];
    return array;
}

#pragma mark ---  *获取网络图片
 
+(void)setImgUrl:(NSString *)imgUrl toImgView:(UIImageView *)imgView{
    
    [imgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"31商品管路-分类-商品列表-编辑商品_03.png"]];
    
}

#pragma mark ---  *  获取按钮的网络图片
 
+(void)setBtnImgUrl:(NSString *)imgUrl toBtnImgView:(UIButton *)Btn{
    [Btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
}

#pragma mark --剪贴图片
+(UIImage *)changeImg:(UIImage*)image {
    CGFloat imgWidth = image.size.width;
    CGFloat imgHeight = image.size.height;
    CGRect picChangedFrame;
    if (imgWidth > imgHeight) {
        picChangedFrame = CGRectMake((imgWidth-imgHeight)/2, 0, imgHeight, imgHeight);
    }else if (imgWidth < imgHeight) {
        picChangedFrame = CGRectMake((imgHeight-imgWidth)/2, 0, imgWidth, imgWidth);
    }else {
        picChangedFrame = CGRectMake(0, 0, imgWidth, imgWidth);
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, picChangedFrame);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

#pragma mark ---- 过滤
+(NSString *)filterHTML:(NSString *)html
{
    NSRange range = [html rangeOfString:@"<"];
    if (range.length == 0) {
        NSRange rang1 = [html rangeOfString:@"&#39"];
        if (rang1.length == 0) {
            return html;
        }else {
            html = [html stringByReplacingOccurrencesOfString:@"&#39" withString:@"'"];
            html = [html stringByReplacingOccurrencesOfString:@"#39" withString:@""];
        }
    }
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

#pragma mark--过滤 符号
+(NSString*)changeStr:(NSString *)str
{
    
//    str = [Utils filterHTML:str];
//    
//    NSString *regex=@"(@\\w+)|(#[^#]+#)|(\\$[^\\$]+\\$)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
//    NSArray *matchArr=[str componentsMatchedByRegex:regex];
//    NSString *repStr=@"";
//    for (NSString *linkStr in matchArr) {
//        if ([linkStr hasPrefix:@"@"]) {
//            repStr=[NSString stringWithFormat:@"<a href='user://%@'>%@</a>",[self URLEncodedString:linkStr],linkStr];
//        }
//        else if ([linkStr hasPrefix:@"http"]) {
//            repStr=[NSString stringWithFormat:@"<a href='%@'>%@</a>",linkStr,linkStr];
//        }
//        else if ([linkStr hasPrefix:@"#"]) {
//            repStr=[NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",[self URLEncodedString:linkStr],linkStr];
//        }else if ([linkStr hasPrefix:@"$"]){
//            repStr=[NSString stringWithFormat:@"<a href='money://%@'>%@</a>",[self URLEncodedString:linkStr],linkStr];
//        }
//        if(repStr!=nil)
//        {
//            str=[str stringByReplacingOccurrencesOfString:linkStr withString:repStr];
//        }
//    }
    return str;
    
}

#pragma mark - url转码解码
+ (NSString*)URLDecodedString:(NSString *)str
{
    //    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)str,CFSTR(""),kCFStringEncodingUTF8);
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)str,CFSTR(""),kCFStringEncodingUTF8));
    if(result)
        return result;
    return @"";
}
+ (NSString *)URLEncodedString:(NSString *)str
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)str,NULL,CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
    if(result)
        return result;
    return @"";
}

#pragma mark---textfield输入框字数的限制
+(void)mTextFieldDidChangeLimitLetter:(UITextField *)textField andLimitLength:(NSInteger)mLengh{
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > mLengh)
            {
                textField.text = [toBeString substringToIndex:mLengh];
            }
        }
        if ([self stringContainsEmoji:textField.text]) {
            NSInteger mlong = textField.text.length;
            textField.text = [toBeString substringToIndex:mlong-2];
            [self showMess:@"不能输入表情符号"];
        }
    }else if([self stringContainsEmoji:textField.text]) {
        NSInteger mlong = textField.text.length;
            textField.text = [toBeString substringToIndex:mlong-2];
            [self showMess:@"不能输入表情符号"];

    }else{// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > mLengh)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:mLengh];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:mLengh];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, mLengh)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }

}

#pragma mark---TextView 输入框字数的限制
+(void)mTextViewDicChangeRangeLimit:(UITextView *)textView andLimitLenth:(NSInteger)mLengh{
    NSString *toBeString = textView.text;
    NSString *lang = [textView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > mLengh)
            {
                textView.text = [toBeString substringToIndex:mLengh];
            }
        }
        if ([self stringContainsEmoji:textView.text]) {
            NSInteger mlong = textView.text.length;
            textView.text = [toBeString substringToIndex:mlong-2];
            [self showMess:@"不能输入表情符号"];
        }
    }else if([self stringContainsEmoji:textView.text]) {
        NSInteger mlong = textView.text.length;
        textView.text = [toBeString substringToIndex:mlong-2];
        [self showMess:@"不能输入表情符号"];
        
    }else{// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > mLengh)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:mLengh];
            if (rangeIndex.length == 1)
            {
                textView.text = [toBeString substringToIndex:mLengh];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, mLengh)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }

}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

#pragma mark---修改textField placeholder的颜色
+(void)changeTextFieldPlaceholderColor:(UITextField *)textField{
    [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark---字符串的处理
+(NSString *)getChangeToFloatType:(NSString *)mStr{
    return [NSString stringWithFormat:@"%.1f",[mStr floatValue]];
}

#pragma mark--输入框只能输入一位小数
+(BOOL)isInputOnePoint:(UITextField *)textField{
    NSArray *arr = [textField.text componentsSeparatedByString:@"."];
    if (arr.count==2) {
        NSString *lastStr = arr[1];
        if (lastStr.length<2) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }

}

/** 判断当前输入的是不是数字*/
+ (BOOL)isNumberInTextField:(UITextField *)startPriceTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isHaveDian = NO;
    if ([startPriceTextField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }else {
        isHaveDian = YES;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([startPriceTextField.text length]==0){
                if(single == '.'){
                    
                    [self showMess:@"亲，第一个数字不能为小数点"];
                    [startPriceTextField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
                if (startPriceTextField.text.length>=2) {
                    unichar single2=[startPriceTextField.text characterAtIndex:1];
                    if (single2 != '.' && single == '0'){
                        [self showMess:@"亲，你输入的格式不正确"];
                        return NO;
                    }
                }
                
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [self showMess:@"亲，你已经输入过小数点了"];
                    [startPriceTextField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[startPriceTextField.text rangeOfString:@"."];
                    NSInteger tt=range.location-ran.location;
                    if (tt <= 1){
                        return YES;
                    }else{
                        [self showMess:@"只能输入到小数点后一位"];
                        return NO;
                    }
                }
                else
                {
                    if (startPriceTextField.text.length==1) {
                        unichar single2=[startPriceTextField.text characterAtIndex:0];
                        if (single != '.' && single2 == '0'){
                            [self showMess:@"亲，你输入的格式不正确"];
                            return NO;
                        }
                    }
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self showMess:@"亲，你输入的格式不正确"];
            [startPriceTextField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


+(void)showMess:(NSString *)msg{
 
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = nil;
    hud.detailsLabelText = msg;
    hud.detailsLabelFont = [UIFont systemFontOfSize:13];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.5];
}

@end
