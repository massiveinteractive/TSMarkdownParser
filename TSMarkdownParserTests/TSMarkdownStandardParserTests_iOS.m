//
//  TSMarkdownStandardParserTests.m
//  TSMarkdownParserTests
//
//  Created by Tobias Sundstrand on 14-08-30.
//  Copyright (c) 2014 Computertalk Sweden. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TSMarkdownStandardParser.h>
#import <TSMarkupParser+FormatExamples.h>


#if TARGET_OS_TV
#define defaultSize 29
#else
#define defaultSize 12
#endif


@interface TSMarkdownStandardParserTests : XCTestCase

/// [TSMarkdownStandardParser new] version
@property (nonatomic) TSMarkdownStandardParser *standardParser;
/// [TSMarkdownStandardParser lenientParser] version
@property (nonatomic) TSMarkdownStandardParser *lenientParser;

@end


@implementation TSMarkdownStandardParserTests

- (void)setUp
{
    [super setUp];
    
    self.standardParser = [TSMarkdownStandardParser new];
    self.standardParser.resourceBundle = [NSBundle bundleForClass:[self class]];
    self.lenientParser = [TSMarkdownStandardParser lenientParser];
    self.lenientParser.resourceBundle = [NSBundle bundleForClass:[self class]];
}

- (void)tearDown
{
    self.standardParser = nil;
    self.lenientParser = nil;
    
    [super tearDown];
}

- (void)testStandardDefaultFont {
    UIFont *font = [UIFont systemFontOfSize:defaultSize];
    XCTAssertEqualObjects(self.standardParser.defaultAttributes[NSFontAttributeName], font);
    XCTAssertEqualObjects(self.lenientParser.defaultAttributes[NSFontAttributeName], font);
}

- (void)testStandardBoldFont {
    XCTAssertEqual(self.standardParser.strongTraits, (TSFontTraitMask)TSFontMaskBold);
    XCTAssertEqual(self.lenientParser.strongTraits, (TSFontTraitMask)TSFontMaskBold);
}

- (void)testStandardItalicFont {
    XCTAssertEqual(self.standardParser.emphasisTraits, (TSFontTraitMask)TSFontMaskItalic);
    XCTAssertEqual(self.lenientParser.emphasisTraits, (TSFontTraitMask)TSFontMaskItalic);
}

- (void)testStandardDefaultFontParsing {
    UIFont *font = [UIFont systemFontOfSize:defaultSize];
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\nI drink in a café everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:6 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\nI drink in a café everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:6 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
}

- (void)testStandardBoldParsing {
    UIFont *font = [UIFont boldSystemFontOfSize:defaultSize];
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\nI drink in **a café** everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:20 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\nI drink in **a café** everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:20 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
}

- (void)testStandardEmParsing {
#if TARGET_OS_IPHONE
    UIFont *font = [UIFont italicSystemFontOfSize:defaultSize];
#else
    UIFont *font = [UIFont fontWithName:@".AppleSystemUIFontItalic" size:12];
#endif
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\nI drink in *a café* everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:20 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\nI drink in *a café* everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:20 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
}

- (void)testStandardBoldParsingUnderscores {
    UIFont *font = [UIFont boldSystemFontOfSize:defaultSize];
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\nI drink in __a café__ everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:20 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\nI drink in __a café__ everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:20 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
}

- (void)testStandardEmParsingUnderscores {
#if TARGET_OS_IPHONE
    UIFont *font = [UIFont italicSystemFontOfSize:defaultSize];
#else
    UIFont *font = [UIFont fontWithName:@".AppleSystemUIFontItalic" size:12];
#endif
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\nI drink in _a café_ everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:20 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\nI drink in _a café_ everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:20 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
}

- (void)testStandardMonospaceParsing {
    UIFont *font = self.standardParser.monospaceAttributes[NSFontAttributeName];
    UIFont *lenientFont = self.lenientParser.monospaceAttributes[NSFontAttributeName];
    XCTAssertEqualObjects(font, lenientFont);
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\nI drink in `a café` everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:20 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\nI drink in `a café` everyday"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:20 effectiveRange:NULL], font);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nI drink in a café everyday");
}

