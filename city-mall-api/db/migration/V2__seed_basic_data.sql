INSERT INTO `category` (`id`, `parent_id`, `name`, `icon`, `picture`, `level`, `sort_order`, `is_show`)
VALUES
  (1001, 0, '居家生活', 'https://cdn.citymall.example/category/icon-home.png', 'https://cdn.citymall.example/category/p-home.jpg', 1, 1, 1),
  (1002, 0, '美味餐厨', 'https://cdn.citymall.example/category/icon-kitchen.png', 'https://cdn.citymall.example/category/p-kitchen.jpg', 1, 2, 1),
  (1003, 0, '轻奢家纺', 'https://cdn.citymall.example/category/icon-textile.png', 'https://cdn.citymall.example/category/p-textile.jpg', 1, 3, 1),
  (1004, 0, '智能电器', 'https://cdn.citymall.example/category/icon-appliance.png', 'https://cdn.citymall.example/category/p-appliance.jpg', 1, 4, 1),
  (1101, 1001, '香氛摆件', NULL, 'https://cdn.citymall.example/category/c-aroma.jpg', 2, 1, 1),
  (1102, 1001, '灯饰家具', NULL, 'https://cdn.citymall.example/category/c-lamp.jpg', 2, 2, 1),
  (1201, 1002, '咖啡器具', NULL, 'https://cdn.citymall.example/category/c-coffee.jpg', 2, 1, 1),
  (1202, 1002, '杯壶餐具', NULL, 'https://cdn.citymall.example/category/c-cup.jpg', 2, 2, 1),
  (1301, 1003, '卧室床品', NULL, 'https://cdn.citymall.example/category/c-bedding.jpg', 2, 1, 1),
  (1302, 1003, '布艺靠垫', NULL, 'https://cdn.citymall.example/category/c-cushion.jpg', 2, 2, 1),
  (1401, 1004, '厨房电器', NULL, 'https://cdn.citymall.example/category/c-blender.jpg', 2, 1, 1),
  (1402, 1004, '氛围灯具', NULL, 'https://cdn.citymall.example/category/c-light.jpg', 2, 2, 1);

INSERT INTO `product` (`id`, `primary_category_id`, `secondary_category_id`, `name`, `desc`, `price`, `old_price`, `default_picture`, `status`, `brand_name`, `sales_count`, `comment_count`)
VALUES
  (2001, 1002, 1201, '云雾手冲咖啡套装', '耐热玻璃壶搭配细口壶，适合晨间手冲和节日送礼。', 269.00, 329.00, 'https://cdn.citymall.example/product/coffee-set/main-1.jpg', 1, 'Cloud Brew', 1860, 126),
  (2002, 1002, 1202, '月白陶瓷马克杯', '雾面釉感与大容量设计，适合办公室和居家日常。', 59.00, 79.00, 'https://cdn.citymall.example/product/mug/main-1.jpg', 1, 'Moon Clay', 2540, 88),
  (2003, 1001, 1101, '琥珀木质香薰蜡烛', '木芯轻响，适合夜读和卧室放松场景。', 99.00, 139.00, 'https://cdn.citymall.example/product/candle/main-1.jpg', 1, 'Amber Home', 1320, 74),
  (2004, 1003, 1301, '暖砂纯棉四件套', '长绒棉触感柔软，适合秋冬卧室氛围升级。', 459.00, 599.00, 'https://cdn.citymall.example/product/bedding/main-1.jpg', 1, 'SoftNest', 980, 53),
  (2005, 1004, 1401, '便携轻音榨汁杯', '一键榨汁，适合办公室水果杯和健身补给。', 199.00, 259.00, 'https://cdn.citymall.example/product/blender/main-1.jpg', 1, 'Fresh Go', 1675, 91),
  (2006, 1001, 1102, '北欧极简落地灯', '暖光无频闪，适合客厅阅读角和卧室氛围照明。', 399.00, 499.00, 'https://cdn.citymall.example/product/floor-lamp/main-1.jpg', 1, 'North Room', 846, 47);

