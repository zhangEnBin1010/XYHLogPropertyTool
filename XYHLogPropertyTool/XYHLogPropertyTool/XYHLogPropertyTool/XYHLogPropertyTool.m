//
//  XYHLogPropertyTool.m
//  XYHLogPropertyTool
//
//  Created by ydjh-apple on 2017/9/1.
//  Copyright © 2017年 zeb-apple. All rights reserved.
//

#import "XYHLogPropertyTool.h"

#define IsKindOfArray(object)   [object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]
#define IsKindOfDictionary(object) [object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]
#define IsKindOfString(object) [object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSMutableString class]]
#define IsKindOfNull(object) [object isKindOfClass:[NSNull class]]
#define IsKindOfNumber(object) [object isKindOfClass:[NSNumber class]]

//头文件
#define head @"\n\n#import <JSONModel/JSONModel.h>\n\n"

// 顶部注释
#define commentariesM    @"//\n//  %@.m\n//  %@\n//\n//  Created by ydjh-apple on %@.\n//  Copyright © %@年 zeb-apple. All rights reserved.\n//\n"
#define commentariesH    @"//\n//  %@.h\n//  %@\n//\n//  Created by ydjh-apple on %@.\n//  Copyright © %@年 zeb-apple. All rights reserved.\n//\n"

#define ResponseModel @"ResponseModel"

@interface XYHLogPropertyTool ()

@property (strong, nonatomic) NSMutableString *stringH;//记录.h文件内容
@property (strong, nonatomic) NSMutableString *stringM;//记录.m文件内容
@property (strong, nonatomic) NSMutableString *classStrings; //声明类@class xxx;
@property (strong, nonatomic) NSMutableString *protocolStrings; //声明协议@protocol xxx;

@property (copy, nonatomic) NSString *lastStringforFrom; //记录上上层
@property (copy, nonatomic) NSString *filename; //生成的文件名字

@end

@implementation XYHLogPropertyTool


