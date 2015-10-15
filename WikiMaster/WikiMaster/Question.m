//
//  Question.m
//  WikiMaster
//
//  Created by Kunal Wagle on 27/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "Question.h"

@interface Question()

@property int qid;
@property UIImage* image;
@property NSString* question;
@property NSString* correct;
@property NSMutableArray* incorrect;

@end

@implementation Question

#pragma getters

-(NSString*)getQuestionTitle {
    switch (self.qid) {
        case 0:
            return @"Match the image with the correct caption";
        case 1:
            return @"";
        case 2:
            return @"What article is this from?";
        default:
            return NULL;
    }
}

-(int)getQuestionID {
    return self.qid;
}

-(NSString*)getQuestionString {
    return self.question;
}

-(UIImage*)getQuestionImage {
    return self.image;
}

-(NSMutableArray*)getAnswers {
    NSMutableArray* result = [[NSMutableArray alloc] initWithArray:self.incorrect];
    [result addObject:self.correct];
    for (int i=0; i<[result count]; i++) {
        int nElements = [result count] - i;
        int n = (arc4random() % nElements) + i;
        [result exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return result;
}

-(BOOL)isCorrect:(NSString *)guess {
    return [guess isEqualToString:[self truncateString:self.correct]];
}

-(NSString*)getCorrect {
    return self.correct;
}

- (NSString *)truncateString:(NSString *)stringToTruncate
{
    if ([stringToTruncate length] > 50)
        stringToTruncate = [[stringToTruncate substringToIndex:50] stringByAppendingString:@"..."];
    
    return  stringToTruncate;
}


#pragma setters

-(void)setQuestionID:(int)qid {
    self.qid = qid;
}

-(void)setQuestionString:(NSString *)questionString {
    self.question = [self stringByStrippingHTML:questionString];
    NSLog(self.question);
}

-(void)setQuestionImage:(NSString *)link {
    NSURL *url = [NSURL URLWithString:link];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    self.image = image;
}

-(void)setCorrectAnswer:(NSString *)correct {
    self.correct = [self stringByStrippingHTML:correct];
}

-(void)addIncorrect:(NSString *)incorrect {
    if (self.incorrect) {
        [self.incorrect addObject:[self stringByStrippingHTML:incorrect]];
    } else {
        self.incorrect = [[NSMutableArray alloc] initWithObjects:[self stringByStrippingHTML:incorrect], nil];
    }
}


-(NSString *) stringByStrippingHTML:(NSString*)finalContent {
    NSRange r;
    //NSString *finalContent = self.content.copy;
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n\n"];
    while ((r = [finalContent rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        finalContent = [finalContent stringByReplacingCharactersInRange:r withString:@""];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"-"];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@"'"];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&pound;" withString:@"£"];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&eacute;" withString:@"e"];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
    finalContent = [finalContent stringByReplacingOccurrencesOfString:@"&euml" withString:@"e"];
    NSData *data = [finalContent dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *newStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return newStr;
}




@end
