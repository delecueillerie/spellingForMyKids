//
//  DBCoreDataStack+HumanReadingEntities.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 31/01/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "DBCoreDataStack+HumanReadingEntities.h"

@implementation DBCoreDataStack (HumanReadingEntities)


////////////////////////////////////////////////////////////////////////
//ENTITIES DICTIONARY DESCRIPTION
//The descritpion's dictonary is used to display user friendly information in the edition menu for example and to know which entites have to appear in the edition menu
////////////////////////////////////////////////////////////////////////

-(NSDictionary *) entitiesDictionary {

    NSMutableDictionary * entitiesDictionary = [[NSMutableDictionary alloc]init];

    NSArray * entitiesArray = [self.managedObjectModel entities];
    NSEntityDescription *entityDescription;
    for (entityDescription in entitiesArray) {

        NSMutableDictionary *oneEntityDictionary;
        ////////////////////////////////////////////////////////////////////////
        //WORD ENTITY
        ////////////////////////////////////////////////////////////////////////
        if ([entityDescription.name isEqualToString:@"Word"]) {
            oneEntityDictionary = [NSMutableDictionary dictionaryWithDictionary: @{
                                                            @"entityDescription":entityDescription,
                                                            @"sortDescriptor":@"name",
                                                            @"label":@"les mots à apprendre",
                                                            @"detail": @"Ecrivez et dictez chaque mot de la dictée",
                                                            @"textLabel":@"name",
                                                            @"editable": @YES,
                                                            @"rank":[NSNumber numberWithInt:0]}];

            NSArray *propertiesArray = [entityDescription properties];
            NSPropertyDescription *property;
            for (property in propertiesArray) {
                NSDictionary *onePropertyDictionary;
                if ([property isKindOfClass:[NSAttributeDescription class]]) {

                    if ([property.name isEqualToString:@"name"]) {
                        onePropertyDictionary = @{@"label": @"dictez le mot",
                                                  @"detail": @"attention de ne pas faire de faute d'orthographe",
                                                  @"editable":@YES,
                                                  @"rank":[NSNumber numberWithInt:0],
                                                  @"type":@"string",
                                                  @"property":property
                                                  };
                        [oneEntityDictionary setObject:onePropertyDictionary forKey:property.name];

                    } else if ([property.name isEqualToString:@"picture"]) {
                        onePropertyDictionary = @{@"label": @"prenez le mot en photo",
                                                  @"detail": @"une image est parfois plus parlante et évite les homonymes",
                                                  @"editable":@YES,
                                                  @"rank":[NSNumber numberWithInt:2],
                                                  @"type":@"picture",
                                                  @"property":property
                                                  };
                        [oneEntityDictionary setObject:onePropertyDictionary forKey:property.name];

                    } else if ([property.name isEqualToString:@"audio"]) {
                        onePropertyDictionary = @{@"label": @"enregistrez le mot",
                                                  @"detail": @"attention à la prononciation",
                                                  @"editable":@YES,
                                                  @"rank":[NSNumber numberWithInt:1],
                                                  @"type":@"audio",
                                                  @"property":property
                                                  };
                        [oneEntityDictionary setObject:onePropertyDictionary forKey:property.name];
                    }
                }
            }
            [entitiesDictionary setObject:oneEntityDictionary forKey:entityDescription.name];

        }
        ////////////////////////////////////////////////////////////////////////
        //KID ENTITY
        ////////////////////////////////////////////////////////////////////////
        else if ([entityDescription.name isEqualToString:@"Kid"]) {
            oneEntityDictionary = [NSMutableDictionary dictionaryWithDictionary: @{
                                                            @"entityDescription":entityDescription,
                                                            @"sortDescriptor":@"name",
                                                            @"label":@"Les enfants qui font les dictées",
                                                            @"detail": @"un prénom et une image pour mieux se reconnaitre",
                                                            @"editable": @YES,
                                                            @"textLabel":@"name",
                                                            @"rank":[NSNumber numberWithInt:1]}];

            NSArray *propertiesArray = [entityDescription properties];
            NSPropertyDescription *property;
            for (property in propertiesArray) {
                if ([property isKindOfClass:[NSAttributeDescription class]]) {

                    NSDictionary *onePropertyDictionary;
                    if ([property.name isEqualToString:@"name"]) {
                        onePropertyDictionary = @{@"label": @"le prénom",
                                                  @"detail": @"",
                                                  @"editable":@YES,
                                                  @"rank":[NSNumber numberWithInt:0],
                                                  @"type":@"string",
                                                  @"property":property
                                                  };
                        [oneEntityDictionary setObject:onePropertyDictionary forKey:property.name];

                    } else if ([property.name isEqualToString:@"picture"]) {
                        onePropertyDictionary = @{@"label": @"Image",
                                                  @"detail": @"une image pour mieux se reconnaitre",
                                                  @"editable":@YES,
                                                  @"rank":[NSNumber numberWithInt:1],
                                                  @"type":@"picture",
                                                  @"property":property
                                                  };
                        [oneEntityDictionary setObject:onePropertyDictionary forKey:property.name];

                    }
                }
            }
            [entitiesDictionary setObject:oneEntityDictionary forKey:entityDescription.name];

        }



        ////////////////////////////////////////////////////////////////////////
        //SPELLING ENTITY
        ////////////////////////////////////////////////////////////////////////
        else if ([entityDescription.name isEqualToString:@"Spelling"]) {
            oneEntityDictionary = [NSMutableDictionary dictionaryWithDictionary:  @{
                                                            @"entityDescription":entityDescription,
                                                            @"sortDescriptor":@"name",
                                                            @"label":@"Les dictées",
                                                            @"detail": @"Regroupez une liste de mot",
                                                            @"editable": @YES,
                                                            @"textLabel":@"name",
                                                            @"rank":[NSNumber numberWithInt:2]}];

            NSArray *propertiesArray = [entityDescription properties];
            NSPropertyDescription *property;
            for (property in propertiesArray) {
                NSDictionary *onePropertyDictionary;
                if ([property isKindOfClass:[NSAttributeDescription class]]) {
                    if ([property.name isEqualToString:@"name"]) {
                        onePropertyDictionary = @{@"label": @"le nom de cette dictée",
                                                  @"detail": @"Pensez à utiliser la sonorité travaillée",
                                                  @"editable":@YES,
                                                  @"rank":[NSNumber numberWithInt:0],
                                                  @"type":@"string",
                                                  @"property":property
                                                  };
                        [oneEntityDictionary setObject:onePropertyDictionary forKey:property.name];

                    } else if ([property.name isEqualToString:@"explication"]) {
                        onePropertyDictionary = @{@"label": @"Explication",
                                                  @"detail": @"Expliquez l'objectif de cette dictée et rappelez les principes à mettre en oeuvre",
                                                  @"editable":@YES,
                                                  @"rank":[NSNumber numberWithInt:1],
                                                  @"type":@"string",
                                                  @"property":property
                                                  };
                        [oneEntityDictionary setObject:onePropertyDictionary forKey:property.name];

                    }
                }
            }
            [entitiesDictionary setObject:oneEntityDictionary forKey:entityDescription.name];

        }
    }
    return entitiesDictionary;
}




@end