+(void)logAllPropertyWithObject:(NSObject *) object filename:(NSString *)filename {
    
#ifdef DEBUG //debug模式开启
    // 如果是模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        
        if (!filename || [filename isEqualToString:@""]) {
            filename = ResponseModel;
        }
        
        XYHLogPropertyTool *tool = [XYHLogPropertyTool new];
        tool.filename = filename;
        tool.stringH = [NSMutableString string];
        tool.stringM = [NSMutableString string];
        tool.classStrings = [NSMutableString string];
        tool.protocolStrings = [NSMutableString string];
        [tool.stringH appendString:head];
        [tool.stringM appendFormat:@"\n\n#import \"%@.h\"\n\n",filename];
        [tool.stringM appendString:@"\n"];
        
        
        dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_async(group, globalQueue, ^{
            [tool loadNextObject:object From:@""];
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            if (tool.classStrings.length > 0) {
                [tool.classStrings appendString:@";\n"];
            }
            if (tool.protocolStrings.length > 0) {
                [tool.protocolStrings appendString:@";\n"];
            }
            
            [tool.classStrings appendString:tool.protocolStrings];
            
            [tool.stringH insertString:tool.classStrings atIndex:head.length];
            
            //添加顶部注释
            [tool.stringH insertString:[NSString stringWithFormat:commentariesH,tool.filename,tool.filename,[tool getNowTime],[tool getNowYear]] atIndex:0];
            [tool.stringM insertString:[NSString stringWithFormat:commentariesM,tool.filename,tool.filename,[tool getNowTime],[tool getNowYear]] atIndex:0];
            
            NSString *txtPathH = [[XYHLogPropertyTool parsingJsonDirectoryWithFilename:tool.filename] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",tool.filename]];
            [tool.stringH writeToFile:txtPathH atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            NSString *txtPathM = [[XYHLogPropertyTool parsingJsonDirectoryWithFilename:tool.filename] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",tool.filename]];
            [tool.stringM writeToFile:txtPathM atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            NSLog(@"请复制地址：%@",txtPathH);
        });
    }
    
#else
    [XYHLogPropertyTool clearParsingJson];
#endif
    
}
+(void)logAllPropertyWithData:(NSData *) data filename:(NSString *)filename {
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"obj:%@",obj);
    [self logAllPropertyWithObject:obj filename:filename];
}

//加载下一个数据
-(void)loadNextObject:(NSObject*) object From:(NSString*) from {
    
    //用来判断是数组还是字典
    NSString *arrString = @"array";
    NSString *dicString = @"dictionary";
    
    if (IsKindOfArray(object)) { //数组
        [self.stringH appendFormat:@"//%@\n", arrString];
        
        NSArray *array = (NSArray*)object;
        if (array.count > 0) {
            id obj = [array firstObject]; //数组的话必然是相同的字典 只需要取其中一个判断即可
            if (IsKindOfDictionary(obj)) { //是字典
                [self loadNextObject:obj From:from];
            }else if (IsKindOfArray(obj)) { //数组
                [self loadNextObject:obj From:from];
            }else { //不是字典和数组
                [self.stringH appendFormat:@"@property (strong, nonatomic) NSArray <Optional>*%@;      //此数据异常，请检查!!!from:  %@\n", from,self.lastStringforFrom];
            }
        }
    }else if (IsKindOfDictionary(object)) { //字典
        
        [self.stringH appendFormat:@"//%@\n", dicString];
        
        NSDictionary *dictionary = (NSDictionary*)object;
        NSMutableDictionary *arrAndObj = [NSMutableDictionary dictionary];
        
        //添加类
        if ([from isEqualToString:@""]) {
            [self.stringH appendFormat:@"\n@interface %@ : JSONModel\n\n",self.filename];
            [self.stringM appendFormat:@"\n@implementation %@\n\n",self.filename];
        }else {
            [self.stringH appendFormat:@"\n@interface %@ : JSONModel\n\n",[NSString stringWithFormat:@"%@Model",[from capitalizedString]]];
            [self.stringM appendFormat:@"\n@implementation %@\n\n",[NSString stringWithFormat:@"%@Model",[from capitalizedString]]];
        }
        NSInteger count = [dictionary allKeys].count;
        for (int i = 0; i < count; i++) {
            NSString *key = [dictionary allKeys][i];
            
            id obj = dictionary[key];
            
            NSString *type = nil;
            NSString *category = nil;
            
            if (IsKindOfString(obj)) { //字符串
                type = @"copy";
                category = @"NSString <Optional>";
            }else if (IsKindOfNumber(obj)) { //数字
                type = @"strong";
                category = @"NSNumber <Optional>";
            }else if (IsKindOfNull(obj)) { //空按照字符串处理
                type = @"copy";
                category = @"NSString <Optional>";
            }else { //字典或者 数组
                if (IsKindOfArray(obj)) { //数组
                    NSArray *arr = (NSArray *)obj;
                    id obj = [arr firstObject]; //数组的话判断是不是对象
                    if (IsKindOfDictionary(obj)) { //是对象
                        NSString *model = [NSString stringWithFormat:@"%@Model",[key capitalizedString]];
                        type = @"strong";
                        category = [NSString stringWithFormat:@"NSArray <%@>",model];
                        //声明protocol
                        if (self.protocolStrings.length == 0) {
                            [self.protocolStrings appendFormat:@"@protocol %@",model];
                        }else {
                            [self.protocolStrings appendFormat:@",%@",model];
                        }
                    }
                    
                }else if (IsKindOfDictionary(obj)) {
                    NSString *model = [NSString stringWithFormat:@"%@Model",[key capitalizedString]];
                    type = @"strong";
                    category = [NSString stringWithFormat:@"%@ <Optional>",model];
                    //声明class
                    if (self.classStrings.length == 0) {
                        [self.classStrings appendFormat:@"@class %@",model];
                    }else {
                        [self.classStrings appendFormat:@",%@",model];
                    }
                }
                [arrAndObj setObject:obj forKey:key];
            }
            if (type && category) {
                [self.stringH appendFormat:@"@property (%@, nonatomic) %@*%@;      //from:  %@\n", type, category, key, from];
            }
            
            if (i == count - 1) {
                [self.stringH appendString:@"\n@end\n"];
                [self.stringM appendString:@"\n@end\n"];
            }
        }
        
        
        for (NSString *key in [arrAndObj allKeys]) {
            //因为此key下的value是字典或者数组，所以这个key就是他们的主键，打印出来
            [self.stringH appendFormat:@"\n//object:  %@\n", key];
            self.lastStringforFrom = from;
            [self loadNextObject:arrAndObj[key] From:key];
        }
        
    }
}
//文件存储路径
+ (NSString *)parsingJsonDirectoryWithFilename:(NSString *)filename {
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@",cachesDirectory,@"ParsingJsonDirectory",filename];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    return directoryPath;
}
//删除存储的解析文件
+ (void)clearParsingJson {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",cachesDirectory,@"ParsingJsonDirectory"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:nil];
    }
}
// 获取当前时间
- (NSString *)getNowTime {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
// 获取当前时间的年
- (NSString *)getNowYear {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
@end
