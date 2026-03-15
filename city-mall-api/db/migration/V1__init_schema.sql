CREATE TABLE `category` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` bigint unsigned NOT NULL DEFAULT 0 COMMENT '父分类ID，一级分类为0',
  `name` varchar(64) NOT NULL COMMENT '分类名称',
  `icon` varchar(255) DEFAULT NULL COMMENT '分类图标',
  `picture` varchar(255) DEFAULT NULL COMMENT '分类图片',
  `level` tinyint unsigned NOT NULL COMMENT '层级：1一级 2二级',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序值',
  `is_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否展示',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_category_parent_id` (`parent_id`),
  KEY `idx_category_level_sort` (`level`, `sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类表';

CREATE TABLE `product` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `primary_category_id` bigint unsigned NOT NULL COMMENT '一级分类ID',
  `secondary_category_id` bigint unsigned NOT NULL COMMENT '二级分类ID',
  `name` varchar(128) NOT NULL COMMENT '商品名称',
  `desc` varchar(255) NOT NULL COMMENT '商品描述',
  `price` decimal(10,2) NOT NULL COMMENT '默认展示价格',
  `old_price` decimal(10,2) NOT NULL COMMENT '原价',
  `default_picture` varchar(255) NOT NULL COMMENT '默认主图',
  `status` tinyint unsigned NOT NULL DEFAULT 1 COMMENT '状态：1上架 2下架',
  `brand_name` varchar(64) DEFAULT NULL COMMENT '品牌名称',
  `sales_count` int unsigned NOT NULL DEFAULT 0 COMMENT '销量',
  `comment_count` int unsigned NOT NULL DEFAULT 0 COMMENT '评论数',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_product_primary_category_id` (`primary_category_id`),
  KEY `idx_product_secondary_category_id` (`secondary_category_id`),
  KEY `idx_product_status` (`status`),
  CONSTRAINT `fk_product_primary_category` FOREIGN KEY (`primary_category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `fk_product_secondary_category` FOREIGN KEY (`secondary_category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品SPU表';

CREATE TABLE `product_main_picture` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `picture` varchar(255) NOT NULL COMMENT '主图地址',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_product_main_picture_product_id` (`product_id`),
  CONSTRAINT `fk_product_main_picture_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品主图表';

CREATE TABLE `product_detail_picture` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `picture` varchar(255) NOT NULL COMMENT '详情图片地址',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_product_detail_picture_product_id` (`product_id`),
  CONSTRAINT `fk_product_detail_picture_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品详情图表';

CREATE TABLE `product_detail_property` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `name` varchar(64) NOT NULL COMMENT '属性名',
  `value` varchar(255) NOT NULL COMMENT '属性值',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_product_detail_property_product_id` (`product_id`),
  CONSTRAINT `fk_product_detail_property_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品详情属性表';

CREATE TABLE `product_spec` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `name` varchar(64) NOT NULL COMMENT '规格名',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_product_spec_product_id` (`product_id`),
  CONSTRAINT `fk_product_spec_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品规格组表';

CREATE TABLE `product_spec_value` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_spec_id` bigint unsigned NOT NULL COMMENT '规格组ID',
  `name` varchar(64) NOT NULL COMMENT '规格值名称',
  `picture` varchar(255) DEFAULT NULL COMMENT '规格图片',
  `descr` varchar(255) NOT NULL DEFAULT '' COMMENT '规格备注',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_product_spec_value_spec_id` (`product_spec_id`),
  CONSTRAINT `fk_product_spec_value_spec` FOREIGN KEY (`product_spec_id`) REFERENCES `product_spec` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品规格值表';

CREATE TABLE `product_sku` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `sku_code` varchar(64) NOT NULL COMMENT 'SKU编码',
  `price` decimal(10,2) NOT NULL COMMENT '售价',
  `old_price` decimal(10,2) NOT NULL COMMENT '原价',
  `inventory` int unsigned NOT NULL DEFAULT 0 COMMENT '库存',
  `picture` varchar(255) DEFAULT NULL COMMENT 'SKU图片',
  `attrs_text` varchar(255) NOT NULL COMMENT '规格文案快照',
  `status` tinyint unsigned NOT NULL DEFAULT 1 COMMENT '状态：1启用 2停用',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_sku_sku_code` (`sku_code`),
  KEY `idx_product_sku_product_id` (`product_id`),
  CONSTRAINT `fk_product_sku_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品SKU表';

CREATE TABLE `product_sku_value` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_sku_id` bigint unsigned NOT NULL COMMENT 'SKU ID',
  `product_spec_value_id` bigint unsigned NOT NULL COMMENT '规格值ID',
  `spec_name` varchar(64) NOT NULL COMMENT '规格名快照',
  `value_name` varchar(64) NOT NULL COMMENT '规格值快照',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_sku_value_unique` (`product_sku_id`, `product_spec_value_id`, `deleted`),
  KEY `idx_product_sku_value_spec_value_id` (`product_spec_value_id`),
  CONSTRAINT `fk_product_sku_value_sku` FOREIGN KEY (`product_sku_id`) REFERENCES `product_sku` (`id`),
  CONSTRAINT `fk_product_sku_value_spec_value` FOREIGN KEY (`product_spec_value_id`) REFERENCES `product_spec_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SKU与规格值映射表';

CREATE TABLE `cms_banner` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `distribution_site` tinyint unsigned NOT NULL COMMENT '投放位置：1首页 2分类页',
  `img_url` varchar(255) NOT NULL COMMENT '图片地址',
  `href_url` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转地址',
  `type` tinyint unsigned NOT NULL DEFAULT 1 COMMENT '跳转类型',
  `product_id` bigint unsigned DEFAULT NULL COMMENT '关联商品ID',
  `category_id` bigint unsigned DEFAULT NULL COMMENT '关联分类ID',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否展示',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_cms_banner_distribution_site` (`distribution_site`, `sort_order`),
  KEY `idx_cms_banner_product_id` (`product_id`),
  KEY `idx_cms_banner_category_id` (`category_id`),
  CONSTRAINT `fk_cms_banner_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `fk_cms_banner_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='轮播配置表';

CREATE TABLE `cms_hot_zone` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(32) NOT NULL COMMENT '专区编码',
  `title` varchar(64) NOT NULL COMMENT '标题',
  `alt` varchar(128) NOT NULL DEFAULT '' COMMENT '副标题',
  `target` varchar(128) NOT NULL DEFAULT '' COMMENT '跳转目标',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '业务类型',
  `banner_picture` varchar(255) DEFAULT NULL COMMENT '热门页封面',
  `pictures` json DEFAULT NULL COMMENT '首页热门图集',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否展示',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cms_hot_zone_code` (`code`),
  KEY `idx_cms_hot_zone_sort` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='热门专区表';

CREATE TABLE `cms_hot_zone_item` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `hot_zone_id` bigint unsigned NOT NULL COMMENT '专区ID',
  `sub_type` varchar(32) NOT NULL DEFAULT '' COMMENT '子分组编码',
  `sub_title` varchar(64) NOT NULL COMMENT '子分组标题',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_cms_hot_zone_item_zone_sub_type` (`hot_zone_id`, `sub_type`, `sort_order`),
  KEY `idx_cms_hot_zone_item_product_id` (`product_id`),
  CONSTRAINT `fk_cms_hot_zone_item_zone` FOREIGN KEY (`hot_zone_id`) REFERENCES `cms_hot_zone` (`id`),
  CONSTRAINT `fk_cms_hot_zone_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='热门专区商品表';

CREATE TABLE `member_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account` varchar(64) NOT NULL COMMENT '账号',
  `password_hash` varchar(255) DEFAULT NULL COMMENT '密码哈希',
  `mobile` varchar(20) NOT NULL COMMENT '手机号',
  `nickname` varchar(64) NOT NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `gender` varchar(16) NOT NULL DEFAULT '未知' COMMENT '性别',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `profession` varchar(64) NOT NULL DEFAULT '' COMMENT '职业',
  `province_code` varchar(20) DEFAULT NULL COMMENT '省编码',
  `city_code` varchar(20) DEFAULT NULL COMMENT '市编码',
  `county_code` varchar(20) DEFAULT NULL COMMENT '区县编码',
  `full_location` varchar(255) NOT NULL DEFAULT '' COMMENT '省市区文案',
  `openid` varchar(64) DEFAULT NULL COMMENT '微信OpenID',
  `union_id` varchar(64) DEFAULT NULL COMMENT '微信UnionID',
  `status` tinyint unsigned NOT NULL DEFAULT 1 COMMENT '状态',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_member_user_account` (`account`),
  UNIQUE KEY `uk_member_user_mobile` (`mobile`),
  UNIQUE KEY `uk_member_user_openid` (`openid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员表';

CREATE TABLE `member_address` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `member_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `receiver` varchar(64) NOT NULL COMMENT '收货人',
  `contact` varchar(20) NOT NULL COMMENT '联系方式',
  `province_code` varchar(20) NOT NULL COMMENT '省编码',
  `city_code` varchar(20) NOT NULL COMMENT '市编码',
  `county_code` varchar(20) NOT NULL COMMENT '区县编码',
  `full_location` varchar(255) NOT NULL COMMENT '省市区文案',
  `address` varchar(255) NOT NULL COMMENT '详细地址',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否默认地址',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_member_address_member_id` (`member_id`),
  KEY `idx_member_address_member_default` (`member_id`, `is_default`),
  CONSTRAINT `fk_member_address_member` FOREIGN KEY (`member_id`) REFERENCES `member_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员地址表';

CREATE TABLE `cart_item` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `member_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `sku_id` bigint unsigned NOT NULL COMMENT 'SKU ID',
  `name` varchar(128) NOT NULL COMMENT '商品名称快照',
  `picture` varchar(255) NOT NULL COMMENT '商品图片快照',
  `count` int unsigned NOT NULL COMMENT '数量',
  `price` decimal(10,2) NOT NULL COMMENT '加入时价格',
  `now_price` decimal(10,2) NOT NULL COMMENT '当前价格',
  `stock` int unsigned NOT NULL COMMENT '当前库存',
  `selected` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否选中',
  `attrs_text` varchar(255) NOT NULL COMMENT '规格文案',
  `is_effective` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否有效商品',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cart_item_member_sku` (`member_id`, `sku_id`, `deleted`),
  KEY `idx_cart_item_member_selected` (`member_id`, `selected`),
  CONSTRAINT `fk_cart_item_member` FOREIGN KEY (`member_id`) REFERENCES `member_user` (`id`),
  CONSTRAINT `fk_cart_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `fk_cart_item_sku` FOREIGN KEY (`sku_id`) REFERENCES `product_sku` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车项表';

CREATE TABLE `order_info` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `member_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `order_state` tinyint unsigned NOT NULL COMMENT '订单状态',
  `pay_type` tinyint unsigned NOT NULL COMMENT '支付方式',
  `pay_channel` tinyint unsigned NOT NULL COMMENT '支付渠道',
  `delivery_time_type` tinyint unsigned NOT NULL COMMENT '配送时间类型',
  `buyer_message` varchar(255) NOT NULL DEFAULT '' COMMENT '买家留言',
  `total_num` int unsigned NOT NULL COMMENT '商品总数',
  `total_money` decimal(10,2) NOT NULL COMMENT '商品总额',
  `post_fee` decimal(10,2) NOT NULL COMMENT '运费',
  `pay_money` decimal(10,2) NOT NULL COMMENT '实付金额',
  `receiver_contact` varchar(64) NOT NULL COMMENT '收货人',
  `receiver_mobile` varchar(20) NOT NULL COMMENT '收货手机号',
  `receiver_address` varchar(255) NOT NULL COMMENT '收货地址全文',
  `pay_latest_time` datetime(3) DEFAULT NULL COMMENT '最晚支付时间',
  `pay_time` datetime(3) DEFAULT NULL COMMENT '支付时间',
  `consign_time` datetime(3) DEFAULT NULL COMMENT '发货时间',
  `receipt_time` datetime(3) DEFAULT NULL COMMENT '确认收货时间',
  `end_time` datetime(3) DEFAULT NULL COMMENT '完成时间',
  `close_time` datetime(3) DEFAULT NULL COMMENT '关闭时间',
  `cancel_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '取消原因',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_order_info_member_state` (`member_id`, `order_state`),
  KEY `idx_order_info_pay_latest_time` (`pay_latest_time`),
  CONSTRAINT `fk_order_info_member` FOREIGN KEY (`member_id`) REFERENCES `member_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单主表';

CREATE TABLE `order_item` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id` bigint unsigned NOT NULL COMMENT '订单ID',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `sku_id` bigint unsigned NOT NULL COMMENT 'SKU ID',
  `name` varchar(128) NOT NULL COMMENT '商品名称快照',
  `image` varchar(255) NOT NULL COMMENT '商品图片快照',
  `attrs_text` varchar(255) NOT NULL COMMENT '规格文案快照',
  `quantity` int unsigned NOT NULL COMMENT '数量',
  `cur_price` decimal(10,2) NOT NULL COMMENT '当前单价',
  `real_pay` decimal(10,2) NOT NULL COMMENT '实付单价',
  `total_money` decimal(10,2) NOT NULL COMMENT '小计金额',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_order_item_order_id` (`order_id`),
  KEY `idx_order_item_product_id` (`product_id`),
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `order_info` (`id`),
  CONSTRAINT `fk_order_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `fk_order_item_sku` FOREIGN KEY (`sku_id`) REFERENCES `product_sku` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单明细表';

CREATE TABLE `order_logistics` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id` bigint unsigned NOT NULL COMMENT '订单ID',
  `company_name` varchar(64) NOT NULL COMMENT '物流公司名称',
  `logistics_no` varchar(64) NOT NULL COMMENT '物流单号',
  `company_tel` varchar(32) NOT NULL DEFAULT '' COMMENT '物流联系电话',
  `trace_count` int unsigned NOT NULL DEFAULT 0 COMMENT '轨迹数量',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_logistics_order_id` (`order_id`, `deleted`),
  CONSTRAINT `fk_order_logistics_order` FOREIGN KEY (`order_id`) REFERENCES `order_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单物流主表';

CREATE TABLE `order_logistics_trace` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `logistics_id` bigint unsigned NOT NULL COMMENT '物流主记录ID',
  `text` varchar(255) NOT NULL COMMENT '轨迹文案',
  `trace_time` datetime(3) NOT NULL COMMENT '轨迹时间',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_order_logistics_trace_logistics_id` (`logistics_id`),
  CONSTRAINT `fk_order_logistics_trace_logistics` FOREIGN KEY (`logistics_id`) REFERENCES `order_logistics` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单物流轨迹表';

CREATE TABLE `payment_record` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id` bigint unsigned NOT NULL COMMENT '订单ID',
  `member_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `pay_channel` tinyint unsigned NOT NULL COMMENT '支付渠道',
  `pay_type` tinyint unsigned NOT NULL COMMENT '支付方式',
  `pay_status` tinyint unsigned NOT NULL COMMENT '支付状态',
  `amount` decimal(10,2) NOT NULL COMMENT '支付金额',
  `out_trade_no` varchar(64) NOT NULL COMMENT '本系统支付单号',
  `transaction_no` varchar(64) DEFAULT NULL COMMENT '第三方交易流水号',
  `pay_time` datetime(3) DEFAULT NULL COMMENT '支付成功时间',
  `callback_time` datetime(3) DEFAULT NULL COMMENT '回调时间',
  `pay_payload` json DEFAULT NULL COMMENT '支付请求报文',
  `callback_payload` json DEFAULT NULL COMMENT '回调报文',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_payment_record_out_trade_no` (`out_trade_no`),
  KEY `idx_payment_record_order_id` (`order_id`),
  KEY `idx_payment_record_member_id` (`member_id`),
  CONSTRAINT `fk_payment_record_order` FOREIGN KEY (`order_id`) REFERENCES `order_info` (`id`),
  CONSTRAINT `fk_payment_record_member` FOREIGN KEY (`member_id`) REFERENCES `member_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付记录表';
