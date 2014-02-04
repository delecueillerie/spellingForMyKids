//
//  EDEditVC.m
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "EDEditVC.h"

@interface EDEditVC ()

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *boolPicker;

@property (nonatomic) NSAttributeType attributeType;

@end

@implementation EDEditVC


///////////////////////////////////////////////////////////////////////////////////
//VIEW LIFECYCLE
///////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    // Set the title to the user-visible name of the field.
    self.title = self.editedFieldName;


    self.attributeType = [self.attributeDescription attributeType];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.attributeType == NSStringAttributeType ) {
        self.boolPicker.hidden = YES;
        self.textField.hidden = NO;
        self.datePicker.hidden = YES;

        self.textField.text = [self.editedObject valueForKey:[self.attributeDescription name]];
        self.textField.placeholder = self.title;
        [self.textField becomeFirstResponder];

    }

    else if ((self.attributeType == NSInteger16AttributeType) ||
             (self.attributeType == NSInteger32AttributeType) ||
             (self.attributeType == NSInteger64AttributeType) ||
             (self.attributeType == NSDecimalAttributeType) ||
             (self.attributeType == NSDoubleAttributeType) ||
             (self.attributeType == NSFloatAttributeType)
             ) {
        self.boolPicker.hidden = YES;
        self.textField.hidden = NO;
        self.datePicker.hidden = YES;

        NSNumber *value = (NSNumber*) [self.editedObject valueForKey:[self.attributeDescription name]];
        self.textField.text = [value stringValue];
    }

    else if (self.attributeType == NSBooleanAttributeType) {
        self.boolPicker.hidden = NO;
        self.textField.hidden = YES;
        self.datePicker.hidden = YES;

        self.boolPicker.on = (BOOL)[self.editedObject valueForKey:[self.attributeDescription name]];
    }

    else if (self.attributeType == NSDateAttributeType) {
        self.textField.hidden = YES;
        self.datePicker.hidden = NO;
        self.boolPicker.hidden = YES;
        NSDate *date = [self.editedObject valueForKey:[self.attributeDescription name]];
        if (date == nil) {
            date = [NSDate date];
        }
        self.datePicker.date = date;
    }

    else if(self.attributeType == NSBinaryDataAttributeType) {


    }

}


///////////////////////////////////////////////////////////////////////////////////
//SAVE AND CANCEL OPERATIONS
///////////////////////////////////////////////////////////////////////////////////

- (IBAction)save:(id)sender
{
    // Set the action name for the undo operation.
    NSUndoManager * undoManager = [[self.editedObject managedObjectContext] undoManager];
    [undoManager setActionName:[NSString stringWithFormat:@"%@", self.editedFieldName]];
    
    // Pass current value to the edited object, then pop.
    if (self.attributeType == NSDateAttributeType) {
        [self.editedObject setValue:self.datePicker.date forKey:[self.attributeDescription name]];
    }
    else {
        [self.editedObject setValue:self.textField.text forKey:[self.attributeDescription name]];
    }
#warning yo complete (binary and bool)
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel:(id)sender
{
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}





@end