INSERT INTO `product_main_picture` (`id`, `product_id`, `picture`, `sort_order`)
VALUES
  (3001, 2001, 'https://cdn.citymall.example/product/coffee-set/main-1.jpg', 1),
  (3002, 2001, 'https://cdn.citymall.example/product/coffee-set/main-2.jpg', 2),
  (3003, 2001, 'https://cdn.citymall.example/product/coffee-set/main-3.jpg', 3),
  (3004, 2002, 'https://cdn.citymall.example/product/mug/main-1.jpg', 1),
  (3005, 2002, 'https://cdn.citymall.example/product/mug/main-2.jpg', 2),
  (3006, 2002, 'https://cdn.citymall.example/product/mug/main-3.jpg', 3),
  (3007, 2003, 'https://cdn.citymall.example/product/candle/main-1.jpg', 1),
  (3008, 2003, 'https://cdn.citymall.example/product/candle/main-2.jpg', 2),
  (3009, 2003, 'https://cdn.citymall.example/product/candle/main-3.jpg', 3),
  (3010, 2004, 'https://cdn.citymall.example/product/bedding/main-1.jpg', 1),
  (3011, 2004, 'https://cdn.citymall.example/product/bedding/main-2.jpg', 2),
  (3012, 2004, 'https://cdn.citymall.example/product/bedding/main-3.jpg', 3),
  (3013, 2005, 'https://cdn.citymall.example/product/blender/main-1.jpg', 1),
  (3014, 2005, 'https://cdn.citymall.example/product/blender/main-2.jpg', 2),
  (3015, 2005, 'https://cdn.citymall.example/product/blender/main-3.jpg', 3),
  (3016, 2006, 'https://cdn.citymall.example/product/floor-lamp/main-1.jpg', 1),
  (3017, 2006, 'https://cdn.citymall.example/product/floor-lamp/main-2.jpg', 2),
  (3018, 2006, 'https://cdn.citymall.example/product/floor-lamp/main-3.jpg', 3);

INSERT INTO `product_detail_picture` (`id`, `product_id`, `picture`, `sort_order`)
VALUES
  (4001, 2001, 'https://cdn.citymall.example/product/coffee-set/detail-1.jpg', 1),
  (4002, 2001, 'https://cdn.citymall.example/product/coffee-set/detail-2.jpg', 2),
  (4003, 2002, 'https://cdn.citymall.example/product/mug/detail-1.jpg', 1),
  (4004, 2002, 'https://cdn.citymall.example/product/mug/detail-2.jpg', 2),
  (4005, 2003, 'https://cdn.citymall.example/product/candle/detail-1.jpg', 1),
  (4006, 2003, 'https://cdn.citymall.example/product/candle/detail-2.jpg', 2),
  (4007, 2004, 'https://cdn.citymall.example/product/bedding/detail-1.jpg', 1),
  (4008, 2004, 'https://cdn.citymall.example/product/bedding/detail-2.jpg', 2),
  (4009, 2005, 'https://cdn.citymall.example/product/blender/detail-1.jpg', 1),
  (4010, 2005, 'https://cdn.citymall.example/product/blender/detail-2.jpg', 2),
  (4011, 2006, 'https://cdn.citymall.example/product/floor-lamp/detail-1.jpg', 1),
  (4012, 2006, 'https://cdn.citymall.example/product/floor-lamp/detail-2.jpg', 2);

INSERT INTO `product_detail_property` (`id`, `product_id`, `name`, `value`, `sort_order`)
VALUES
  (5001, 2001, '材质', '高硼硅玻璃 / 304不锈钢', 1),
  (5002, 2001, '容量', '600ml', 2),
  (5003, 2001, '适用场景', '家庭手冲 / 咖啡角陈列', 3),
  (5004, 2002, '材质', '高温陶瓷', 1),
  (5005, 2002, '容量', '420ml', 2),
  (5006, 2002, '适用场景', '办公桌 / 早餐杯', 3),
  (5007, 2003, '香调', '雪松 / 琥珀 / 香草', 1),
  (5008, 2003, '燃烧时长', '约45小时', 2),
  (5009, 2003, '适用空间', '卧室 / 书房', 3),
  (5010, 2004, '面料', '100%长绒棉', 1),
  (5011, 2004, '工艺', '活性印染', 2),
  (5012, 2004, '适用季节', '四季通用', 3),
  (5013, 2005, '杯体容量', '380ml', 1),
  (5014, 2005, '电池', '1500mAh', 2),
  (5015, 2005, '特点', '轻音榨汁 / 一键清洗', 3),
  (5016, 2006, '光源', 'LED暖光', 1),
  (5017, 2006, '高度', '158cm', 2),
  (5018, 2006, '适用场景', '客厅 / 卧室阅读角', 3);

