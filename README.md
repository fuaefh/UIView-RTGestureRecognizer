# UIView-RTGestureRecognizer
A simple view looks like this:

  #import "UIView+RTGestureRecognizer.h"

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    imageView.image = [UIImage imageNamed:@"ruitai"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView gestureConfig];
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
