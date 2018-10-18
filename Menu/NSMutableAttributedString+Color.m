//
//  NSMutableAttributedString+Color.m
//  testTextView
//
//  Created by Suresh Soni on 7/25/17.
//  Copyright © 2017 Suresh Soni. All rights reserved.
//

#import "NSMutableAttributedString+Color.h"

@implementation NSMutableAttributedString (Color)

-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color
{
    NSRange range = [self.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound)
    {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}


@end
