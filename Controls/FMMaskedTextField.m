//
//  FMMaskedTextField.m
//  CustomInputTest
//
//  Created by fritzgerald muiseroux on 06/05/15.
//  Copyright (c) 2015 fritzgerald muiseroux. All rights reserved.
//

#import "FMMaskedTextField.h"

@interface FMMaskedTextField ()

@property (assign, nonatomic) BOOL initialized;
@property (readonly) NSAttributedString *displayText;

@end

@implementation FMMaskedTextField

@synthesize markedTextStyle;
@synthesize markedTextRange;
@synthesize tokenizer;
@synthesize selectedTextRange;
@synthesize beginningOfDocument;
@synthesize endOfDocument;
@synthesize inputDelegate;
@synthesize keyboardType;
@synthesize keyboardAppearance;

- (instancetype)init
{
    self = [super init];
    if (self) {
        // initiaze view
        [self setupControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupControl];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self setupControl];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)setupControl
{
    if (self.initialized) {
        return;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGesture];
    
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.font = [UIFont systemFontOfSize:15];
    self.contentInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    
    self.borderColor = [UIColor blackColor];
    
    self.initialized = YES;
}

- (void)drawRect:(CGRect)rect
{
    CGRect frame = self.bounds;
    CGRect translatedRect = CGRectMake(CGRectGetMinX(frame),
                                       CGRectGetMidY(frame) - self.font.lineHeight / 2.f,
                                       CGRectGetWidth(rect),
                                       CGRectGetHeight(rect));
    
    translatedRect = UIEdgeInsetsInsetRect(translatedRect, self.contentInsets);
    
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = 1.0f;
    
    [self.displayText drawInRect:translatedRect];
    //[self.displayText drawInRect:translatedRect withAttributes:@{NSFontAttributeName : self.font, NSForegroundColorAttributeName : [UIColor blackColor]}];
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (NSString *)transformTextIfNeeded:(NSString *)text
{
    NSMutableString *outputStr = [NSMutableString string];
    NSUInteger maskIndex = 0;
    NSUInteger charIndex = 0;
    for (; charIndex < text.length; charIndex++) {
        
        unichar currentChar = [text characterAtIndex:charIndex];
        unichar currentMask = [self.mask characterAtIndex:maskIndex];
        
        if (currentMask == '#' && isdigit(currentChar)) {
            [outputStr appendFormat:@"%c", currentChar];
            
        }
        else if(isdigit(currentChar)) {
            // the current mask value is not a number mask
            while (currentMask != '#') {
               [outputStr appendFormat:@"%c", currentMask];
                maskIndex++;
                currentMask = [self.mask characterAtIndex:maskIndex];
            }
            [outputStr appendFormat:@"%c", currentChar];
        }
        else if(currentMask != '#' && currentChar == currentMask) {
            [outputStr appendFormat:@"%c", currentChar];
        }
        
        maskIndex++;
    }
    
    if (maskIndex < self.mask.length) {
        unichar currentMask = [self.mask characterAtIndex:maskIndex];
        while (currentMask != '#') {
            // append the trailing mask format
            [outputStr appendFormat:@"%c", currentMask];
            maskIndex++;
            if (maskIndex < self.mask.length) {
                currentMask = [self.mask characterAtIndex:maskIndex];
            }
            else {
                break;
            }
        }
    }
    
    return [outputStr copy];
}

- (NSString *)deleteCharacter
{
    NSString *str = [self.text substringToIndex:self.text.length-1];
    NSInteger charIndex = str.length - 1;
    for (; charIndex >= 0; charIndex--) {
        
        unichar maskChar = [self.mask characterAtIndex:charIndex];
        unichar currentChar = [str characterAtIndex:charIndex];
        if(maskChar != '#' && !isdigit(currentChar))
        {
            str = [str substringToIndex:str.length-1];
        }
        else {
            break;
        }
    }
    return str;
    
}

- (NSAttributedString *)displayText
{
    NSMutableString *computedString = [NSMutableString string];
    NSUInteger textLength = self.text.length;
    
    if (textLength > 0) {
        [computedString appendString:self.text];
    }
    if (textLength < self.mask.length && self.placeHolder.length > 0 && textLength < self.placeHolder.length) {
        [computedString appendString:[self.placeHolder substringFromIndex:self.text.length]];
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:computedString];
    
    [attributedStr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, computedString.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, self.text.length)];
    
    if (self.placeHolder.length > 0 && textLength < self.placeHolder.length) {
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(self.text.length, self.placeHolder.length - self.text.length)];
    }
    
    return attributedStr;
}

#pragma mark - actions

- (void)tap:(id)sender
{
    if (self.isFirstResponder) {
        //
    }
    else {
        [self becomeFirstResponder];
    }
}

#pragma mark - UITextInput protocol

/* Methods for manipulating text. */
- (NSString *)textInRange:(UITextRange *)range
{
    return nil;
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text
{
    
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
{
    
}

- (void)unmarkText
{
    
}

/* Methods for creating ranges and positions. */
- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
{
    return nil;
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset
{
    return nil;
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
    return nil;
}

/* Simple evaluation of positions */
- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other
{
    return NSOrderedSame;
}

- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition
{
    return 0;
}

/* Layout questions. */
- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction
{
    return nil;
}

- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction
{
    return nil;
}

/* Writing direction */
- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
    return UITextWritingDirectionNatural;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range
{
    
}

/* Geometry used to provide, for example, a correction rect. */
- (CGRect)firstRectForRange:(UITextRange *)range
{
    return CGRectZero;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectMake(10, 30, 10, 10);
}

- (NSArray *)selectionRectsForRange:(UITextRange *)range
{
    return nil;
}

/* Hit testing. */
- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    return nil;
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range
{
    return nil;
}
- (UITextRange *)characterRangeAtPoint:(CGPoint)point
{
    return nil;
}

#pragma mark - UIKeyInput

- (BOOL)hasText
{
    return YES;
}

- (void)insertText:(NSString *)text
{
    if (text.length > 1 || !isdigit([text characterAtIndex:0])) {
        return; //ignore the digit
    }
    NSString *sourceText = self.text?:@"";
    
    NSString *newText = [sourceText stringByAppendingString:text];
    if (newText.length > self.mask.length) {
        return; // text out of bound
    }
    
    self.text = [self transformTextIfNeeded:newText];
}

- (void)deleteBackward
{
    if (self.text.length > 0) {
        //self.text = [self.text substringToIndex:self.text.length-1];
        self.text = [self deleteCharacter];
    }
}

@end
