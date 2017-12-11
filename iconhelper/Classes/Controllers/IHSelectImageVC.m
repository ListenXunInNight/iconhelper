//
//  IHSelectImageVC.m
//  iconhelper
//
//  Created by xun on 2017/12/11.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "IHSelectImageVC.h"
#import "IHImageItem.h"

@interface IHSelectImageVC () <NSCollectionViewDelegate, NSCollectionViewDataSource>

@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSButton *unselectAllBtn;
@property (weak) IBOutlet NSButton *selectAllBtn;

@end

@implementation IHSelectImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configCollectionView];
    
    _unselectAllBtn.state = NSOffState;
    _selectAllBtn.state = NSOffState;
}

- (void)configCollectionView {
    
    //    [_collectionView registerNib:[[NSNib alloc] initWithNibNamed:@"IHImageItem" bundle:nil] forItemWithIdentifier:@"IHImageItem"];
    [_collectionView registerClass:[IHImageItem class] forItemWithIdentifier:@"IHImageItem"];
    
    _collectionView.allowsMultipleSelection = YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _imagePaths.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    IHImageItem *item = [collectionView makeItemWithIdentifier:@"IHImageItem" forIndexPath:indexPath];
    
    item.path = _imagePaths[indexPath.item];
    
    return item;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    
    
}

#pragma mark - Btn Clicked

- (IBAction)clickedUnselectAllBtn:(NSButton *)sender {
    
    _unselectAllBtn.state = NSOnState;
    _selectAllBtn.state = NSOffState;
    
    NSMutableArray *indexpaths = @[].mutableCopy;
    
    for (int i = 0; i < _imagePaths.count; i++) {
        
        [indexpaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    [_collectionView deselectItemsAtIndexPaths:[NSSet setWithArray:indexpaths]];
}

- (IBAction)clickedSelectAllBtn:(NSButton *)sender {
    
    _unselectAllBtn.state = NSOffState;
    _selectAllBtn.state = NSOnState;
    
    NSMutableArray *indexpaths = @[].mutableCopy;
    
    for (int i = 0; i < _imagePaths.count; i++) {
        
        [indexpaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    [_collectionView selectItemsAtIndexPaths:[NSSet setWithArray:indexpaths] scrollPosition:NSCollectionViewScrollPositionNone];
}

- (IBAction)deleteSelectItems:(id)sender {
    
    NSMutableArray *pathes = @[].mutableCopy;
    for (NSIndexPath *path in _collectionView.selectionIndexPaths) {
        [pathes addObject:_imagePaths[path.item]];
    }
    
    [_imagePaths removeObjectsInArray:pathes];
    if (pathes.count) {
        [_collectionView reloadData];
        !_DeleteBlock?:_DeleteBlock();
    }
}

@end
