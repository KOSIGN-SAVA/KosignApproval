
#import "KLGridView.h"
#import "KLTile.h"
#import "KLGraphicsUtils.h"
#import "Constants.h"

@implementation KLGridView

@synthesize backgroundView = _backgroundView;

const NSUInteger tileTag = 101;


- (id)initWithFrame:(CGRect)frame{
    if (![super initWithFrame:frame])
        return nil;
    
//	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;
	
    _numberOfColumns = 7;
	_numberOfRows = 6;
    _tiles = [[NSMutableArray alloc] init];
	
    return self;
}


- (void)setBackgroundView:(UIImageView *) imageView {
	if (_backgroundView)
		[self removeFromSuperview];
	_backgroundView = imageView;
    _backgroundView.backgroundColor = [UIColor clearColor];
	[self addSubview:_backgroundView];
}


- (CGFloat)columnWidth {
    return kMainCalendardaycolumnWidth;

//	return 1 + floorf((self.bounds.size.width) /_numberOfColumns); 
}


- (CGFloat)dayrowHeight {
	
//	return floorf((self.bounds.size.height)/_numberOfRows); 
	// 주간 월간의 전체 사이즈가 다르기 때문에 Tile하나의 height는 고정 
        return kMainCalendardayrowHeight;

}


- (void)layoutSubviews{
    NSInteger currentColumnIndex = 0;
    NSInteger currentRowIndex = 0;
    
    for (UIView *tileContainer in [self subviews]) {
		if (tileContainer == _backgroundView)
			continue;
		
        CGRect containerFrame = tileContainer.frame;
		
        containerFrame.size.width = [self columnWidth]; 
		containerFrame.size.height = [self dayrowHeight];
        containerFrame.origin.x = currentColumnIndex * containerFrame.size.width;
        containerFrame.origin.y = currentRowIndex * containerFrame.size.height;
		
        
        KLTile *tile = [[tileContainer subviews] objectAtIndex:0];
        CGRect tileFrame = containerFrame;
        tileFrame.origin.x = tileFrame.origin.y = 0.0f;
        tileContainer.frame = containerFrame;
        tile.frame = tileFrame;
        
        currentColumnIndex++;
        if (currentColumnIndex == _numberOfColumns) {
            currentRowIndex++;
            currentColumnIndex = 0;
        }
        
    }
}


- (void)addTile:(KLTile *)tile{
    UIView *container = [[[UIView alloc] initWithFrame:tile.frame] autorelease];
    container.backgroundColor = [UIColor clearColor];
	tile.tag = tileTag;
    [container addSubview:tile];
    [self addSubview:container];

    [_tiles addObject:tile];
}


- (void)removeAllTiles{
    for (KLTile *tile in _tiles)
        [[tile superview] removeFromSuperview]; // remove the tile's container
    [_tiles removeAllObjects];
}


- (KLTile *)tileOrNilAtIndex:(NSInteger)tileIndex{
    return (tileIndex >= 0 && tileIndex <  [_tiles count]) ? [_tiles objectAtIndex:tileIndex] : nil;
}


- (void)redrawAllTiles{
    for (KLTile *tile in _tiles)
        [tile setNeedsDisplay];
}


- (void)redrawNeighborsAndTile:(KLTile *)tile{
    NSInteger tileIndex = [_tiles indexOfObject:tile];
    
    [[self tileOrNilAtIndex:tileIndex-_numberOfColumns+1] setNeedsDisplay]; // top left
    [[self tileOrNilAtIndex:tileIndex-_numberOfColumns] setNeedsDisplay];   // top
    [[self tileOrNilAtIndex:tileIndex-_numberOfColumns-1] setNeedsDisplay]; // top right
    [[self tileOrNilAtIndex:tileIndex-1] setNeedsDisplay];                  // left
    [[self tileOrNilAtIndex:tileIndex+1] setNeedsDisplay];                  // right
    [[self tileOrNilAtIndex:tileIndex+_numberOfColumns-1] setNeedsDisplay]; // bottom left
    [[self tileOrNilAtIndex:tileIndex+_numberOfColumns] setNeedsDisplay];   // bottom
    [[self tileOrNilAtIndex:tileIndex+_numberOfColumns+1] setNeedsDisplay]; // bottom right

    [tile setNeedsDisplay]; // the center tile itself
}


- (KLTile *)leftNeighborOfTile:(KLTile *)tile{
    NSInteger tileIndex = [_tiles indexOfObject:tile];
    return [self tileOrNilAtIndex:tileIndex-1];
}


- (KLTile *)rightNeighborOfTile:(KLTile *)tile{
    NSInteger tileIndex = [_tiles indexOfObject:tile];
    return [self tileOrNilAtIndex:tileIndex+1];
}


- (void)deselectAllTiles {
	for (KLTile *tile in _tiles)
		tile.selected = NO;
}


- (void)dealloc {
    [_tiles release];
	[super dealloc];
}


@end
