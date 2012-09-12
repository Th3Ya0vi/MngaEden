//
//  AppConfig.h
//  quickmanga
//
//  Created by Luong Ken on 1/23/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//
#import <Foundation/Foundation.h>

#define DMDownloadedStatus 2
#define DMQueuedStatus 1
#define DMDownloadingStatus 0
#define DMDefaultStatus -1

#define UIAppDelegateIphone ((AppDelegateIphone *)[UIApplication sharedApplication].delegate)
#define UIAppDelegateIpad ((AppDelegateIpad *)[UIApplication sharedApplication].delegate)
#define UIAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define IPAD_VIEWER_PADDING 20.0f
#define IPHONE_VIEWER_PADDING 10.0f

#define MANGA_MAIN_DIRECTORY @"mangable"
#ifdef MR_APP
#define OLD_DB_NAME [NSString stringWithString:@"CatalogBrowser"]
#define UIColorProgressBar 	[UIColor orangeColor]
#define UIColorHeaderText 	[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.2f alpha:1.0f]
#define UIColorRecentLabel 	[UIColor orangeColor]
#define UIColorUpdateBadge  [UIColor orangeColor];

#define NibNameCustomTableViewSectionCell [NSString stringWithString:@"CustomCatalogSectionCell_mr"]
#define NibNameCatalogMangaDetailView [NSString stringWithString:@"CatalogMangaDetailView_mr"]
#define NibNameStoreView [NSString stringWithString:@"StoreView_mr"]
#define NibNameChapterView [NSString stringWithString:@"ChapterView_mr"] 

//Nib ipad
#define NibNameMangaDetailView [NSString stringWithString:@"MangaDetailView"] 
#define NibMangaDetailViewSectionCell [NSString stringWithString:@"MangaDetailViewSectionCell"] 
#define NibIpadSettingsView [NSString stringWithString:@"IpadSettingsView"] 
#define NibIpadAboutView [NSString stringWithString:@"IpadAboutView"] 


#define UIImageBackgroundButton [UIImage imageNamed:@"barButtonNormal_mr.png"]
#define UIImageFavoriteButton [UIImage imageNamed:@"browseChapterButtonFavorite_mr.png"]
#define UIImageUnfavoriteButton [UIImage imageNamed:@"browseChapterButtonUnfavorite_mr.png"]

#define UIImageSelectedCheckmark [UIImage imageNamed:@"selected_mr.png"]
#define UIImageUnselectedCheckmark [UIImage imageNamed:@"unselected_mr.png"]

#define UIImageSwitchOn [UIImage imageNamed:@"switch_on_mr.png"]
#define UIImageSwitchOff [UIImage imageNamed:@"switch_off_mr.png"]

#define UIImageSlider [UIImage imageNamed:@"slider_mr.png"]

#define APP_NAME [NSString stringWithString:@"Manga Rock"]
#define IN_APP_BUNDLE_ID [NSString stringWithString:@"com.notabasement.mangarock.fullversion"]

#define MOBCLIX_ID [NSString stringWithString:@"24B497CE-EBE5-4EA3-8DE1-E166C1A99A9E"]
#define ADMOB_PUBLISHER_ID [NSString stringWithString:@"a14c6ef1b54b156"]

#define BLOG_TAG_NAME [NSString stringWithString:@"manga-rock"]
#endif

#ifdef MRMF_APP
#define OLD_DB_NAME [NSString stringWithString:@"mr_mf"]
#define UIColorProgressBar 	[UIColor colorWithRed:0.53f green:0.70f blue:0.0f alpha:1.0f]
#define UIColorHeaderText 	[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.2f alpha:1.0f]
#define UIColorRecentLabel 	[UIColor colorWithRed:0.75f green:1.0f blue:0.0f alpha:1.0f]
#define UIColorUpdateBadge  [UIColor colorWithRed:0.75f green:1.0f blue:0.0f alpha:1.0f]

#define NibNameCatalogMangaDetailView [NSString stringWithString:@"CatalogMangaDetailView_mf"]
#define NibNameCustomTableViewSectionCell [NSString stringWithString:@"CustomCatalogSectionCell_mf"]
#define NibNameStoreView [NSString stringWithString:@"StoreView_mf"]
#define NibNameChapterView [NSString stringWithString:@"ChapterView_mf"] 

//Nib ipad
#define NibNameMangaDetailView [NSString stringWithString:@"MangaDetailView"] 
#define NibMangaDetailViewSectionCell [NSString stringWithString:@"MangaDetailViewSectionCell"] 
#define NibIpadSettingsView [NSString stringWithString:@"IpadSettingsView"] 
#define NibIpadAboutView [NSString stringWithString:@"IpadAboutView"] 

#define UIImageBackgroundButton [UIImage imageNamed:@"barButtonNormal_mf.png"]
#define UIImageFavoriteButton [UIImage imageNamed:@"browseChapterButtonFavorite_mf.png"]
#define UIImageUnfavoriteButton [UIImage imageNamed:@"browseChapterButtonUnfavorite_mf.png"]

#define UIImageSelectedCheckmark [UIImage imageNamed:@"selected_mf.png"]
#define UIImageUnselectedCheckmark [UIImage imageNamed:@"unselected_mf.png"]

#define UIImageSwitchOn [UIImage imageNamed:@"switch_on_mf.png"]
#define UIImageSwitchOff [UIImage imageNamed:@"switch_off_mf.png"]

#define UIImageSlider [UIImage imageNamed:@"slider_mf.png"]

#define APP_NAME [NSString stringWithString:@"Manga Rock MF"]
#define IN_APP_BUNDLE_ID [NSString stringWithString:@"com.notabasement.mangarockmf.fullversion"]
#define MANGA_MAIN_DIRECTORY [NSString stringWithString:@"mangafox"]
#define MOBCLIX_ID [NSString stringWithString:@"367FFFD4-6F1E-4E87-8C72-DFE2F95922EF"]
#define ADMOB_PUBLISHER_ID [NSString stringWithString:@"a14c6ef1b54b156"]

#define BLOG_TAG_NAME [NSString stringWithString:@"manga-rock-mf"]
#endif