INSERT INTO `product_spec` (`id`, `product_id`, `name`, `sort_order`)
VALUES
  (6001, 2001, '颜色', 1),
  (6002, 2001, '容量', 2),
  (6003, 2002, '颜色', 1),
  (6004, 2002, '规格', 2),
  (6005, 2003, '香型', 1),
  (6006, 2003, '规格', 2),
  (6007, 2004, '颜色', 1),
  (6008, 2004, '尺寸', 2),
  (6009, 2005, '颜色', 1),
  (6010, 2005, '规格', 2),
  (6011, 2006, '颜色', 1),
  (6012, 2006, '版本', 2);

INSERT INTO `product_spec_value` (`id`, `product_spec_id`, `name`, `picture`, `descr`, `sort_order`)
VALUES
  (7001, 6001, '晨雾灰', 'https://cdn.citymall.example/product/coffee-set/spec-grey.jpg', '玻璃壶灰色系', 1),
  (7002, 6001, '云杉绿', 'https://cdn.citymall.example/product/coffee-set/spec-green.jpg', '金属壶墨绿系', 2),
  (7003, 6002, '600ml', NULL, '双人分享装', 1),
  (7004, 6003, '月白', 'https://cdn.citymall.example/product/mug/spec-white.jpg', '温润奶白色', 1),
  (7005, 6003, '海盐蓝', 'https://cdn.citymall.example/product/mug/spec-blue.jpg', '低饱和蓝', 2),
  (7006, 6004, '420ml', NULL, '大容量', 1),
  (7007, 6005, '雪松琥珀', NULL, '木质暖香', 1),
  (7008, 6005, '白茶铃兰', NULL, '清新花香', 2),
  (7009, 6006, '220g', NULL, '标准杯', 1),
  (7010, 6007, '暖砂', 'https://cdn.citymall.example/product/bedding/spec-sand.jpg', '奶咖色调', 1),
  (7011, 6007, '暮山灰', 'https://cdn.citymall.example/product/bedding/spec-grey.jpg', '高级灰色', 2),
  (7012, 6008, '1.5m床', NULL, '被套200x230cm', 1),
  (7013, 6008, '1.8m床', NULL, '被套220x240cm', 2),
  (7014, 6009, '奶油白', 'https://cdn.citymall.example/product/blender/spec-white.jpg', '轻盈配色', 1),
  (7015, 6009, '薄荷绿', 'https://cdn.citymall.example/product/blender/spec-green.jpg', '清新配色', 2),
  (7016, 6010, '380ml', NULL, '随行杯版本', 1),
  (7017, 6011, '沙砾米', 'https://cdn.citymall.example/product/floor-lamp/spec-beige.jpg', '百搭暖米色', 1),
  (7018, 6011, '曜石黑', 'https://cdn.citymall.example/product/floor-lamp/spec-black.jpg', '现代黑色', 2),
  (7019, 6012, '基础版', NULL, '单色温', 1),
  (7020, 6012, '调光版', NULL, '三档调光', 2);