- (void)testStandardBoldParsingOneCharacter {
    UIFont *font = self.standardParser.strongAttributes[NSFontAttributeName];
    UIFont *lenientFont = self.lenientParser.strongAttributes[NSFontAttributeName];
    XCTAssertEqualObjects(font, lenientFont);
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"This is **a** nice **boy**"];
    XCTAssertNotEqualObjects([attributedString attribute:NSFontAttributeName atIndex:9 effectiveRange:NULL], font);
    attributedString = [self.lenientParser attributedStringFromMarkup:@"This is **a** nice **boy**"];
    XCTAssertNotEqualObjects([attributedString attribute:NSFontAttributeName atIndex:9 effectiveRange:NULL], font);
}

//https://github.com/laptobbe/TSMarkdownParser/issues/24
- (void)testStandardEmParsingOneCharacter {
    UIFont *font = self.standardParser.emphasisAttributes[NSFontAttributeName];
    UIFont *lenientFont = self.lenientParser.emphasisAttributes[NSFontAttributeName];
    XCTAssertEqualObjects(font, lenientFont);
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"This is *a* nice *boy*"];
    XCTAssertNotEqualObjects([attributedString attribute:NSFontAttributeName atIndex:9 effectiveRange:NULL], font);
    attributedString = [self.lenientParser attributedStringFromMarkup:@"This is *a* nice *boy*"];
    XCTAssertNotEqualObjects([attributedString attribute:NSFontAttributeName atIndex:9 effectiveRange:NULL], font);
}

- (void)testStandardMonospaceParsingOneCharacter {
    UIFont *font = self.standardParser.monospaceAttributes[NSFontAttributeName];
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"This is `a` nice `boy`"];
    XCTAssertNotEqualObjects([attributedString attribute:NSFontAttributeName atIndex:9 effectiveRange:NULL], font);
    attributedString = [self.lenientParser attributedStringFromMarkup:@"This is `a` nice `boy`"];
    XCTAssertNotEqualObjects([attributedString attribute:NSFontAttributeName atIndex:9 effectiveRange:NULL], font);
}

- (void)testStandardStrongAndEmAndMonospaceInSameInputParsing {
    UIFont *strongFont = [UIFont boldSystemFontOfSize:defaultSize];
#if TARGET_OS_IPHONE
    UIFont *emphasisFont = [UIFont italicSystemFontOfSize:defaultSize];
#else
    UIFont *emphasisFont = [UIFont fontWithName:@".AppleSystemUIFontItalic" size:12];
#endif
    UIFont *monospaceFont = self.standardParser.monospaceAttributes[NSFontAttributeName];

    NSMutableArray *emphasizedSnippets = @[@"under", @"From", @"progress"].mutableCopy;
    NSUInteger expectedNumberOfEmphasisBlocks = emphasizedSnippets.count;
    __block NSUInteger actualNumberOfEmphasisBlocks = 0;

    NSMutableArray *strongSnippets = @[@"Tennis Court", @"Strawberries and Cream", @"Worn Grass"].mutableCopy;
    NSUInteger expectedNumberOfStrongBlocks = strongSnippets.count;
    __block NSUInteger actualNumberOfStrongBlocks = 0;

    NSMutableArray *monospaceSnippets = @[@"tournament", @"seat"].mutableCopy;
    NSUInteger expectedNumberOfMonospaceBlocks = monospaceSnippets.count;
    __block NSUInteger actualNumberOfMonospaceBlocks = 0;
    
    void (^IncreaseCountAndRemoveSnippet)(NSUInteger *, NSString *, NSMutableArray *) = ^(NSUInteger *count, NSString *snippet, NSMutableArray *snippets) {
        *count += 1;
        [snippets removeObject:snippet];
    };

    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"**Tennis Court** Stand *under* the spectacular glass-and-steel roof.\n\n__Strawberries and Cream__ _From_ your `seat`.\n\n**Worn Grass** See the *progress* of the `tournament`."];
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length)
                                         options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                      usingBlock:^(NSDictionary *attributes, NSRange range, __unused BOOL *stop) {
                                          UIFont *font = attributes[NSFontAttributeName];
                                          NSString *snippet = [attributedString.string substringWithRange:range];

                                          if ([emphasisFont isEqual:font]) {
                                              IncreaseCountAndRemoveSnippet(&actualNumberOfEmphasisBlocks, snippet, emphasizedSnippets);
                                          } else if ([strongFont isEqual:font]) {
                                              IncreaseCountAndRemoveSnippet(&actualNumberOfStrongBlocks, snippet, strongSnippets);
                                          } else if ([monospaceFont isEqual:font]) {
                                              IncreaseCountAndRemoveSnippet(&actualNumberOfMonospaceBlocks, snippet, monospaceSnippets);
                                          }
                                      }];

    XCTAssertEqual(actualNumberOfEmphasisBlocks, expectedNumberOfEmphasisBlocks);
    XCTAssertEqual(emphasizedSnippets.count, 0);

    XCTAssertEqual(actualNumberOfStrongBlocks, expectedNumberOfStrongBlocks);
    XCTAssertEqual(strongSnippets.count, 0);
    
    XCTAssertEqual(actualNumberOfMonospaceBlocks, expectedNumberOfMonospaceBlocks);
    XCTAssertEqual(monospaceSnippets.count, 0);
}

