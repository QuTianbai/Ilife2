<h3>现金贷 App REST API</h3>
____

<h4>简介</h4>
`现金贷App REST API是用来提供给移动端使用的，我们以实际的`[RESTFul](http://www.ruanyifeng.com/blog/2011/09/restful.html)`设计原则提供了一套`[REST](http://en.wikipedia.org/wiki/Representational_state_transfer) `API。`

`我们的API参照HTTP的特点使用的是面向资源的URL，像验证，请求方法和响应码等。所有的请求响应主体都是JSON编码，包括错误响应。所有现成的HTTP客户端都可以被用于与我们的API交互。`

<h4>更新日志</h4>
2015.04.29
 
- 更改 头信息新增Device，用于收集设备信息，去掉User-Agent(注：运营商串改)
- 更改 检查版本新增渠道
- 新增 [检查是否有正在处理的贷款申请](#users_user_id_processing)
- 新增 [根据金额获取期数](#loans_amount_installments)

2015.05.5

- 更改 头信息Device新增设备ID
- 更改 贷款列表状态
- 例如修改密码、忘记密码，需要返回{"message":""}

<h4>请求</h4>
<pre>
<font color=green>所有请求都采用HTTPS协议</font>
<font color=green>基本URL地址:https://api.msfinance.cn</font>
<font color=green>API版本:v1</font>
</pre>

__注:所有接口__

<pre><font color=red>
头信息
手机基本信息>Device:平台 +系统版本; + 渠道; + App内部版本号; + 制造商; + 牌子; + 型号; + 编译ID; + 设备ID; + GPS(lat,lng)
已登录> Cookie:xxx</font></pre>

__JSON内容__

所有的`POST`, `PUT`, `PATCH`请求都是[JSON](http://en.wikipedia.org/wiki/JSON)编码并且必须有`application/json`类型，否则API将返回`415 Unsupported Media Type`状态码。
<pre>
$ curl -u token:X https://api.msfinance.cn/{apiVersion}/users/{userId} \
    -X PATCH \
    -H 'Content-Type: application/json' \
    -d '{"username":"张三"}'
</pre>
__HTTP 方法__

我们使用标准的HTTP请求方法作为请求意图：

- `GET` - 获取资源或资源集合
- `POST` - 创建资源
- `PATCH` - 修改资源
- `PUT` - 设置资源
- `DELETE` - 删除资源

__受限的HTTP客户端__

如果你使用的HTTP客户端不支持`PUT`,`PATCH`或`DELETE`请求，那么只需要发送一个`POST`请求附上一个`X-HTTP-Method-Override`请求头标明行为即可。

<pre>
$ curl -u token:X https://api.msfinance.cn/{apiVersion}/users/{userId} \
    -X POST \
    -H "X-HTTP-Method-Override: DELETE"
</pre>

<h4>响应</h4>
`所有的响应内容都是`[JSON](http://en.wikipedia.org/wiki/JSON)`编码`

一个单独的资源由一个json对象来表示:
<pre>
{
    "field1": "value",
    "field2": true,
    "field3": []
}
</pre>
一个资源集合由一个json对象数组来表示:
<pre>
[
    {
        "field1": "value",
        "field2": true,
        "field3": []
    },
    {
        "field1": "another value",
        "field2": false,
        "field3": []
    }
]
</pre>
`时间戳是`[UTC](http://en.wikipedia.org/wiki/Coordinated_Universal_Time)`标准且是`[ISO8601](http://en.wikipedia.org/wiki/ISO_8601)`格式。`

`未设置的变量将会以null表示，如果该变量是数组，将以一个空数组表示[]。`

__HTTP状态码__

_<font color=red>成功状态码</font>_

- `200 OK` - 请求成功。包括响应
- `201 Created` - 资源已创建。新资源的URL在Location header
- `204 No Content` - 请求成功，但没有返回内容
 
_<font color=red>失败状态码</font>_

- `400 Bad Request` - 请求无法解析
- `401 Unauthorized` - 没有提供证书或验证失败(未登录)
- `403 Forbidden` - 验证通过用户没有访问权限
- `404 Not Found` - 资源未找到
- `415 Unsupported Media Type` - POST/PUT/PATCH请求没有带上`application/json`类型
- `422 Unprocessable Entry` - 由于一个[验证错误](#validation_error)导致请求修改或创建资源失败
- `429 Too Many Requests` - 由于[速度限制](#rate_limiting)请求被拒绝
- `500, 501, 502, 503, etc` - 服务内部出错
  
__错误__

所有400系列的错误（400，401，403等等）都将会返回application/json类型以及在body中的一个json对象。
<pre>
{
    "message": "Not Found"
}
</pre>
所有500系列的错误码 (500, 501, 502等等)不会返回json body。

__<p id="validation_error">验证错误</p>__

如果在POST/PUT/PATCH请求时发生验证错误, 会返回验证错误`422 Unprocessable Entry`状态码。json返回的body中会包含一个错误信息数组。
<pre>
{
    "message": "Validation Failed",
    "errors": [
        {
            "message": "Field is not valid"
        },
        {
            "message": "OtherField is already used"
        }
    ]
}
</pre>
<h4 id="rate_limiting">限速</h4>
所有url，用户和令牌，API每分钟速度限制最多100个单位。一次请求通常代表一个单位。但[内嵌](#embedding)和[计数](#counting)可以增加一次请求的单位数。所有的响应包括头部描述当前限速状态如下：
<pre>
Rate-Limit-Limit: 200
Rate-Limit-Remaining: 199
Rate-Limit-Used: 1
Rate-Limit-Reset: 20
Rate-Limit-Limit - 当前时段限速上限
Rate-Limit-Remaining - 当前时段剩余可用单位
Rate-Limit-Used - 本次请求使用的单位数
Rate-Limit-Reset - 离限速重置的秒数
</pre>
如果达到限速，该API将会返回过多请求状态码`429 Too Many Requests`。这种情况下在重置(`Rate-Limit-Reset`倒计时完成)之前你的应用就不应发送更多请求了。
<h4>变量过滤</h4>
所有API的返回值都可以只截取你需要的值。只需要传一个查询参数附带你需要的变量列表且分别用逗号隔开就可以了。

`比如`

`GET https://api.msfinance.cn/{apiVersion}/users?fields=user_id,user_name`

`返回值如下:`
<pre>
[
    {
        "user_id": "543dafdaf3d4",
        "user_name:": "小张"
    },
    {
        "user_id": "543dafdaf3dd",
        "user_name:": "小李"
    }
]
</pre>
<h4 id=embedding>内嵌</h4>
许多url都支持嵌入相关资源以缩小API的响应的往返次数。

嵌入(`embed`)查询参数，用逗号隔开作为参数进行传递。

`GET https://api.msfinance.cn/{apiVersion}/users/{userId}?embed=labels`
<pre>
{
    id: "543add",
    type: "email",
    label_ids: [
        "qaz123",
        "wsx123"
    ],
    labels: [
        {
            id: "qaz123",
            name: "普通"
        },
        {
            id: "wsx123",
            name: "VIP"
        }
    ],
    ...其他数据...
}
</pre>
只有特定的资源类型才能嵌入特定的url。url文档里详细介绍了哪些可以嵌入。

每个嵌入类型都会有额外的限速单位。
<h4 id=counting>计数</h4>
所有的返回集合都可以提供一个结果集总数，只需要包含一句`count=true`作为查询参数即可。计数结果将会以`Total-Count`返回.

`GET https://api.msfinance.cn/{apiVersion}/users?count=true`

`200 OK`
<pre>
Total-Count: 135
Rate-Limit-Limit: 200
Rate-Limit-Remaining: 198
Rate-Limit-Used: 2
Rate-Limit-Reset: 20
Content-Type: application/json
[
  ... results ... 
]
</pre>
注意返回的计数代表的是整个有效结果的数量，不是作为当前响应的部分返回的数量。

每次计数都会有额外的限速单位。

<h4>封装</h4>
如果你的HTTP客户端难以读取状态码或请求头，我们可以将所有的响应结果打包到一个body里返回。只要使用`envelope=true`作为请求参数，你的所有请求就会返回状态码200，而真正的状态，头部信息和响应结果都将包含在body中。

`GET /https://api.msfinance.cn/{apiVersion}/users/does-not-exist?envelope=true`

`200 OK`
<pre>
{
    "status": 404,
    "headers": {
        "Rate-Limit-Limit": 200,
        "Rate-Limit-Remaining": 150,
        "Rate-Limit-Used": 0,
        "Rate-Limit-Reset": 25
    },
    "response": {
        "message": "Not Found"
    }
}
</pre>
<h4>分页</h4>
对将返回集合的接口的请求可以返回0~100个结果，可以使用`per_page`和`page`参数来进行控制。所有的返回数量默认是10个结果。 

`GET https://api.msfinance.cn/{apiVersion}/users?per_page=15&page=2`

并非所有的url都支持分页。如果支持，文档里会提到。
<h4>排序</h4>
一些url提供结果排序，可以使用`sort`以逗号隔开的列表作为参数进行排序。你可以使用`-`赋值sort来指定降序指定。并非所有的值都可以排序。url文档会列出支持的排序选项。

所有的url结果集默认以创建的顺序进行降序排列。

为了获取最近更新的票，按照更新的降序排列如下：

`GET https://api.msfinance.cn/{apiVersion}/users?sort=-updated_at`
____

<h4 id="api">API 列表</h4>

__应用__

资源 | 方法 | 描述
--- | --- | ---
[/app/check_version](#app_check_version) | GET | 检查版本

__广告__

资源 | 方法 | 描述
--- | --- | ---
[/ads/home](#ads_home) | GET | 首页广告

__认证__

资源 | 方法 | 描述
--- | --- | ---
[/authenticate](#authenticate_login) | POST | 登录
[/authenticate](#authenticate_register) | POST | 注册
[/authenticate](#authenticate_logout) | DELETE | 登出

__用户__

资源 | 方法 | 描述
--- | --- | ---
[/users/forget_password](#users_forget_password) | PUT | 忘记密码
[/users/{userId}/profile](#users_user_id_profile) | GET | 个人信息
[/users/{userId}/update_password](#users_user_id_update_password) | PUT | 更新密码
[/users/{userId}/update_avatar](#users_user_id_update_avatar) | PUT | 更新头像
[/users/{userId}/real_name_auth](#users_user_id_real_name_auth) | POST | 实名认证
[/users/{userId}/bind_bank_card](#users_user_id_bind_bank_card) | POST | 绑定银行卡
[/users/{userId}/processing](#users_user_id_processing) | GET | 是否正在处理的贷款申请
[/users/{userId}/check_employee](#users_user_id_check_employee) | GET | 是否是员工

__协议__

资源 | 方法 | 描述
--- | --- | ---
[/agreement/user](#agreement_user) | GET | 用户协议
[/agreement/loan](#agreement_loan) | GET | 贷款协议

__验证码__

资源 | 方法 | 描述
--- | --- | ---
[/captcha/{phoneNumber}/register](#captcha_register) | GET | 注册验证码
[/captcha/{phoneNumber}/forget_password](#captcha_forget_password) | GET | 忘记密码验证码

__贷款__

资源 | 方法 | 描述
--- | --- | ---
[/loans](#loans_p) | POST | 申请贷款
[/loans](#loans_g) | GET | 贷款列表
[/loans/spec](#loans_spec) | GET | 获得申请资料
[/loans/{loanId}](#loans_loan_id) | GET | 贷款详情
[/loans/{amount}/installments](#loans_amount_installments) | GET | 根据金额获得期数列表
[/loans/{amount}/interval](#loans_amount_interval) | GET | 获取金额区间

__还款__

资源 | 方法 | 描述
--- | --- | ---
[/repayment](#repayment_g) | GET | 还款

__还款计划__

资源 | 方法 | 描述
--- | --- | ---
[/plans](#plans_g) | GET | 计划列表
[/plans/{planId}](#plans_plan_id) | GET | 计划详情
[/plans/{planId}/installments](#plans_plan_id_installments) | GET | 计划期列表

__期__

资源 | 方法 | 描述
--- | --- | ---
[/installments/{installment_id}](#installments_installment_id) | GET | 期详情

__交易__

资源 | 方法 | 描述
--- | --- | ---
[/transactions](#transactions_g) | GET | 交易列表

<h4 id="ads">应用</h4>
____

__<p id="app_check_version">检查版本 [↩API](#api)</p>__
____

`地址`

`https://api.msfinance.cn/{apiVersion}/app/check_version`

`参数`

参数 | 描述
--- | ---
versionCode | 内部版本号
channel | 渠道

`例子`

`GET https://api.msfinance.cn/{apiVersion}/app/check_version`

`GET Data versionCode=10001&channel=?`

`Response:`
<pre>
{
    "status": 0, 0：不需要升级，1:强制，2：非强制
    "version": {
        "version_code": 10001, 内部版本号
        "version_name": "1.0.0", 外部版本号
        "channel":"", 渠道
        "icon": {
            "width": 100,
            "height": 100,
            "url": "",
            "type": ""
        }
        "update_url": "", 应用更新地址
        "whats_version": "", 版本变化日志
        "published": "2015-05-03T15:38:45Z" 发布时间
    }
}
    <font color=red>注：App版本规则，由主要版本(versionMajor)、小版(versionMinor)、补丁(versionPatch)、编译次数(versionBuild)组成。
       外部版本号：versionMajor.versionMinor.versionPatch
       内部版本号：versionMajor * 10000 + versionMinor * 1000 + versionPatch * 100 + versionBuild</font>
</pre>

<h4 id="ads">广告</h4>
____

__<p id="ads_home">首页广告 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/ads/home`

`参数`

`例子`

`GET https://api.msfinance.cn/{apiVersion}/ads/home`

`GET Data`

`Response:`
<pre>
[
    {
        "ad_id": "1dafds782nj2", 广告ID
        "title": "", 标题
        "type": 0, 类型
        "description": "", 描述
        "url": "", 地址
        "image": {
            "width": 100, 宽
            "height": 100, 高
            "url": "", 图片地址
            "type": "" 图片类型
        }
    },
    {
        "ad_id": "1dafds782nj3",
        "title": "",
        "type": 0,
        "description": "",
        "url": "",
        "image": {
            "width": 100,
            "height": 100,
            "url": "",
            "type": ""
        }
    }
]
</pre>

<h4 id="authenticate">认证</h4>
____

__<p id="authenticate_login">登录 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/authenticate`

`参数`

参数 | 描述
--- | ---
action | 动作
phoneNumber | 手机号码
password | 密码

`例子`

`POST https://api.msfinance.cn/{apiVersion}/authenticate`

`POST Data action=login&phoneNumber=""&password=""`

`Response:`
<pre>
{
    "user_id": "ds13dsaf21d", 用户ID
    "phone_number": "15222222222", 手机号码
    "username": "xxx", 用户名字
    "id_card": "", 身份证号码
    "bank_card_number": "", 银行卡号
    "avatar": {
        "width": 100,
        "height": 100,
        "url": "",
        "type": ""
    }
}
</pre>

__<p id="authenticate_register">注册 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/authenticate`

`参数`

参数 | 描述
--- | ---
action | 动作
phoneNumber | 手机号码
password | 密码
captcha | [验证码](#captcha_register)

`例子`

`POST https://api.msfinance.cn/{apiVersion}/authenticate`

`POST Data action=register&phoneNumber=""&password=""&captcha=""`

`Response:`
<pre>
{
    "user_id": "ds13dsaf21d",
    "phone_number": "15222222222",
    "username": "xxx",
    "id_card": "",
    "bank_card_number": "",
    "avatar": {
        "width": 100,
        "height": 100,
        "url": "",
        "type": ""
    }
}
</pre>

__<p id="authenticate_logout">登出 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/authenticate`

`参数`

`例子`

`DELETE https://api.msfinance.cn/{apiVersion}/authenticate`

`DELETE Data`

`Response:`
<pre>
{
    "message": ""
}
</pre>

<h4 id="users">用户</h4>
____

__<p id="users_user_id_profile">个人信息 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/users/{userId}/profile`

`参数`

参数 | 描述
--- | ---
userId | 用户ID

`例子`

`POST https://api.msfinance.cn/{apiVersion}/users/{userId}/profile`

`POST Data`

`Response:`
<pre>
{
    "user_id": "ds13dsaf21d",
    "phone_number": "15222222222",
    "username": "xxx",
    "id_card": "",
    "bank_card_number": "",
    "avatar": {
        "width": 100,
        "height": 100,
        "url": "",
        "type": ""
    }
}
</pre>

__<p id="users_forget_password">忘记密码 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/users/forget_password`

`参数`

参数 | 描述
--- | ---
phoneNumber | 手机号码
captcha | [验证码](#captcha_forget_password)</h3>
password | 密码

`例子`

`PUT https://api.msfinance.cn/{apiVersion}/users/forget_password`

`PUT Data phoneNumber=""&captcha=""&password=""`

`Response:`
<pre>
{
    "message": ""
}
</pre>

__<p id="users_user_id_update_password">更新密码 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/users/{userId}/update_password`

`参数`

参数 | 描述
--- | ---
password | 密码
new_password | 新密码

`例子`

`PUT https://api.msfinance.cn/{apiVersion}/users/{userId}/update_password`

`PUT Data password=""&new_password=""`

`Response:`
<pre>
{
    "message": ""
}
</pre>

__<p id="users_user_id_update_avatar">修改头像 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/users/{userId}/updat_avatar`

`参数`

参数 | 描述
--- | ---
userId | 用户ID
image | 图片

`例子`

`PUT https://api.msfinance.cn/{apiVersion}/users/{userId}/update_avatar`

`PUT Data image=file&filename="avatar"&conent-type="image/*"` <font color=red>多媒体表单</font>

`Response:`
<pre>
{
    "user_id": "ds13dsaf21d",
    "phoneNumber": "15222222222",
    "username": "xxx",
    "id_card": "",
    "bank_card_number": "",
    "avatar": {
        "width": 100,
        "height": 100,
        "url": "",
        "type": ""
    }
}
</pre>

__<p id="users_user_id_real_name_auth">实名认证 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/users/{userId}/real_name_auth`

`参数`

参数 | 描述
--- | ---
userId | 用户ID
username | 姓名
id_card | 身份证
expire | 到期时间
valid_for_lifetime | 长期有效(true,false)

`例子`

`POST https://api.msfinance.cn/{apiVersion}/users/{userId}/real_name_auth`

`POST Data username=""&id_card=""&expire=""&valid_for_lifetime=true`

`Response:`
<pre>
{
    "user_id": "ds13dsaf21d",
    "phoneNumber": "15222222222",
    "username": "xxx",
    "id_card": "",
    "bank_card_number": "",
    "avatar": {
        "width": 100,
        "height": 100,
        "url": "",
        "type": ""
    }
}
</pre>

__<p id="users_user_id_bind_bank_card">绑定银行卡 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/users/{userId}/bind_bank_card`

`参数`

参数 | 描述
--- | ---
userId | 用户ID
bank_name | 银行名字
bank_card_number | 银行卡号
province_code | 省
city_code | 市
county_code | 县
detail_address | 详细地址

`例子`

`POST https://api.msfinance.cn/{apiVersion}/users/{userId}/bind_bank_card`

`POST Data bank_name=""&bank_card_number&province_code=""&city_code=""&county_code=""&detail_address=""`

`Response:`
<pre>
{
    "user_id": "ds13dsaf21d",
    "phoneNumber": "15222222222",
    "username": "xxx",
    "id_card": "",
    "bank_card_number": "",
    "avatar": {
        "width": 100,
        "height": 100,
        "url": "",
        "type": ""
    }
}
</pre>

__<p id="users_user_id_processing">检查是否有正在处理的贷款申请 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/users/{userId}/processing"`

`参数`

参数 | 描述
--- | ---
userId | 用户ID

`例子`

`GET https://api.msfinance.cn/{apiVersion}/users/{userId}/processing`

`GET Data`

`Response:`
<pre>
{
    "processing": true
}
</pre>

__<p id="users_user_id_check_employee">检查是否是员工 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/users/{userId}/check_employee"`

`参数`

参数 | 描述
--- | ---
userId | 用户ID

`例子`

`GET https://api.msfinance.cn/{apiVersion}/users/{userId}/check_employee`

`GET Data`

`Response:`
<pre>
{
    "employee": true,
}
</pre>




<h4 id="agreement">协议</h4>
____

__<p id="agreement_user">用户协议 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/agreement/user`

`参数`

`例子`

`GET https://api.msfinance.cn/{apiVersion}/agreement/user`

`GET Data`

`Response:`
<pre>
<font color=green >HTML</font>
</pre>

__<p id="agreement_loan">贷款协议 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/agreement/loan`

`参数`

`例子`

`GET https://api.msfinance.cn/{apiVersion}/agreement/loan`

`GET Data`

`Response:`
<pre>
<font color=green >HTML</font>
</pre>

<h4 id="authenticate">验证码</h4>
____

__<p id="captcha_register">注册(验证码) [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/captcha/{phoneNumber}/register`

`参数`

参数 | 描述
--- | ---
phoneNumber | 手机号码

`例子`

`GET https://api.msfinance.cn/{apiVersion}/captcha/{phoneNumber}/register`

`GET Data`

`Response:`
<pre>
{
    "message": ""
}
</pre>

__<p id="captcha_forget_password">忘记密码(验证码) [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/captcha/{phoneNumber}/forget_password`

`参数`

参数 | 描述
--- | ---
phoneNumber | 手机号码

`例子`

`GET https://api.msfinance.cn/{apiVersion}/captcha/{phoneNumber}/forget_password`

`GET Data`

`Response:`
<pre>
{
    "message": ""
}
</pre>

<h4 id="loans">贷款</h4>
____

__<p id="loans_p">申请贷款 [↩API](#api)</p>__
____

`地址`

`https://api.msfinance.cn/{apiVersion}/loans`

`参数`

参数 | 描述 | pager
--- | --- | ---
loanId | 申请ID
applyStatus1 | 申请状态 | 申请状态1（0:用户信息未填完  1:用户填完了最后一页信息后提交）
loanFor | 贷款用途 | 1
loanPrincipal | 贷款本金 | 1
loanInstallment | 贷款期数 | 1
clientCategory | 客户来源种类 | 1
eduBackground | 教育程度 | 2
socialStatus | 社会身份 | 2
school | 学校名称 | 2
enrollYear | 入学年份 | 2
schoolSystem | 学制 | 2
serviceYear | 工作年限 | 2
currentWorkStartTime | 现工作开始时间 | 2
companyName | 单位/个体全称 | 2
department | 任职部门 | 2
position | 职位 | 2
industryCategory | 行业类别 | 2
unitNature | 单位性质 | 2
unitProvince | 单位所在省 | 2
unitCity | 单位所在市 | 2
unitDistrict | 单位所在区/县 | 2
unitTown | 单位所在镇 | 2
unitStreet | 单位所在街道/村/路 | 2
unitCommunity | 单位所在小区/楼盘 | 2
unitUnitNumber | 单位所在栋/单元/房间号 | 2
monthlyIncome | 月工作收入 | 2
monthlyOtherIncome | 月其他收入 | 2
monthlyHouseholdExpense | 家庭月总支出 | 2
unitAreaCode | 办公/个体电话区号 | 2
unitTelephone | 办公/个体电话 | 2
unitExtensionTelephone | 办公/个体电话分机号 | 2
curMatchPerAddress | 现居住地址与户籍地址是否相同 | 3
curProvince | 现居省 | 3
curCity | 现居市 | 3
curDistrict | 现居区/县 | 3
curTown | 现居镇 | 3
curStreet | 现居街道/村/路 | 3
curCommunity | 现居小区/楼盘 | 3
curUnitNumber | 现居栋/单元/房间号 | 3
mailMatchPerAddress | 邮寄地址与工作地址是否相同 | 3
mailMatchCurAddress | 邮寄地址与现居地址是否相同 | 3
maritalStatus | 婚姻状况 | 4
housingConditions | 住房状况 | 4
fstFamilyMemberName | 家庭成员名称 | 4
fstFamilyMemberType | 家庭成员类型 | 4
fstFamilyMemberMobile | 家庭成员手机号 | 4
fstFamilyMemberAddress | 家庭成员联系地址 | 4	
fstFamilyMemberMatchPerAddress | 家庭成员地址与户籍地址相同 | 4
sndFamilyMemberName | 家庭成员名称 | 4
sndFamilyMemberType | 家庭成员类型 | 4
sndFamilyMemberMobile | 家庭成员手机号 | 4
sndFamilyMemberAddress | 家庭成员联系地址 | 4	
sndFamilyMemberMatchPerAddress | 家庭成员地址与户籍地址相同 | 4
homeFixLine | 住宅电话 | 5
homeFixLineRegistrant | 住宅电话登记人 | 5
personalEmail | 个人电子邮箱 | 5
1stContactName | 联系人姓名 | 5
1stContactMobile | 联系人手机号 | 5
1stRelationship | 与申请人关系 | 5
2ndContactName | 联系人姓名 | 5
2ndContactMobile | 联系人手机号 | 5
2ndRelationship | 与申请人关系 | 5
clientDescription | 客户申请描述 | 5
qq | QQ号
weixin | 微信号
renren | 人人账号
sinaWeibo | 新浪微博			
tencentWeibo | 腾讯微博
taobao | 淘宝账号
taobaoPwd | 淘宝密码
jdAccount | 京东账号
jdAccountPwd | 京东密码	

`例子`

`POST https://api.msfinance.cn/{apiVersion}/loans`

`POST Data pager="1"loanFor="car"&loanPrincipal="10000" ......`

`Response:`

<pre>
{
    "message": ""
}
</pre>

__<p id="loans_spec">获取申请资料 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/loans/spec`

`参数`

`例子`

`GET https://api.msfinance.cn/{apiVersion}/loans/spec`

`GET Data`

`注意：一次性获取申请贷款接口的全部字段数据`

`Response:`

<pre>
{
    "loanFor": "car",
    "loanPrincipal": "10000",
    ...
}
</pre>

__<p id="loans_g">贷款列表 [↩API](#api)</p>__
____
`支持分页`

`地址`

`https://api.msfinance.cn/{apiVersion}/loans`

`参数`

`例子`

`GET https://api.msfinance.cn/{apiVersion}/loans`

`GET Data`

`Response:`
<pre>
[
    {
        "loan_id": "1dafds782nj2", 贷款合同ID
        "apply_time": "2015-05-03T15:38:45Z", 申请时间
        "payed_amount": "", 已还金额
        "total_amount": "", 总金额
        "monthly_repayment_amount": "", 每月还款金额
        "current_installment": 4, 当前期数
        "total_installments": 10, 总期数
        "status": 0 1：申请中，2：申请成功，3：申请失败，4：还款中，5：取消，6：已完结，7：已逾期
    },
    {
        "loan_id": "1dafds782nj4",
        "apply_time": "2015-05-03T15:38:45Z",
        "payed_amount": "",
        "total_amount": "",
        "monthly_repayment_amount": "",
        "current_installment": 4,
        "total_installments": 10,
        "status": 0
    }
]
</pre>

__<p id="loans_amount_installments">根据金额获得期数列表 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/loans/{amount}/installments`

`参数`

参数 | 描述
--- | ---
amount | 金额

`例子`

`GET https://api.msfinance.cn/{apiVersion}/loans/{amount}/installments`

`GET Data`

`Response:`
<pre>
[
    {
        "installment_id": "1dafds782nj2", 期ID
        "issue": 4 期数
    },
    {
        "installment_id": "1dafds782nj2",
        "issue": 8
    }
]
</pre>

<h4 id="repayment">还款</h4>
____

__<p id="repayment_g">还款 [↩API](#api)</p>__
____
`地址``https://api.msfinance.cn/{apiVersion}/repayment``参数``例子``GET https://api.msfinance.cn/{apiVersion}/repayment``GET Data``Response:`
<pre> {     "repayment_id": "1dafds782nj6", 还款ID     "expire_date": 2015-01-01T01:00:00Z, 还款截止时间     "amount": 197,　总金额 }</pre>

<h4 id="plans">还款计划</h4>
____

__<p id="plans_g">计划列表 [↩API](#api)</p>__
____
`支持分页`

`地址`

`https://api.msfinance.cn/{apiVersion}/plans`

`参数`

`例子`

`GET https://api.msfinance.cn/{apiVersion}/plans`

`GET Data`

`Response:`
<pre>
[
    {
        "plan_id": "1dafds782nj6", 计划ID
        "repayment_time": "2015-05-03T15:38:45Z", 还款时间
        "repayment_amount": 197,　本金
        "interest_rate": 0.99,　利息
        "service_charges": 2.00,　服务费
        "repayment_total_amount": 199.99 总金额
    },
    {
        "plan_id": "1dafds782nj8",
        "repayment_time": "2015-05-03T15:38:45Z",
        "repayment_amount": 197,
        "interest_rate": 0.99,
        "service_charges": 2.00,
        "repayment_total_amount": 199.99
    }
]
</pre>

__<p id="plans_plan_id">计划详情 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/plans/{planId}`

`参数`

参数 | 描述
--- | ---
planId | 计划

`例子`

`GET https://api.msfinance.cn/{apiVersion}/plans/{planId}`

`GET Data`

`Response:`
<pre>
{
    "plan_id": "1dafds782nj8",
    "repayment_time": "2015-05-03T15:38:45Z",
    "repayment_amount": 197,
    "interest_rate": 0.99,
    "service_charges": 2.00,
    "repayment_total_amount": 199.99
}
</pre>

__<p id="plans_plan_id_installments">计划期列表 [↩API](#api)</p>__
____
`地址`

`https://api.msfinance.cn/{apiVersion}/plans/{planId}/installments`

`参数`

参数 | 描述
--- | ---
planId | 计划ID

`例子`

`GET https://api.msfinance.cn/{apiVersion}/plans/{planId}/installments`

`GET Data`

`Response:`
<pre>
[
    {
        "installment_id": "1dafds782nj5", 期ID
        "plan_id": "1dafds782nj6", 计划ID
        "loan_id": "1dafds7828", 贷款ID
        "repayment_amount": 197, 本金
        "interest_rate": 0.99, 利息
        "service_charges": 2, 服务费
        "repayment_total_amount": 199.99 总金额
    },
    {
        "installment_id": "1dafds782nj6",
        "plan_id": "1dafds782nj6",
        "loan_id": "1dafds7828",
        "repayment_amount": 197,
        "interest_rate": 0.99,
        "service_charges": 2,
        "repayment_total_amount": 199.99
    }
]
</pre>

<h4 id="installments">期</h4>
____

__<p id="installments_installment_id">期详情 [↩API](#api)</p>__
____
`支持分页`

`地址`

`https://api.msfinance.cn/{apiVersion}/installments/{installmentId}`

`参数`

参数 | 描述
--- | ---
installmentId | 期ID

`例子`

`GET https://api.msfinance.cn/{apiVersion}/installments/{installmentId}`

`GET Data`

`Response:`
<pre>
{
    "installment_id": "1dafds782nj5", 期ID
    "plan_id": "1dafds782nj6", 计划ID
    "loan_id": "1dafds7828", 合同ID
    "repayment_amount": 197, 本金
    "interest_rate": 0.99, 利息
    "service_charges": 2, 服务费
    "repayment_total_amount": 199.99 总金额
}
</pre>

<h4 id="transactions">交易</h4>
____

__<p id="transactions_g">交易列表 [↩API](#api)</p>__
____
`支持分页`

`地址`

`https://api.msfinance.cn/{apiVersion}/transactions`

`参数`

`例子`

`GET https://api.msfinance.cn/{apiVersion}/transactions`

`GET Data`

`Response:`
<pre>
[
    {
        "transaction_id": "1dafds782nj2", 交易ID
        "date": "2015-05-03T15:38:45Z", 日期
        "amount": 0, 金额
        "description": "" 描述
    },
    {
        "transaction_id": "1dafds782nj5",
        "date": "2015-05-03T15:38:45Z",
        "amount": 0,
        "description": ""
    }
]
</pre>
