//
//  ViewController.m
//  atlas
//
//  Created by Jan Sedivy on 5/9/15.
//  Copyright (c) 2015 Jan Sedivy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)showNotification:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *dropdown;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *pack;
- (IBAction)submit:(id)sender;

@property NSArray *arrStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrStatus = [[NSArray alloc] initWithObjects:@"green", @"blue", @"yellow", @"red", nil];
    
    _dropdown.delegate = self;
    _dropdown.dataSource = self;
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return _arrStatus.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [_arrStatus objectAtIndex:row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showNotification:(id)sender {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:20];
    notification.alertBody = @"Hello I am alert body";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;

    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (IBAction)submit:(id)sender {
    NSString *name = self.name.text;
    NSString *pack = self.pack.text;
    NSString *category = [_arrStatus objectAtIndex:[self.dropdown selectedRowInComponent:0]];
    
    name = [name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    pack = [pack stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![name isEqualToString:@""] && ![pack isEqualToString:@""]) {
        [self.name setText:@""];
        [self.pack setText:@""];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://atlas-api.jansedivy.com:3001/add/?name=%@&category=%@&pack=%@", name, category, pack]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error,%@", [error localizedDescription]);
            }
        }];
    }
}

@end