- (void)testStandardListWithAsteriskParsing {
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n* I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\tI drink in a café everyday\nto use Wi-Fi");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n* I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\tI drink in a café everyday\nto use Wi-Fi");
}

- (void)testStandardListWith2AsterisksParsing {
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n** I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n\t•\tI drink in a café everyday\nto use Wi-Fi");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n** I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n\t•\tI drink in a café everyday\nto use Wi-Fi");
}

- (void)testStandardQuoteParsing {
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n> I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n\tI drink in a café everyday\nto use Wi-Fi");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n> I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n\tI drink in a café everyday\nto use Wi-Fi");
}

- (void)testStandardQuoteLevel2Parsing {
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n>> I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n\t\tI drink in a café everyday\nto use Wi-Fi");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n>> I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n\t\tI drink in a café everyday\nto use Wi-Fi");
}

- (void)testStandardListWithAsteriskParsingMultiple {
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n* I drink in a café everyday\n* to use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\tI drink in a café everyday\n•\tto use Wi-Fi");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n* I drink in a café everyday\n* to use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\tI drink in a café everyday\n•\tto use Wi-Fi");
}

- (void)testStandardListWithPlusParsing {
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n+ I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\tI drink in a café everyday\nto use Wi-Fi");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n+ I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\tI drink in a café everyday\nto use Wi-Fi");
}

- (void)testStandardListWithDashParsing {
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n- I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\tI drink in a café everyday\nto use Wi-Fi");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n- I drink in a café everyday\nto use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\tI drink in a café everyday\nto use Wi-Fi");
}

- (void)testStandardListWithPlusParsingMultiple {
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n+ I drink in a café everyday\n+ to use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\tI drink in a café everyday\n•\tto use Wi-Fi");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n+ I drink in a café everyday\n+ to use Wi-Fi"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\tI drink in a café everyday\n•\tto use Wi-Fi");
}

- (void)testStandardListWorksWithMultipleDifferentListOptions {
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n+ item1\n- item2\n* item3"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\titem1\n•\titem2\n•\titem3");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n+ item1\n- item2\n* item3"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n•\titem1\n•\titem2\n•\titem3");
}


- (void)testStandardLinkParsing {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n This is a [link](https://www.example.net/) to test Wi-Fi\nat home"];
    NSURL *link = [attributedString attribute:NSLinkAttributeName atIndex:20 effectiveRange:NULL];
    XCTAssertEqualObjects(link, [NSURL URLWithString:@"https://www.example.net/"]);
    XCTAssertTrue([attributedString.string rangeOfString:@"["].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"]"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"("].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@")"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"link"].location != NSNotFound);
    NSNumber *underline = [attributedString attribute:NSUnderlineStyleAttributeName atIndex:20 effectiveRange:NULL];
    XCTAssertEqualObjects(underline, @(NSUnderlineStyleSingle));
    UIColor *linkColor = [attributedString attribute:NSForegroundColorAttributeName atIndex:20 effectiveRange:NULL];
    XCTAssertEqualObjects(linkColor, [UIColor blueColor]);

    NSURL *linkAtTheNextCharacter = [attributedString attribute:NSLinkAttributeName atIndex:21 effectiveRange:NULL];
    XCTAssertNil(linkAtTheNextCharacter);
}

