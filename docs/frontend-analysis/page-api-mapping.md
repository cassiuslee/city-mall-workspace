# 页面与 API 映射

以 `src/pages.json` 路由配置和页面源码为基础，整理页面/组件/Store 与后端接口的对应关系。

## 主包页面

| 页面 | 路由 | 标题 | 触发方式 | 调用接口 / Store | 说明 |
| --- | --- | --- | --- | --- | --- |
| 首页 | `/pages/index/index` | 首页 | `onLoad`、下拉刷新 | `getHomeBannerAPI`、`getHomeCategoryAPI`、`getHomeHotAPI`、`useGuessList -> XtxGuess -> getHomeGoodsGuessLikeAPI` | 当前页面真实展示轮播和猜你喜欢；分类/热门面板模板被注释，但请求仍会发出 |
| 分类页 | `/pages/category/category` | 商品分类 | `onLoad` | `getHomeBannerAPI(2)`、`getCategoryTopAPI` | 左侧一级分类、右侧二级分类商品列表 |
| 商品详情 | `/pages/goods/goods?id=:id` | 商品详情 | `onLoad`、加购、立即购买 | `getGoodsByIdAPI`、`postMemberCartAPI` | 用商品详情结果组装 SKU 弹层需要的数据；立即购买跳转订单确认页 |
| 热门推荐 | `/pages/hot/hot?type=:type` | 热门推荐 | `onLoad`、滚动触底 | `getHotRecommendAPI` | 根据 `type` 映射到四个热门推荐子地址；支持分页追加 |
| 登录 | `/pages/login/login` | 登录 | 页面加载、点击登录 | `postLoginWxMinAPI`、`postLoginWxMinSimpleAPI`、`postLoginAPI`、`memberStore.setProfile` | 小程序端用 code + 手机号授权；H5 走账号密码 |
| 我的 | `/pages/my/my` | 我的 | 页面渲染、滚动触底 | `memberStore.profile`、`useGuessList -> getHomeGoodsGuessLikeAPI` | 不主动拉用户详情，直接读登录 Store；订单入口仅做跳转 |
| 购物车 | `/pages/cart/cart` | 购物车 | 页面显示、删改选中、结算 | `getMemberCartAPI`、`deleteMemberCartAPI`、`putMemberCartBySkuIdAPI`、`putMemberCartSelectedAPI`、`memberStore.profile` | 未登录展示登录引导；结算跳转订单确认页 |
| 购物车（安全区版） | `/pages/cart/cart2` | 购物车 | 同上 | 同 `cart.vue`，复用 `CartMain` | 商品详情底部入口跳该页面 |
| 用户协议 | `/pages/login/protocal` | 用户服务协议 | 静态页 | 无 | 不依赖后端 |

## 会员分包

| 页面 | 路由 | 标题 | 触发方式 | 调用接口 / Store | 说明 |
| --- | --- | --- | --- | --- | --- |
| 设置 | `/pagesMember/settings/settings` | 设置 | 点击退出 | `memberStore.clearProfile` | 只有本地退出，没有服务端登出接口 |
| 个人信息 | `/pagesMember/profile/profile` | 个人信息 | `onLoad`、保存、上传头像 | `getMemberProfileAPI`、`putMemberProfileAPI`、`uni.uploadFile('/member/profile/avatar')`、`memberStore.profile` | 头像和昵称会同步回 Store |
| 地址列表 | `/pagesMember/address/address` | 地址管理 | `onShow`、删除、点选地址 | `getMemberAddressAPI`、`deleteMemberAddressByIdAPI`、`addressStore.changeSelectedAddress` | 被订单确认页复用为地址选择器 |
| 地址表单 | `/pagesMember/address-form/address-form` | 新建地址/修改地址 | `onLoad`、提交表单 | `getMemberAddressByIdAPI`、`postMemberAddressAPI`、`putMemberAddressByIdAPI` | 表单含地区编码、默认地址标记和本地校验 |

## 订单分包

| 页面 | 路由 | 标题 | 触发方式 | 调用接口 / Store | 说明 |
| --- | --- | --- | --- | --- | --- |
| 订单确认 | `/pagesOrder/create/create` | 填写订单 | `onLoad`、提交订单 | `getMemberOrderPreAPI`、`getMemberOrderPreNowAPI`、`getMemberOrderRepurchaseByIdAPI`、`postMemberOrderAPI`、`addressStore.selectedAddress` | 支持购物车结算、立即购买、再次购买三种入口 |
| 订单详情 | `/pagesOrder/detail/detail?id=:id` | 订单详情 | `onLoad`、支付、取消、删除、确认收货、模拟发货 | `getMemberOrderByIdAPI`、`getMemberOrderLogisticsByIdAPI`、`getMemberOrderCancelByIdAPI`、`deleteMemberOrderAPI`、`putMemberOrderReceiptByIdAPI`、`getMemberOrderConsignmentByIdAPI`、`getPayMockAPI`、`getPayWxPayMiniPayAPI` | 真支付已预留但默认走模拟支付 |
| 支付结果 | `/pagesOrder/payment/payment?id=:id` | 支付结果 | `onLoad`、滚动触底 | `useGuessList -> getHomeGoodsGuessLikeAPI` | 页面仅展示模拟支付成功，不再请求订单结果 |
| 订单列表 | `/pagesOrder/list/list?type=:type` | 订单列表 | 首屏加载、下拉刷新、滚动触底、支付、收货、删除 | `getMemberOrderAPI`、`getPayMockAPI`、`getPayWxPayMiniPayAPI`、`putMemberOrderReceiptByIdAPI`、`deleteMemberOrderAPI` | 通过 tabs 切换 `orderState` 过滤 |

## 组件 / 组合式 / Store 间接映射

| 位置 | 间接关系 | 对后端的含义 |
| --- | --- | --- |
| `src/components/XtxGuess.vue` | 统一封装猜你喜欢分页 | `/home/goods/guessLike` 是多个页面共用基础能力 |
| `src/composables/index.ts` | `useGuessList` 仅驱动 `XtxGuess` 的 `getMore/resetData` | 页面层不会直接感知猜你喜欢 API |
| `src/stores/modules/member.ts` | 持久化 `LoginResult` 到本地存储 | 登录接口返回体必须稳定含 `token` 与基础用户资料 |
| `src/stores/modules/address.ts` | 缓存当前选中地址 | 订单预结算接口需返回地址列表，同时地址对象结构需与 Store 一致 |

## 页面行为到后端能力的归类

### home

- 首页轮播、分类、热门、猜你喜欢
- 热门推荐分页和子 tab 切换

### category / product

- 分类树加载
- 商品详情、SKU、同类推荐
- 详情页加购与立即购买

### auth / member

- 小程序授权登录、H5 表单登录、模拟登录
- 个人资料查询、更新、头像上传
- 本地登录态恢复与失效跳转

### address

- 地址增删改查
- 默认地址选取
- 订单页地址复用

### cart

- 购物车查询、删除、单项修改、全选切换
- 结算前基于选中项进入预订单

### order / pay

- 预订单、立即购买、再次购买
- 提交订单、订单详情、订单列表、取消、删除、确认收货、物流
- 支付参数获取与当前模拟支付流程
