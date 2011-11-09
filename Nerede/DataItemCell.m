//
//  DataItemCell.m
//  Nerede
//
//  Created by yasin on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataItemCell.h"
#import "defs.h"


@implementation DataItemCell
@synthesize m_imageView, m_title,  m_subTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        m_imageView = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:KEY_DEFAULT_CELL_IMAGE];
        m_imageView.image = img;

        m_imageView.tag = KEY_CELL_IMAGE_TAG;
        
        m_title = [[[UILabel alloc] init] autorelease];
        m_title.text = @"Oy Gülüm Oy";
        m_title.opaque = YES;
        m_title.numberOfLines = 0;
        m_title.tag = KEY_CELL_TITLE_TAG;

        m_subTitle = [[[UILabel alloc] init] autorelease];
        
        m_subTitle.text = @"Abcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpower Abcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpowerAbcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpowerAbcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpowerAbcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpowerAbcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpowerAbcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpowerAbcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpowerAbcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpowerAbcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpowerAbcdef xerwer wer wer werertert wr ertert555wer wert5t34regerg wer ertccccwer wertertreterter we34534534534 rw435fdg4ter wer wererwkerpower ne"; 
        m_subTitle.numberOfLines = 0;
        m_subTitle.tag = KEY_CELL_SUBTITLE_TAG;
        m_subTitle.opaque = YES;
        m_subTitle.backgroundColor = [UIColor redColor];
        m_subTitle.font = [UIFont systemFontOfSize:17];
        m_subTitle.lineBreakMode = UILineBreakModeWordWrap;
        
        [self.contentView addSubview:m_title];
        [self.contentView addSubview:m_subTitle];
        [self.contentView addSubview:m_imageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    
    if (!self.editing) {
        UIImage *img = m_imageView.image;
        float imgWidth = img.size.width;
        float imgHeight = img.size.height;
        float cellWidht = self.frame.size.width;
        
        m_imageView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
        m_title.frame = CGRectMake(imgWidth + 10, 5, cellWidht, 20);
        
        
        CGSize size = [m_subTitle.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(contentRect.size.width - imgWidth - 10, 9999) lineBreakMode:UILineBreakModeWordWrap];
        
        [m_subTitle sizeToFit];
        m_subTitle.frame = CGRectMake(imgWidth + 10, 30, size.width, size.height);
        

    }
    
    self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, m_subTitle.frame.size.height + 100);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    
    [m_imageView release];
    [m_title release];
    [m_subTitle release];
    [super dealloc];
}

@end