- (void)testStandardAutoLinkParsing {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n This is a link https://www.example.net/ to test Wi-Fi\nat home"];
    NSURL *link = [attributedString attribute:NSLinkAttributeName atIndex:24 effectiveRange:NULL];
    XCTAssertEqualObjects(link, [NSURL URLWithString:@"https://www.example.net/"]);
    NSNumber *underline = [attributedString attribute:NSUnderlineStyleAttributeName atIndex:24 effectiveRange:NULL];
    XCTAssertEqualObjects(underline, @(NSUnderlineStyleSingle));
    UIColor *linkColor = [attributedString attribute:NSForegroundColorAttributeName atIndex:24 effectiveRange:NULL];
    XCTAssertEqualObjects(linkColor, [UIColor blueColor]);
}

- (void)testStandardLinkParsingOnEndOfStrings {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n This is a [link](https://www.example.net/)"];
    NSURL *link = [attributedString attribute:NSLinkAttributeName atIndex:20 effectiveRange:NULL];
    XCTAssertEqualObjects(link, [NSURL URLWithString:@"https://www.example.net/"]);
    XCTAssertTrue([attributedString.string rangeOfString:@"["].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"]"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"("].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@")"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"link"].location != NSNotFound);
    NSNumber *underline = [attributedString attribute:NSUnderlineStyleAttributeName atIndex:20 effectiveRange:NULL];
    XCTAssertEqualObjects(underline, @(NSUnderlineStyleSingle));
    UIColor *linkColor = [attributedString attribute:NSForegroundColorAttributeName atIndex:20 effectiveRange:NULL];
    XCTAssertEqualObjects(linkColor, [UIColor blueColor]);
    
}

