//
//  ViewController.m
//  01-KVO
//
//  Created by 周健平 on 2019/10/24.
//  Copyright © 2019 周健平. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "JPPerson.h"
#import "NSObject+JPExtension.h"

@interface ViewController ()
@property (nonatomic, strong) JPPerson *per1;
@property (nonatomic, strong) JPPerson *per2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.per1 = [[JPPerson alloc] init];
    self.per1.age = 10;
    
    self.per2 = [[JPPerson alloc] init];
    self.per2.age = 13;
    
    // 添加KVO
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.per1 addObserver:self forKeyPath:@"age" options:options context:nil];
    [self.per1 addObserver:self forKeyPath:@"weight" options:options context:nil];
    
    // 直接监听成员变量不起效，除非有成员变量的setXXX:方法，因为生成的子类要重写这个方法来进行监听
    [self.per1 addObserver:self forKeyPath:@"height" options:options context:nil];
    
    NSLog(@"per1 %@, per2 %@", object_getClass(self.per1), object_getClass(self.per2));
    NSLog(@"per1 %@, per2 %@", self.per1.class, self.per2.class);
    
    // object_getClass(self.per1) 和 self.per1.class 获取的结果不同
    // object_getClass返回的是确切的结果，所以很有可能就是NSKVONotifying_JPPerson内部重写的Class方法返回的是自己的父类
    // 主要目的是屏蔽这个子类的内部实现，隐藏这个类的存在。
    // 为啥重写的Class方法：不重写，有可能会去到基类找Class方法调用，而基类的Class方法内部应该是调用object_getClass方法，这样就会暴露自己的存在。
    
    // 窥探KVO子类的方法
    [object_getClass(self.per1) jp_lookMethods];
}

- (void)dealloc {
    [self.per1 removeObserver:self forKeyPath:@"age"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.per1.age += 1;
    
    // 直接修改不会触发KVO
    self.per1->_height += 1;
    // 这样才会触发KVO，说明NSKVONotifying_XXX内部重写的是setXXX:方法
    [self.per1 setHeight:10];
    
    // 手动触发KVO（必须先willChangeValueForKey后didChangeValueForKey，且缺一不可）
    [self.per1 willChangeValueForKey:@"weight"];
    [self.per1 didChangeValueForKey:@"weight"];
    
//    self.per2.age += 2;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSValue *oldValue = change[NSKeyValueChangeOldKey];
    NSValue *newValue = change[NSKeyValueChangeNewKey];
    NSLog(@"=================");
    NSLog(@"%@ --- %@", object, keyPath);
    NSLog(@"old --- %@", oldValue);
    NSLog(@"new --- %@", newValue);
    NSLog(@"=================");
}

@end
