/**
 * @author   Vinay kumar Nishad
 *
 * @brief    Cell to display the feed
 *
 * @copyrigh Copyright (c) 2014 Cognizant. All rights reserved.
 *
 * @version  1.0
 *
 */

#import "TableViewCell.h"
#import "GradientClass.h"

#define SYSTEM_VERSION_LESS_THAN(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface TableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) GradientClass *viewGradient;

// Private Methods
-(void)addconstrainsForCellElements;
@end

@implementation TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]init];
        _descriptionLabel = [[UILabel alloc]init];
        _feedImage = [[UIImageView alloc]init];
        
        [self.titleLabel setNumberOfLines:0];
        [self.titleLabel setFont:[UIFont fontWithName:HelveticaNeueBold size:20.0f]];
        [self.titleLabel setTextColor:[UIColor blueColor]];
        
        [self.descriptionLabel setNumberOfLines:0];
        [self.descriptionLabel setFont:[UIFont fontWithName:HelveticaNeue size:14.0f]];
        [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.descriptionLabel setTextColor:[UIColor blackColor]];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descriptionLabel];
        [self.contentView addSubview:self.feedImage];
        
        [self addconstrainsForCellElements];
    }
    
    return self;
    
}


// The reason we’re observing changes is that if you create a table view cell, return it to the
// table view, and then later add an image (perhaps after doing some background processing), you
// need to call -setNeedsLayout on the cell for it to add the image view to its view hierarchy. We
// asked the change dictionary to contain the old value because this only needs to happen if the
// image was previously nil.
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if (object == [self imageView] &&
		[keyPath isEqualToString:@"image"] &&
		([change objectForKey:NSKeyValueChangeOldKey] == nil ||
		 [change objectForKey:NSKeyValueChangeOldKey] == [NSNull null])) {
		[self setNeedsLayout];
	}
}

- (void)prepareForReuse
{
	
	[super prepareForReuse];
}

#pragma mark -
#pragma mark Custom Methods

/*
 This Function is used to add autolayout constraint to the text label and
 image view in the tableview cell.
 
 */
-(void)addconstrainsForCellElements
{
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.feedImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Adding 'Leading' , 'Trailing' , 'Top' constraints for Title Label
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
    NSLayoutConstraint *topConstraintForTitleLabel =[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    [topConstraintForTitleLabel setPriority:UILayoutPriorityRequired]; // Setting maximum priority for the constraint
    [self.contentView addConstraint:topConstraintForTitleLabel];
    
    
    // Adding 'Leading' , 'Bottom' constraints to Description Label
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    NSLayoutConstraint *bottomConstraintForDescLabel = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.descriptionLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    [bottomConstraintForDescLabel setPriority:900];
    [self.contentView addConstraint:bottomConstraintForDescLabel];
    
    // Addding Cross Contraint between Title label and desc label
    NSLayoutConstraint *topConstraintForDescLabel=[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    [topConstraintForDescLabel setPriority:UILayoutPriorityRequired];
    [self.contentView addConstraint:topConstraintForDescLabel];
    
    
    // Adding 'Centre Y ' , 'Leading' , 'Bottom' constraints to Feed ImageView
    
    NSLayoutConstraint *centreSpacingConstraint=[NSLayoutConstraint constraintWithItem:self.feedImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [centreSpacingConstraint setPriority:900];
    [self.contentView addConstraint:centreSpacingConstraint];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.feedImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.descriptionLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.feedImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
    
    NSLayoutConstraint *constraintForImageViewBottom=[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.feedImage attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    [constraintForImageViewBottom setPriority:900]; // Setting a lower priority constraint to acheive a gap of 10 pixel between the imageview and bottom of the contentview
    [self.contentView addConstraint:constraintForImageViewBottom];
    
    NSLayoutConstraint *topSpacingCOnstraintImgView=[NSLayoutConstraint constraintWithItem:self.feedImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.descriptionLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [topSpacingCOnstraintImgView setPriority:900];
    [self.contentView addConstraint:topSpacingCOnstraintImgView];
    
    // Setting the Height and Width for the ImageView.
    NSDictionary *dictionary=NSDictionaryOfVariableBindings(_feedImage,_titleLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormatLarge options:0 metrics:nil views:dictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormatSmall options:0 metrics:nil views:dictionary]];
    
}


/*
 This function is used to get the data from the Feed object and to load in the label and imageview
 A copy of 'Feed' object is made in this function.
 
 */
-(void)loadDataInCell:(RowModel *)feeds {
    [self.descriptionLabel setText:[feeds feedsDescription]];
    [self.titleLabel setText:[feeds  feedsTitle]];
    
}

-(void)loadDataInitialCell{
    self.textLabel.text = kJsonFetch;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    // [self.contentView layoutIfNeeded];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        // Setting preferred Max width for UILabel this is required only in case of UIlabel created by code and aligned using autolayout
        [self.descriptionLabel setPreferredMaxLayoutWidth:CGRectGetWidth(self.bounds)-CGRectGetWidth(self.feedImage.bounds)-accessoryTypeSpacing-edgeSpacing];
        [self.titleLabel setPreferredMaxLayoutWidth:CGRectGetWidth(self.bounds)-accessoryTypeSpacing-edgeSpacing];
    }
    else{
        // Setting preferred Max width for UILabel this is required only in case of UIlabel created by code and aligned using autolayout
        [self.descriptionLabel setPreferredMaxLayoutWidth:CGRectGetWidth(self.bounds)-CGRectGetWidth(self.feedImage.bounds)-accessoryTypeSpacing-edgeSpacing];
        [self.titleLabel setPreferredMaxLayoutWidth:CGRectGetWidth(self.bounds)-accessoryTypeSpacing-edgeSpacing];
    }
    
    if (!self.viewGradient)
        self.viewGradient = [[GradientClass alloc] initWithFrame:self.contentView.bounds];
    self.viewGradient.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.viewGradient.layer.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [self.contentView addSubview:self.viewGradient];
    
    //Bring cell objects to fron
    [ self.contentView bringSubviewToFront: self.titleLabel ];
    [ self.contentView bringSubviewToFront: self.descriptionLabel];
    [ self.contentView bringSubviewToFront: self.feedImage ];
    
}

@end
