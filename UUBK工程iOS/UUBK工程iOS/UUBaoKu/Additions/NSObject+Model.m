//
//  NSObject+Model.m
//  pwControls
//
//  Created by MartinLee on 17/5/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/runtime.h>

@implementation NSObject (Model)

//本质：创建谁的对象
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    id obj =[[self alloc] init];
    //runtime：根据模型中的属性去字典中取出对应的value给模型属性赋值
    //    1 获取模型中所有成员变量
    //    2 根据属性名去字典中找Value
    //    3 给模型中属性赋值 KVC
    
    //    property 属性
    //    class_copyProtocolList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
    //Ivar  成员变量 以_开头的
    unsigned int count  = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i = 0; i < count ; i++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        //删除成员变量前的下划线
        NSString *key = [ivarName substringFromIndex:1];
        
        //去字典中查找对应的value
        
        id value = dictionary[key];
        
        //      转换成哪个模型
        //      获取成员变量类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        //      @\"User"->User
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        
        //二级转换，判断value是否是字典，如果是，转换成对应模型
        //并且是自定义对象才需要转换
        if([value isKindOfClass:[NSDictionary class]] && [ivarType hasPrefix:@"NS"]){
            //字典转模型
            Class modelClass = NSClassFromString(ivarType);
            value = [modelClass  modelWithDictionary:value];
        }
        if(value){
            [obj setValue:value forKey:key];
        }
    }
    return obj;
}


@end