- (void)testStandardLinkParsingEnclosedInParenthesis {
    NSString *expectedRawString = @"Hello\n This is a (link) to test Wi-Fi\nat home";
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n This is a ([link](https://www.example.net/)) to test Wi-Fi\nat home"];
    NSURL *link = [attributedString attribute:NSLinkAttributeName atIndex:21 effectiveRange:NULL];
    XCTAssertEqualObjects(link, [NSURL URLWithString:@"https://www.example.net/"]);

    XCTAssertEqualObjects(attributedString.string, expectedRawString);
}

// https://github.com/laptobbe/TSMarkdownParser/pull/39
- (void)testStandardLinkParsingWithBracketsInside {
    NSString *expectedRawString = @"Hello\n a link [with brackets inside]";
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n [a link \\[with brackets inside]](https://example.net/)"];
    NSURL *link = [attributedString attribute:NSLinkAttributeName atIndex:35 effectiveRange:NULL];
    XCTAssertEqualObjects(link, [NSURL URLWithString:@"https://example.net/"]);
    
    XCTAssertEqualObjects(attributedString.string, expectedRawString);
}

// https://github.com/laptobbe/TSMarkdownParser/pull/39
- (void)testStandardLinkParsingWithBracketsOutside {
    NSString *expectedRawString = @"Hello\n [This is not a link] but this is a link to test [the difference]";
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n [This is not a link] but this is a [link](https://www.example.net/) to test [the difference]"];
    NSURL *link = [attributedString attribute:NSLinkAttributeName atIndex:44 effectiveRange:NULL];
    XCTAssertEqualObjects(link, [NSURL URLWithString:@"https://www.example.net/"]);
    
    XCTAssertEqualObjects(attributedString.string, expectedRawString);
}

- (void)testStandardLinkParsingMultipleLinks {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n This is a [link](https://www.example.net/) and this is [a link](https://www.example.com/) too"];

    //first link
    NSURL *link = [attributedString attribute:NSLinkAttributeName atIndex:17 effectiveRange:NULL];
    XCTAssertEqualObjects(link, [NSURL URLWithString:@"https://www.example.net/"]);
    XCTAssertTrue([attributedString.string rangeOfString:@"link"].location != NSNotFound);
    NSNumber *underline = [attributedString attribute:NSUnderlineStyleAttributeName atIndex:17 effectiveRange:NULL];
    XCTAssertEqualObjects(underline, @(NSUnderlineStyleSingle));
    UIColor *linkColor = [attributedString attribute:NSForegroundColorAttributeName atIndex:17 effectiveRange:NULL];
    XCTAssertEqualObjects(linkColor, [UIColor blueColor]);
    
    //second link
    NSURL *link2 = [attributedString attribute:NSLinkAttributeName atIndex:37 effectiveRange:NULL];
    XCTAssertEqualObjects(link2, [NSURL URLWithString:@"https://www.example.com/"]);
    XCTAssertTrue([attributedString.string rangeOfString:@"a link"].location != NSNotFound);
    NSNumber *underline2 = [attributedString attribute:NSUnderlineStyleAttributeName atIndex:37 effectiveRange:NULL];
    XCTAssertEqualObjects(underline2, @(NSUnderlineStyleSingle));
    UIColor *linkColor2 = [attributedString attribute:NSForegroundColorAttributeName atIndex:37 effectiveRange:NULL];
    XCTAssertEqualObjects(linkColor2, [UIColor blueColor]);

    XCTAssertTrue([attributedString.string rangeOfString:@"["].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"]"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"("].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@")"].location == NSNotFound);
}

// https://github.com/laptobbe/TSMarkdownParser/pull/22
- (void)testStandardLinkParsingWithPipe {
    NSString *expectedRawString = @"Hello (link). Bye";
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello ([link](https://www.example.net/|)). Bye"];
    NSURL *link = [attributedString attribute:NSLinkAttributeName atIndex:8 effectiveRange:NULL];
    XCTAssertEqualObjects(link, [NSURL URLWithString:[@"https://www.example.net/|" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]);

    XCTAssertEqualObjects(attributedString.string, expectedRawString);
}

// https://github.com/laptobbe/TSMarkdownParser/issues/30
- (void)testStandardLinkParsingWithSharp {
    NSString *expectedRawString = @"Hello (link). Bye";
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello ([link](https://www.example.net/#)). Bye"];
    NSURL *link = [attributedString attribute:NSLinkAttributeName atIndex:8 effectiveRange:NULL];
    XCTAssertEqualObjects(link, [NSURL URLWithString:@"https://www.example.net/#"]);

    XCTAssertEqualObjects(attributedString.string, expectedRawString);
}

- (void)testStandardH1 {
    UIFont *h1Font = self.standardParser.headerAttributes[0][NSFontAttributeName];
    UIFont *h1LenientFont = self.lenientParser.headerAttributes[0][NSFontAttributeName];
    XCTAssertEqualObjects(h1Font, h1LenientFont);
#if TARGET_OS_TV
    XCTAssertEqual(h1Font.pointSize, 76.f);
#else
    XCTAssertEqual(h1Font.pointSize, 23.f);
#endif
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n# Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h1Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n#Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h1Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
}

- (void)testStandardH1IsParsedCorrectly {
    UIFont *h1Font = self.standardParser.headerAttributes[0][NSFontAttributeName];
    
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"first line\n# header\nsecond line"];
    NSRange headerRange = [attributedString.string rangeOfString:@"header"];
    XCTAssertTrue(headerRange.location != NSNotFound);
    
    [attributedString enumerateAttributesInRange:headerRange options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attributes, __unused NSRange range, __unused BOOL *stop) {
        UIFont *font = attributes[NSFontAttributeName];
        XCTAssertNotNil(font);
        XCTAssertEqual(font, h1Font);
    }];
}

// '#header' is not a valid header per markdown syntax and shouldn't be parsed as one
- (void)testStandardHeaderIsNotParsedWithoutSpaceInBetween {
    NSString *notValidHeader = @"#header";
    UIFont *h1Font = self.standardParser.headerAttributes[0][NSFontAttributeName];
    
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:notValidHeader];
    NSRange headerRange = [attributedString.string rangeOfString:@"header"];
    [attributedString enumerateAttributesInRange:headerRange options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attributes, __unused NSRange range, __unused BOOL *stop) {
        UIFont *font = attributes[NSFontAttributeName];
        XCTAssertNotEqual(font, h1Font);
    }];
    XCTAssertEqualObjects(attributedString.string, notValidHeader);
}

- (void)testStandardHeaderIsNotParsedAtNotBeginningOfTheLine {
    NSString *hashtag = @"# hashtag";
    NSString *input = [NSString stringWithFormat:@"A sentence %@", hashtag];
    
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:input];
    XCTAssertEqualObjects(attributedString.string, input);
    NSRange hashTagStillThereRange = [attributedString.string rangeOfString:hashtag];
    XCTAssertTrue(hashTagStillThereRange.location != NSNotFound);
}

- (void)testLenientHeaderIsNotParsedAtNotBeginningOfTheLine {
    NSString *hashtag = @"#hashtag";
    NSString *input = [NSString stringWithFormat:@"A sentence %@", hashtag];
    
    NSAttributedString *attributedString = [self.lenientParser attributedStringFromMarkup:input];
    XCTAssertEqualObjects(attributedString.string, input);
    NSRange hashTagStillThereRange = [attributedString.string rangeOfString:hashtag];
    XCTAssertTrue(hashTagStillThereRange.location != NSNotFound);
}

- (void)testStandardH2 {
    UIFont *h2Font = self.standardParser.headerAttributes[1][NSFontAttributeName];
    UIFont *h2LenientFont = self.lenientParser.headerAttributes[1][NSFontAttributeName];
    XCTAssertNotNil(h2Font);
    XCTAssertEqualObjects(h2Font, h2LenientFont);
    
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n## Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h2Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n##Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h2Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
}

- (void)testStandardH3 {
    UIFont *h3Font = self.standardParser.headerAttributes[2][NSFontAttributeName];
#if TARGET_OS_TV
    XCTAssertEqual(h3Font.pointSize, 48.f);
#else
    XCTAssertEqual(h3Font.pointSize, 19.f);
#endif
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n### Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h3Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n###Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h3Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
}

- (void)testStandardH4 {
    UIFont *h4Font = self.standardParser.headerAttributes[3][NSFontAttributeName];
#if TARGET_OS_TV
    XCTAssertEqual(h4Font.pointSize, 40.f);
#else
    XCTAssertEqual(h4Font.pointSize, 17.f);
#endif
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n#### Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h4Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n####Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h4Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
}

- (void)testStandardH5 {
    UIFont *h5Font = self.standardParser.headerAttributes[4][NSFontAttributeName];
#if TARGET_OS_TV
    XCTAssertEqual(h5Font.pointSize, 36.f);
#else
    XCTAssertEqual(h5Font.pointSize, 15.f);
#endif
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n##### Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h5Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n#####Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h5Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
}

- (void)testStandardH6 {
    UIFont *h6Font = self.standardParser.headerAttributes[5][NSFontAttributeName];
#if TARGET_OS_TV
    XCTAssertEqual(h6Font.pointSize, 32.f);
#else
    XCTAssertEqual(h6Font.pointSize, 13.f);
#endif
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n###### Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h6Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"Hello\n######Men att Pär är här\nmen inte Pia"];
    XCTAssertEqualObjects([attributedString attribute:NSFontAttributeName atIndex:10 effectiveRange:NULL], h6Font);
    XCTAssertTrue([attributedString.string rangeOfString:@"#"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
}

- (void)testStandardH6NextLine {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n###### Men att Pär är här\nmen inte Pia"];
    UIFont *font = [attributedString attribute:NSFontAttributeName atIndex:30 effectiveRange:NULL];
    UIFont *expectedFont = [UIFont systemFontOfSize:defaultSize];
    XCTAssertNotNil(font);
    XCTAssertEqualObjects(font, expectedFont);
    XCTAssertEqual(font.pointSize, defaultSize);
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\nmen inte Pia");
}

- (void)testStandardMultipleMatches {
    NSAttributedString *attributedString;
    attributedString = [self.standardParser attributedStringFromMarkup:@"## Hello\nMen att *Pär* är här\n+ men inte Pia"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\n•\tmen inte Pia");
    attributedString = [self.lenientParser attributedStringFromMarkup:@"##Hello\nMen att *Pär* är här\n+men inte Pia"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\nMen att Pär är här\n•\tmen inte Pia");
}

- (void)testStandardImage {
#if TARGET_OS_IPHONE
    UIImage *refImage = [UIImage imageNamed:@"markdown.png" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    XCTAssertNotNil(refImage);
#endif
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Men att ![Pär](markdown) är här\nmen inte Pia"];
    NSString *link = [attributedString attribute:NSLinkAttributeName atIndex:8 effectiveRange:NULL];
    XCTAssertNil(link);
    NSTextAttachment *attachment = [attributedString attribute:NSAttachmentAttributeName atIndex:8 effectiveRange:NULL];
    XCTAssertNotNil(attachment);
    XCTAssertNotNil(attachment.image);
    XCTAssertTrue([attributedString.string rangeOfString:@"Pär"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"!"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"["].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"]"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"("].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@")"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"carrots"].location == NSNotFound);
    NSString *expected = @"Men att \uFFFC är här\nmen inte Pia";
    XCTAssertEqualObjects(attributedString.string, expected);
}

- (void)testStandardImageWithUnderscores {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"A ![AltText](markdown_test_image)"];
    NSString *link = [attributedString attribute:NSLinkAttributeName atIndex:2 effectiveRange:NULL];
    XCTAssertNil(link);
    NSTextAttachment *attachment = [attributedString attribute:NSAttachmentAttributeName atIndex:2 effectiveRange:NULL];
    XCTAssertNotNil(attachment);
    XCTAssertNotNil(attachment.image);
    XCTAssertTrue([attributedString.string rangeOfString:@"AltText"].location == NSNotFound);
    NSString *expected = @"A \uFFFC";
    XCTAssertEqualObjects(attributedString.string, expected);
}

- (void)testStandardImageMultiple {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Men att ![Pär](markdown) är här ![Pär](markdown)\nmen inte Pia"];
    NSString *link = [attributedString attribute:NSLinkAttributeName atIndex:8 effectiveRange:NULL];
    XCTAssertNil(link);
    NSTextAttachment *attachment = [attributedString attribute:NSAttachmentAttributeName atIndex:8 effectiveRange:NULL];
    XCTAssertNotNil(attachment);
    XCTAssertNotNil(attachment.image);
    XCTAssertTrue([attributedString.string rangeOfString:@"Pär"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"!"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"["].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"]"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"("].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@")"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"carrots"].location == NSNotFound);
    NSString *expected = @"Men att \uFFFC är här \uFFFC\nmen inte Pia";
    XCTAssertEqualObjects(attributedString.string, expected);
}

- (void)testStandardImageMissingImage {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Men att ![Pär](markdownas) är här\nmen inte Pia"];
    NSString *link = [attributedString attribute:NSLinkAttributeName atIndex:8 effectiveRange:NULL];
    XCTAssertNil(link);
    NSTextAttachment *attachment = [attributedString attribute:NSAttachmentAttributeName atIndex:8 effectiveRange:NULL];
    XCTAssertNil(attachment);
    XCTAssertTrue([attributedString.string rangeOfString:@"Pär"].location != NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"!"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"["].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"]"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"("].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@")"].location == NSNotFound);
    XCTAssertTrue([attributedString.string rangeOfString:@"carrots"].location == NSNotFound);
    XCTAssertEqualObjects(attributedString.string, @"Men att Pär är här\nmen inte Pia");
}

