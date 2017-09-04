# XYHLogPropertyTool
结合jsonmode 根据json数据直接生成解析后的文件 (懒人必备)

在数据请求下来的位置 添加[XYHLogPropertyTool logAllPropertyWithObject:jsonDic filename:@""];即可自动生成（注意当filename传空，会以ResponseModel做为文件名）

生成之后控制台会打印出生成文件的路径，复制->control+g->粘贴->enter,这时就会看到已经生成好的文件，拖入项目就可以直接使用.

![image](http://github.com/itmyhome2013/readme_add_pic/raw/master/images/nongshalie.jpg)

生成的文件不需要删除，在真机跑的时候不会生成该文件。
