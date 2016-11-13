WHC_PageViewKit
==============
![Build Status](https://api.travis-ci.org/netyouli/WHC_Model.svg?branch=master)
[![Pod Version](http://img.shields.io/cocoapods/v/WHC_Model.svg?style=flat)](http://cocoadocs.org/docsets/WHC_Model/)
[![Pod Platform](http://img.shields.io/cocoapods/p/WHC_Model.svg?style=flat)](http://cocoadocs.org/docsets/WHC_Model/)
[![Pod License](http://img.shields.io/cocoapods/l/WHC_Model.svg?style=flat)](https://opensource.org/licenses/MIT)
简介
==============
- **高效**: 预加载机制
- **方便**: 只需要设置简单参数即可构建炫酷的PageView
- **动画**: 支持翻页TitleBar炫酷动画效果
- **优势**: TitleBar模块和PageView模块可以单独使用
- **强大**: TitleBar支持30多种UI样式
- **咨询**: 712641411
- **作者**: 吴海超

使用演示
==============
Time lost (Benchmark 1000 times)
<img src = "https://github.com/netyouli/WHC_Model/blob/master/Result/b.png">
<img src = "https://github.com/netyouli/WHC_Model/blob/master/Result/a.png">

* 查看性能测试请运行项目： Benchmark/ModelBenchmark.xcodeproj 

要求
==============
* iOS 8.0 or later
* Xcode 8.0 or later

集成
==============
* 使用CocoaPods:
  -  pod 'WHC_PageViewKit', '~> 1.0.0'
* 手工集成:
  -  导入文件夹WHC_PageViewKit

用法
==============

###一,json -> model
```Objective-C
/// jsonString 是一个比较复杂3000行的json文件，具体参考demo
    ModelObject * model = [ModelObject whc_ModelWithJson:jsonString];
    NSLog(@"model = %@\n\n\n",model);
```

###二,model -> json
```Objective-C
    NSString * modelString = [model whc_Json];
    NSLog(@"modelString = %@\n\n\n",modelString);
```

###三,model - > NSDictionary
```Objective-C
    NSDictionary * modelDict = [model whc_Dictionary];
    NSLog(@"modelDict = %@\n\n\n",modelDict);
```

###四,指定路径只解析Head对象
```Objective-C
    Head * head = [Head whc_ModelWithJson:jsonString keyPath:@"Head"];
    NSLog(@"head = %@\n\n\n",head);
```

###五,指定路径只解析ResponseBody对象
```Objective-C
    ResponseBody * body = [ResponseBody whc_ModelWithJson:jsonString keyPath:@"ResponseBody"];
    NSLog(@"ResponseBody = %@\n\n\n",body);
```

###六,指定路径只解析PolicyRuleList集合中第一个对象
```Objective-C
    PolicyRuleList * rule = [PolicyRuleList whc_ModelWithJson:jsonString keyPath:@"ResponseBody.PolicyRuleList[0]"];
    NSLog(@"rule = %@\n\n\n",rule);
```
###七,归档对象
```Objective-C
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:body];
    NSLog(@"data = %@\n\n\n",data);
```

###八,解归档对象
```Objective-C
    ResponseBody * body = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"body = %@\n\n\n",body);
```
###九,模型对象复制
```Objective-C
    ResponseBody * copyBody = body.copy;
    NSLog(@"copyBody = %@",copyBody);
```

推荐
==============
- WHC_DataModelFactory mac工具github地址：https://github.com/netyouli/WHC_DataModelFactory

文档
==============
```Objective-C

#pragma mark - json转模型对象 Api -

/** 说明:把json解析为模型对象
 *@param json :json数据对象
 *@return 模型对象
 */
+ (id)whc_ModelWithJson:(id)json;

/** 说明:把json解析为模型对象
 *@param json :json数据对象
 *@param keyPath :json key的路径
 *@return 模型对象
 */

+ (id)whc_ModelWithJson:(id)json keyPath:(NSString *)keyPath;


#pragma mark - 模型对象转json Api -

/** 说明:把模型对象转换为字典
 *@return 字典对象
 */

- (NSDictionary *)whc_Dictionary;

/** 说明:把模型对象转换为json字符串
 *@return json字符串
 */

- (NSString *)whc_Json;

#pragma mark - 模型对象序列化 Api -

/// 复制模型对象
- (id)whc_Copy;

/// 序列化模型对象
- (void)whc_Encode:(NSCoder *)aCoder;

/// 反序列化模型对象
- (void)whc_Decode:(NSCoder *)aDecoder;
```
## <a id="期待"></a>期待

- 如果您在使用过程中有任何问题，欢迎issue me! 很乐意为您解答任何相关问题!
- 与其给我点star，不如向我狠狠地抛来一个BUG！
- 如果您想要更多的接口来自定义或者建议/意见，欢迎issue me！我会根据大家的需求提供更多的接口！

## Licenses
All source code is licensed under the MIT License.
