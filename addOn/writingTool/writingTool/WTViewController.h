//
//  WTViewController.h
//  writingTool
//
//  Created by Olivier Delecueillerie on 03/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTViewController : UIViewController

@property (nonatomic, strong) NSManagedObject *editedObject;
@property (nonatomic, strong) NSDictionary *attributeDictionary;
@property (nonatomic, strong) NSAttributeDescription *selectedAttribute;
@end
