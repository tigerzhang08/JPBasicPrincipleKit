//
//  main.m
//  04-super
//
//  Created by 周健平 on 2019/11/20.
//  Copyright © 2019 周健平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPStudent.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        
        JPStudent *stu = [[JPStudent alloc] init];
        [stu run];
    }
    return 0;
}