- (void)testStandardBoldParsingCustomFont {
    UIFont *customFont = [UIFont boldSystemFontOfSize:19];
    self.standardParser.strongAttributes = @{ NSFontAttributeName: customFont };
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\nMen att **Pär är här** men inte Pia"];
    XCTAssertEqual([[attributedString attribute:NSFontAttributeName atIndex:16 effectiveRange:NULL] pointSize], 19.f);
}

- (void)testStandardURLWithParenthesesInTheTitleText {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\n Men att [Pär och (Mia)](https://www.example.net/) är här."];
    NSURL *link = [attributedString attribute:NSLinkAttributeName atIndex:17 effectiveRange:NULL];
    XCTAssertEqualObjects(link, [NSURL URLWithString:@"https://www.example.net/"]);
    XCTAssertTrue([attributedString.string rangeOfString:@"Pär"].location != NSNotFound);
}

- (void)testStandardEscapeParsing {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\\.\n"];
    XCTAssertEqualObjects(attributedString.string, @"Hello.\n");
}

- (void)testStandardCodeEscapeParsing {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello`*.*`\n"];
    XCTAssertEqualObjects(attributedString.string, @"Hello*.*\n");
}

- (void)testStandardEscapingCodeEscapeParsing {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello\\`*.*`\n"];
    XCTAssertEqualObjects(attributedString.string, @"Hello`.`\n");
}

- (void)testStandardCodeEscapingEscapeParsing {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello`\\.`\n"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\\.\n");
}

- (void)testStandardMultilineCodeEscapeParsing {
    NSAttributedString *attributedString = [self.standardParser attributedStringFromMarkup:@"Hello``\n*.*\n``"];
    XCTAssertEqualObjects(attributedString.string, @"Hello\n*.*\n");
}

@end