INSERT INTO `product_sku` (`id`, `product_id`, `sku_code`, `price`, `old_price`, `inventory`, `picture`, `attrs_text`, `status`)
VALUES
  (8001, 2001, 'CS-600-GREY', 269.00, 329.00, 96, 'https://cdn.citymall.example/product/coffee-set/spec-grey.jpg', '颜色:晨雾灰 容量:600ml', 1),
  (8002, 2001, 'CS-600-GREEN', 279.00, 339.00, 82, 'https://cdn.citymall.example/product/coffee-set/spec-green.jpg', '颜色:云杉绿 容量:600ml', 1),
  (8003, 2002, 'MUG-420-WHITE', 59.00, 79.00, 240, 'https://cdn.citymall.example/product/mug/spec-white.jpg', '颜色:月白 规格:420ml', 1),
  (8004, 2002, 'MUG-420-BLUE', 59.00, 79.00, 180, 'https://cdn.citymall.example/product/mug/spec-blue.jpg', '颜色:海盐蓝 规格:420ml', 1),
  (8005, 2003, 'CAN-220-CEDAR', 99.00, 139.00, 120, 'https://cdn.citymall.example/product/candle/main-1.jpg', '香型:雪松琥珀 规格:220g', 1),
  (8006, 2003, 'CAN-220-TEA', 109.00, 149.00, 88, 'https://cdn.citymall.example/product/candle/main-2.jpg', '香型:白茶铃兰 规格:220g', 1),
  (8007, 2004, 'BED-15-SAND', 459.00, 599.00, 65, 'https://cdn.citymall.example/product/bedding/spec-sand.jpg', '颜色:暖砂 尺寸:1.5m床', 1),
  (8008, 2004, 'BED-18-GREY', 499.00, 639.00, 52, 'https://cdn.citymall.example/product/bedding/spec-grey.jpg', '颜色:暮山灰 尺寸:1.8m床', 1),
  (8009, 2005, 'BL-380-WHITE', 199.00, 259.00, 130, 'https://cdn.citymall.example/product/blender/spec-white.jpg', '颜色:奶油白 规格:380ml', 1),
  (8010, 2005, 'BL-380-GREEN', 199.00, 259.00, 114, 'https://cdn.citymall.example/product/blender/spec-green.jpg', '颜色:薄荷绿 规格:380ml', 1),
  (8011, 2006, 'LAMP-BASIC-BEIGE', 399.00, 499.00, 44, 'https://cdn.citymall.example/product/floor-lamp/spec-beige.jpg', '颜色:沙砾米 版本:基础版', 1),
  (8012, 2006, 'LAMP-DIM-BLACK', 459.00, 559.00, 36, 'https://cdn.citymall.example/product/floor-lamp/spec-black.jpg', '颜色:曜石黑 版本:调光版', 1);

INSERT INTO `product_sku_value` (`id`, `product_sku_id`, `product_spec_value_id`, `spec_name`, `value_name`)
VALUES
  (9001, 8001, 7001, '颜色', '晨雾灰'),
  (9002, 8001, 7003, '容量', '600ml'),
  (9003, 8002, 7002, '颜色', '云杉绿'),
  (9004, 8002, 7003, '容量', '600ml'),
  (9005, 8003, 7004, '颜色', '月白'),
  (9006, 8003, 7006, '规格', '420ml'),
  (9007, 8004, 7005, '颜色', '海盐蓝'),
  (9008, 8004, 7006, '规格', '420ml'),
  (9009, 8005, 7007, '香型', '雪松琥珀'),
  (9010, 8005, 7009, '规格', '220g'),
  (9011, 8006, 7008, '香型', '白茶铃兰'),
  (9012, 8006, 7009, '规格', '220g'),
  (9013, 8007, 7010, '颜色', '暖砂'),
  (9014, 8007, 7012, '尺寸', '1.5m床'),
  (9015, 8008, 7011, '颜色', '暮山灰'),
  (9016, 8008, 7013, '尺寸', '1.8m床'),
  (9017, 8009, 7014, '颜色', '奶油白'),
  (9018, 8009, 7016, '规格', '380ml'),
  (9019, 8010, 7015, '颜色', '薄荷绿'),
  (9020, 8010, 7016, '规格', '380ml'),
  (9021, 8011, 7017, '颜色', '沙砾米'),
  (9022, 8011, 7019, '版本', '基础版'),
  (9023, 8012, 7018, '颜色', '曜石黑'),
  (9024, 8012, 7020, '版本', '调光版');

