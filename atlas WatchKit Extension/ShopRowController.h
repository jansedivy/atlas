//
//  ShopRowController.h
//  atlas
//
//  Created by Jan Sedivy on 5/9/15.
//  Copyright (c) 2015 Jan Sedivy. All rights reserved.
//

#import <Foundation/Foundation.h>

@import WatchKit;

@interface ShopRowController : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *rowLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *packLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *group;
@property (weak, nonatomic) IBOutlet WKInterfaceSeparator *line;

@property int rowId;
@property bool done;
@property NSString *category;
@property NSString *pack;
@property NSString *name;

@end
