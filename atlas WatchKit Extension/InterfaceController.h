//
//  InterfaceController.h
//  atlas WatchKit Extension
//
//  Created by Jan Sedivy on 5/9/15.
//  Copyright (c) 2015 Jan Sedivy. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "ShopRowController.h"

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceTable *myTable;

@end