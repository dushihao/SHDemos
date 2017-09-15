# SHDemos
记录平时写的小demo
##LayoutButton 
### 使用
```
    self.imagePositionButton = [[LayoutButton alloc] init];
    self.imagePositionButton.backgroundColor = [UIColor redColor];
    self.imagePositionButton.imagePosition = QMUIButtonImagePositionTop;//将图片位置改为在文字上方
    self.imagePositionButton.spacingBetweenImageAndTitle = 8;
    [self.imagePositionButton setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [self.imagePositionButton setTitle:@"图片在上方的按钮" forState:UIControlStateNormal];
    self.imagePositionButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.imagePositionButton];
```
