//
//  FMMaskedTextField.h
//  CustomInputTest
//
//  Created by fritzgerald muiseroux on 06/05/15.
//  Copyright (c) 2015 fritzgerald muiseroux. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface FMMaskedTextField : UIControl<UITextInput>

@property (copy, nonatomic) IBInspectable NSString *text;
@property (copy, nonatomic) IBInspectable NSString *mask;
@property (copy, nonatomic) IBInspectable NSString *placeHolder;
@property (copy, nonatomic) UIFont *font;
@property (assign, nonatomic) UIEdgeInsets contentInsets;
@property (copy, nonatomic) IBInspectable UIColor *borderColor;

@end
