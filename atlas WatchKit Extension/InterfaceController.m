//
//  InterfaceController.m
//  atlas WatchKit Extension
//
//  Created by Jan Sedivy on 5/9/15.
//  Copyright (c) 2015 Jan Sedivy. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@property NSDictionary *response;

@end

int changeId = -1;

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    [self refresh];
    
    [NSTimer scheduledTimerWithTimeInterval:0.6f
                                     target:self
                                   selector:@selector(refresh)
                                   userInfo:nil
                                    repeats:YES];

}

-(void)refresh {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://atlas-api.jansedivy.com:3001/"]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error,%@", [error localizedDescription]);
        } else {

            NSUInteger storedCount = [[self.response objectForKey:@"items"] count];
            
            self.response = [NSJSONSerialization JSONObjectWithData:data options:0 error: nil];
            
            NSUInteger nowChange = [[self.response objectForKey:@"changeId"] intValue];
            if (changeId != nowChange) {
                changeId = (int)nowChange;
            
            
            NSUInteger count = [[self.response objectForKey:@"items"] count];

            if (storedCount != count) {
                [self.myTable setNumberOfRows:count withRowType:@"default"];
            }

            for (int i=0; i<count; i++) {
                ShopRowController *row = [self.myTable rowControllerAtIndex:i];
                
                row.rowId = (int)[[[self.response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"id"];
                row.done = [[[[self.response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"done"] boolValue];
                row.pack = [[[self.response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"pack"];
                row.category = [[[self.response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"category"];
                row.name = [[[self.response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"name"];
                
                [row.rowLabel setText:row.name];
                [row.packLabel setText:row.pack];
                [row.image setImageNamed: [NSString stringWithFormat:@"%@-%@.png", row.done ? @"checked" : @"check", row.category]];
                [row.group setAlpha:row.done ? 0.4f : 1.0f];
                
                UIColor *red = [UIColor colorWithRed:255.0f/255.0f green:59.0/255.0f blue:48.0/255.0f alpha:0.3];
                UIColor *green = [UIColor colorWithRed:4.0/255.0 green:222.0/255.0 blue:113.0/255.0 alpha:0.3];
                UIColor *yellow = [UIColor colorWithRed:255.0/255.0 green:230.0/255.0 blue:32.0/255.0 alpha:0.3];
                UIColor *blue = [UIColor colorWithRed:90.0/255.0 green:200.0/255.0 blue:250.0/255.0 alpha:0.3];
                
                if (row.done) {
                    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:row.name];
                    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                            value:@2
                                            range:NSMakeRange(0, [attributeString length])];
                    [row.rowLabel setAttributedText:attributeString];
                }
                
                if ([row.category isEqualToString:@"green"]) {
                    [row.line setColor:green];
                } else if ([row.category isEqualToString:@"red"]) {
                    [row.line setColor:red];
                } else if ([row.category isEqualToString:@"yellow"]) {
                    [row.line setColor:yellow];
                } else if ([row.category isEqualToString:@"blue"]) {
                    [row.line setColor:blue];
                }
            }
        }
    }
    }];
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    NSDictionary *rowData = [[self.response objectForKey:@"items"] objectAtIndex:rowIndex];
    
    ShopRowController *row = [self.myTable rowControllerAtIndex: rowIndex];
    row.done = !row.done;
    
    [row.image setImageNamed:[NSString stringWithFormat:@"%@-%@.png", row.done ? @"checked" : @"check", row.category]];
    [row.group setAlpha:row.done ? 0.4f : 1.0f];
    
    
    if (row.done) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:row.name];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        [row.rowLabel setAttributedText:attributeString];
    } else {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:row.name];
        [row.rowLabel setAttributedText:attributeString];
    }
    
    
    int data = [[rowData objectForKey:@"id"] intValue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://atlas-api.jansedivy.com:3001/toggle/%d", data]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error,%@", [error localizedDescription]);
        }
    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