INSERT INTO `cms_banner` (`id`, `distribution_site`, `img_url`, `href_url`, `type`, `product_id`, `category_id`, `sort_order`, `is_show`)
VALUES
  (10001, 1, 'https://cdn.citymall.example/banner/home-1.jpg', '/pages/goods/goods?id=2004', 1, 2004, NULL, 1, 1),
  (10002, 1, 'https://cdn.citymall.example/banner/home-2.jpg', '/pages/goods/goods?id=2001', 1, 2001, NULL, 2, 1),
  (10003, 1, 'https://cdn.citymall.example/banner/home-3.jpg', '/pages/hot/hot?type=1', 2, NULL, NULL, 3, 1),
  (10004, 2, 'https://cdn.citymall.example/banner/category-1.jpg', '/pages/category/category', 2, NULL, 1002, 1, 1),
  (10005, 2, 'https://cdn.citymall.example/banner/category-2.jpg', '/pages/goods/goods?id=2005', 1, 2005, NULL, 2, 1);

INSERT INTO `cms_hot_zone` (`id`, `code`, `title`, `alt`, `target`, `type`, `banner_picture`, `pictures`, `sort_order`, `is_show`)
VALUES
  (11001, 'preference', '特惠推荐', '本周精选好物', '/pages/hot/hot?type=1', '1', 'https://cdn.citymall.example/hot/preference-banner.jpg', JSON_ARRAY('https://cdn.citymall.example/hot/preference-card-1.jpg', 'https://cdn.citymall.example/hot/preference-card-2.jpg'), 1, 1),
  (11002, 'inVogue', '爆款推荐', '热卖榜单同步更新', '/pages/hot/hot?type=2', '2', 'https://cdn.citymall.example/hot/invogue-banner.jpg', JSON_ARRAY('https://cdn.citymall.example/hot/invogue-card-1.jpg', 'https://cdn.citymall.example/hot/invogue-card-2.jpg'), 2, 1),
  (11003, 'oneStop', '一站买全', '空间搭配灵感集合', '/pages/hot/hot?type=3', '3', 'https://cdn.citymall.example/hot/onestop-banner.jpg', JSON_ARRAY('https://cdn.citymall.example/hot/onestop-card-1.jpg', 'https://cdn.citymall.example/hot/onestop-card-2.jpg'), 3, 1),
  (11004, 'new', '新品首发', '新到商品抢先看', '/pages/hot/hot?type=4', '4', 'https://cdn.citymall.example/hot/new-banner.jpg', JSON_ARRAY('https://cdn.citymall.example/hot/new-card-1.jpg', 'https://cdn.citymall.example/hot/new-card-2.jpg'), 4, 1);

INSERT INTO `cms_hot_zone_item` (`id`, `hot_zone_id`, `sub_type`, `sub_title`, `product_id`, `sort_order`)
VALUES
  (12001, 11001, 'limited', '限时好价', 2001, 1),
  (12002, 11001, 'limited', '限时好价', 2003, 2),
  (12003, 11001, 'bundle', '居家成套', 2004, 1),
  (12004, 11001, 'bundle', '居家成套', 2006, 2),
  (12005, 11002, 'rank', '热卖榜单', 2002, 1),
  (12006, 11002, 'rank', '热卖榜单', 2005, 2),
  (12007, 11002, 'editor', '编辑优选', 2001, 1),
  (12008, 11002, 'editor', '编辑优选', 2004, 2),
  (12009, 11003, 'living', '客厅氛围', 2006, 1),
  (12010, 11003, 'living', '客厅氛围', 2003, 2),
  (12011, 11003, 'kitchen', '厨房焕新', 2001, 1),
  (12012, 11003, 'kitchen', '厨房焕新', 2005, 2),
  (12013, 11004, 'fresh', '本周上新', 2005, 1),
  (12014, 11004, 'fresh', '本周上新', 2006, 2),
  (12015, 11004, 'soft', '卧室新选', 2004, 1),
  (12016, 11004, 'soft', '卧室新选', 2002, 2);
