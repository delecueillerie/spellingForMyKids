//
//  WTViewController.m
//  writingTool
//
//  Created by Olivier Delecueillerie on 03/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "WTViewController.h"
#import "WTAudio.h"
#import "WTBool.h"
#import "WTImage.h"
#import "WTString.h"
#import "WTDate.h"



@interface WTViewController ()

@property (nonatomic) NSAttributeType attributeType;
@property (nonatomic, strong) NSString *viewTitle;
@end

@implementation WTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.attributeType = [self.attributeDescription attributeType];
    UINavigationController *navVC = [self navigationController];


    if (self.attributeType == NSStringAttributeType ) {
        WTString *viewController = [[WTString alloc] init];
        viewController.textField.text = [self.editedObject valueForKey:[self.attributeDescription name]];
        viewController.textField.placeholder = [self.attributeDictionary valueForKey:@"label"];
        [viewController.textField becomeFirstResponder];
        [navVC pushViewController:viewController animated:NO];
    }

    else if ((self.attributeType == NSInteger16AttributeType) ||
             (self.attributeType == NSInteger32AttributeType) ||
             (self.attributeType == NSInteger64AttributeType) ||
             (self.attributeType == NSDecimalAttributeType) ||
             (self.attributeType == NSDoubleAttributeType) ||
             (self.attributeType == NSFloatAttributeType)
             ) {


//        NSNumber *value = (NSNumber*) [self.editedObject valueForKey:[self.attributeDescription name]];
//        self.textField.text = [value stringValue];
    }

    else if (self.attributeType == NSBooleanAttributeType) {
        WTBool *viewController = [[WTBool alloc] init];
        viewController.switchButton.on = (BOOL)[self.editedObject valueForKey:[self.attributeDescription name]];
    }

    else if (self.attributeType == NSDateAttributeType) {
        WTDate *viewController = [[WTDate alloc] init];
        NSDate *theDate =  [self.editedObject valueForKey:[self.attributeDescription name]];
        if (theDate) {
            viewController.datePicker.date = theDate;
        } else {
            viewController.datePicker.date = [NSDate date];
        }
    }

    else if(self.attributeType == NSBinaryDataAttributeType) {
        
        
    }
    
}





@end
