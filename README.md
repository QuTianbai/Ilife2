# 马上贷

> 测试接口例

```
http://192.168.2.41:9898/msfinanceapi/v1/app/check_version?versionCode=10000
```

## 原型地址

```
http://csaelj.axshare.com/#p=index
http://73p2qg.axshare.com/#p=index
```

## 测试验证码

666666

## 测试地址

- 开发：https://192.168.2.41:8288/msfinanceweb/ 数据库 41
- 测试：http://192.168.2.51:8088/msfinanceweb/  数据库 42
- UAT：http://www.msxf.uat/
- 生产：http://www.msxf.com/

---

## Style Conventions

### General

- Every line of code comes with a hidden piece of documentation.
- Don’t Message self in Objective-C init (and dealloc)
- Muti-Parameters to object
- Don’t Use Accessor Methods in Initializer Methods and dealloc
- Stick to a line-based coding style

### Naming

- Use `-`  link Resource file name.
- noun

### Coding

- Indent using 2 spaces.
- Keep lines 100 characters or shorter. Break long statements into
  shorter ones over multiple lines.
- In Objective-C, use `#pragma mark -` to mark public, internal,
  protocol, and superclass methods.

### Commits

- Why is this change necessary?
- How does it address the issue?
- What side effects does this change have?
- Update Fix Add Improve Move
- Remove Clean Rename Format Refactor Use
- Bumping version to / Convert to
- To the discussion. issue/story/card

### Release

- Version `v` prefix
- Builds auto increase
- Bumping version to `v1.0.0`
- Tag the version: `git tag -s vA.B.C -F release-notes-file`
- Push the tag: `git push origin master --tags`
- Announce!

---

### 日志记录

https://fabric.io
xiaolong.xia@msfinance.cn
msfinance@2015

> Script

    ./Externals/Fabric.framework/run 670b3cf4e9582aba989e7aad7e964a4a41c0e20e 9d02fc1cf0f14796fdac44289d833b82895cfca0be3139f7a66a9f2f7d22fe28

### 第三方统计平台ID

```
账号：app@msfinance.cn
密码：@2015msfinance

统计分析：umeng
崩溃收集：fabric
```

## 信用卡扫描控件

```
pod 'CardIO'

https://github.com/card-io/card.io-iOS-source
https://github.com/card-io/card.io-iOS-SDK
```
