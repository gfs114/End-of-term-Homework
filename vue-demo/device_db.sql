create user 'shop_user'@'localhost' identified by '123456';
grant all privileges on device_db.* to 'shop_user'@'localhost';
flush privileges;
create database device_db;
use device_db;
/*
 Navicat Premium Dump SQL

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3306
 Source Schema         : device_db

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 16/06/2026 22:18:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admins
-- ----------------------------
DROP TABLE IF EXISTS `admins`;
CREATE TABLE `admins`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'ADMIN',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admins
-- ----------------------------
INSERT INTO `admins` VALUES (1, 'admin1', '123456', 'cole36620@gmail.com', 'ADMIN', '2026-05-14 14:17:05');
INSERT INTO `admins` VALUES (3, 'gin1', '1234567', NULL, 'ADMIN', '2026-05-20 08:20:45');

-- ----------------------------
-- Table structure for articles
-- ----------------------------
DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `views` int NULL DEFAULT 0,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `favorites` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of articles
-- ----------------------------
INSERT INTO `articles` VALUES (1, 'iPhone 15 配置介绍', '这里是 iPhone 15 的详细配置介绍。', 'gin', '手机', 2, 'published', '2026-05-20 03:28:31', '2026-06-12 05:32:54', 1);
INSERT INTO `articles` VALUES (2, '小米 14 值得买吗', '这里是小米 14 的性能、屏幕、影像和续航分析。', 'admin', '手机', 1, 'published', '2026-05-20 03:28:31', '2026-05-27 03:23:14', 0);
INSERT INTO `articles` VALUES (3, '游戏本怎么选', '这里是适合学生党的游戏本选购建议。', 'admin', '电脑', 1, 'published', '2026-05-20 03:28:31', '2026-05-20 08:41:50', 0);
INSERT INTO `articles` VALUES (4, 'HUAWEI Pura X Max配置介绍', '这里是HUAWEI Pura X Max的文章内容，主要介绍处理器、屏幕、影像、续航和购买建议。', 'gin', '手机', 5, 'published', '2026-05-20 05:22:43', '2026-05-20 09:57:25', 1);
INSERT INTO `articles` VALUES (5, 'zz\'z', '暗码编号:6，消逝于梦境之中。\n\n面对可怖的暗码:梦境的力量，还有毫不留情肃清6的冷酷的3，万津莫束手无策，只能交出全场瞩目梦胶囊 ——\n\n长此以往，整个世界难道都会被暗码彻底管控吗。\n\n但世上还有一位特工，不会受到暗码:梦境篡改能力的影响。\n\n此人便是最痛恨暗码种种恶行的诺克斯。\n\n如今，诺克斯与3的决战，正式打响！\n\n（文责：凑阳祐）\n\n下集看点\n梦魇，再度袭来\n\n“让你的预知梦成真吧。”\n\n对万津莫说出这句话的3，即将完成禁忌的极致强化。他究竟会以何种方式觉醒为领主3增压增幅形态？\n\n他与诺克斯之间的生死激战，留到下一集揭晓。\n\n目前正在发动的暗码:梦境，拥有这些特性：\n\n全世界所有人的梦境彼此相连\n\n暗码管控所有梦境，使人不再受梦魇侵扰\n\n人们关于梦魇的记忆、感知与心绪，都会被暗码篡改，也就是所谓的清空思绪\n\n完成梦中学习法的修成之人，不会受到这份力量影响\n\n这套和以往梦的法则截然相反的机制，已然成为3眼中极致的安全体系。\n\n可无论是高举旗帜反抗暗码的诺克斯，还是亲眼见证6逝去、连宁梦的存在都遭到否定的万津莫，都绝不会接受这份虚假的安稳。\n\n一心要帮万津莫达成预知梦的3，对阵依靠预知梦攻入暗码阵营的诺克斯。\n\n而决心守护梦境自由与宁梦的万津莫，也已然坚定心志。\n\n各方信念激烈碰撞，第三十六集不容错过。\n\n话说西格为什么会出现？\n\n（文责：谷中寿成）\n\n关系图', 'user001', '手机', 5, 'draft', '2026-05-20 14:32:05', '2026-05-31 12:00:48', 1);
INSERT INTO `articles` VALUES (6, 'テガソード纪念版最终规格公开', '万代超级战队玩具官方更新了「テガソード -MEMORIAL EDITION-」预约截止前的最终规格介绍。该商品面向喜欢收藏纪念版变身道具的玩家，重点展示了纪念版规格、音效与外观细节，适合作为超级战队收藏向玩具资讯。', 'user001', '超级战队玩具', 1, 'published', '2026-05-25 12:32:32', '2026-05-27 04:45:11', 0);
INSERT INTO `articles` VALUES (7, 'プラデラNEO系列玩具集中介绍', '万代官方超级战队玩具专栏更新了「プラデラNEO」系列介绍内容。本次内容集中展示该系列的新商品方向，适合关注最新战队机体、变形玩法和系列收藏的玩家参考。', 'admin', '超级战队玩具', 0, 'published', '2026-05-25 12:32:32', '2026-05-25 12:32:32', 0);
INSERT INTO `articles` VALUES (8, 'デス・ギャバン相关道具公开', '官方玩具专栏公开了「デス・ギャバン」相关玩具内容，介绍了角色相关道具与商品信息。该类产品适合喜欢宇宙刑事、战队联动与角色收藏的用户关注。', 'gin', '超级战队玩具', 1, 'published', '2026-05-25 12:32:32', '2026-05-25 12:50:11', 0);
INSERT INTO `articles` VALUES (9, 'ギャバンインフィニティ6月新玩具情报', '万代官方公开了「超宇宙刑事ギャバン インフィニティ」6月发售相关玩具情报。内容包含最新玩具公开、发售信息和系列商品方向，适合想追新商品的用户查看。', 'manba', '超级战队玩具', 0, 'published', '2026-05-25 12:32:32', '2026-05-25 12:44:01', 0);
INSERT INTO `articles` VALUES (10, '忍者戦隊カクレンジャーカクレマル登场', '「忍者戦隊カクレンジャー」中的忍者刀「カクレマル」推出面向成人玩家的变身/角色扮演类玩具。该商品适合喜欢经典超级战队、忍者题材和高还原收藏玩具的玩家。', 'manba', '超级战队玩具', 1, 'published', '2026-05-25 12:32:32', '2026-05-27 04:45:29', 0);
INSERT INTO `articles` VALUES (11, 'DXエモルギアギャバンライヤセット介绍', 'PROJECT R.E.D. 开发博客介绍了「DXエモルギア ギャバン・ライヤセット」及相关人偶内容。该资讯适合关注联动道具、音效玩法和收藏配件的超级战队玩具玩家。', 'admin', '超级战队玩具', 0, 'published', '2026-05-25 12:32:32', '2026-05-25 12:32:32', 0);
INSERT INTO `articles` VALUES (12, 'DXギャバリオンドルネード玩法公开', '万代官方开发博客公开了「DXギャバリオンドルネード」以及相关购买特典活动信息。该内容适合想了解最新DX玩具玩法和活动赠品的用户阅读。', 'manba', '超级战队玩具', 2, 'published', '2026-05-25 12:32:32', '2026-05-27 04:44:16', 0);
INSERT INTO `articles` VALUES (13, 'DXエモルギアセット07情报整理', 'PROJECT R.E.D. 开发博客介绍了「DXエモルギアセット07」以及随机盒相关内容。该类商品适合喜欢收集联动配件、盲盒和系列扩展玩法的玩家。', 'manba', '超级战队玩具', 0, 'published', '2026-05-25 12:32:32', '2026-05-25 12:44:08', 0);
INSERT INTO `articles` VALUES (14, 'エモルギアGETキャンペーン开启', '官方公开了「超宇宙刑事ギャバン インフィニティ」エモルギアGETキャンペーン活动信息。玩家可以通过活动获取特别款エモルギア，适合关注限定赠品和活动收藏的用户。', 'admin', '超级战队玩具', 1, 'published', '2026-05-25 12:32:32', '2026-05-25 12:58:49', 0);
INSERT INTO `articles` VALUES (15, 'DXオルカブースター5050黑色版登场', '「ナンバーワン戦隊ゴジュウジャー」推出 DXオルカブースター5050 黑色版本，并附带限定センタイリング。该商品适合喜欢ゴジュウジャー、限定配色和变身道具收藏的玩家。', 'admin', '超级战队玩具', 3, 'published', '2026-05-25 12:32:32', '2026-06-10 04:57:40', 0);
INSERT INTO `articles` VALUES (16, '小米17T系列确认徕卡5倍长焦', '小米17T系列近期确认将搭载徕卡调校的5倍长焦镜头，标准版也会获得这一影像升级。该系列预计继续主打高性能和影像体验，适合关注拍照、视频记录和旗舰配置的用户。', 'admin', '国产手机资讯', 0, 'published', '2026-05-25 12:34:39', '2026-05-25 12:34:39', 0);
INSERT INTO `articles` VALUES (17, '小米17T即将发布，T系列重回高端视野', '小米17T计划在海外市场发布，重点升级影像系统和旗舰级体验。对于喜欢小米生态、徕卡影像和高性价比旗舰的用户来说，这一系列值得关注。', 'admin', '国产手机资讯', 0, 'published', '2026-05-25 12:34:39', '2026-05-25 12:34:39', 0);
INSERT INTO `articles` VALUES (18, 'OPPO Find X9 Ultra亮相，继续冲击高端旗舰市场', 'OPPO Find X9 Ultra近期发布，定位高端旗舰，主打大屏、高性能处理器、强影像系统和长续航体验。该机体现了OPPO继续向高端市场发力的产品策略。', 'admin', '国产手机资讯', 1, 'published', '2026-05-25 12:34:39', '2026-05-27 04:45:21', 0);
INSERT INTO `articles` VALUES (19, 'OPPO Find X9s发布，主打更亲民的旗舰体验', 'OPPO Find X9s作为Find X9系列的新成员，定位比Ultra更亲民，但依然保留了较强的性能、屏幕和影像配置，适合想要旗舰体验但预算相对有限的用户。', 'gin', '国产手机资讯', 4, 'published', '2026-05-25 12:34:39', '2026-06-10 03:19:34', 0);
INSERT INTO `articles` VALUES (20, '荣耀Robot Phone计划Q3率先在中国发布', '荣耀Robot Phone概念机计划在2026年第三季度率先于中国市场发布。该机最大特点是配备可伸出的云台相机结构，并结合影像合作技术，面向喜欢拍摄和创新形态手机的用户。', 'gin', '国产手机资讯', 0, 'published', '2026-05-25 12:34:39', '2026-05-25 12:44:20', 0);
INSERT INTO `articles` VALUES (21, '华为继续领跑中国手机市场', '市场研究数据显示，华为在2026年第一季度以20%的份额领跑中国智能手机市场，达到近年来较高水平。Mate系列供货改善和鸿蒙生态推进，是华为保持竞争力的重要原因。', 'user001', '国产手机资讯', 0, 'published', '2026-05-25 12:34:39', '2026-05-25 12:44:24', 0);
INSERT INTO `articles` VALUES (22, '国产手机影像竞争进入长焦时代', '从小米、OPPO、vivo、荣耀等品牌近期产品方向来看，长焦镜头和影像算法已经成为国产手机竞争重点。5倍长焦、潜望式镜头和影像联名方案正在逐渐成为旗舰机标配。', 'admin', '国产手机资讯', 0, 'published', '2026-05-25 12:34:39', '2026-05-25 12:34:39', 0);
INSERT INTO `articles` VALUES (23, '国产旗舰手机更加重视AI体验', '2026年国产手机新品普遍强化AI功能，包括AI修图、AI语音助手、AI场景识别和本地化智能服务。未来用户选购手机时，系统AI体验可能会和处理器、相机一样重要。', 'gin', '国产手机资讯', 0, 'published', '2026-05-25 12:34:39', '2026-05-25 12:44:27', 0);
INSERT INTO `articles` VALUES (24, '中端国产手机开始承接旗舰配置下放', '近期国产中端手机配置持续升级，高刷新率屏幕、大电池、快充、长焦镜头和AI功能逐渐下放。对普通用户来说，3000元左右价位段的国产手机选择越来越丰富。', 'admin', '国产手机资讯', 2, 'published', '2026-05-25 12:34:39', '2026-05-27 04:45:17', 0);
INSERT INTO `articles` VALUES (25, '2026年国产手机选购更看重综合体验', '随着手机性能普遍过剩，国产手机选购已经不只看跑分。屏幕、续航、影像、系统流畅度、AI功能、售后和价格，都会影响真实使用体验。', 'user001', '国产手机资讯', 2, 'published', '2026-05-25 12:34:39', '2026-05-27 04:44:05', 0);
INSERT INTO `articles` VALUES (26, '骁龙8sGen3发热严重？荣耀200Pro性能实测', '# 荣耀200 Pro性能深度评测：骁龙8s Gen 3到底有多稳？和骁龙888比温控差距有多大？\n\n## 一、核心配置速览\n\n荣耀200 Pro搭载高通骁龙8s Gen 3处理器，这颗芯片采用台积电4nm制程工艺，CPU采用1+4+3三丛集架构设计：1颗Cortex-X4超大核（主频3.0GHz）、4颗Cortex-A720性能核（主频2.8GHz）以及3颗Cortex-A520能效核（主频2.0GHz）。GPU方面配备Adreno 735，主频达到1100MHz。\n\n内存与存储方面，荣耀200 Pro搭载LPDDR5X运行内存和UFS 3.1闪存，提供最高16GB+1TB的存储组合。此外，该机还搭载了荣耀自研射频增强芯片C1+，保障通信体验。\n\n从纸面参数来看，骁龙8s Gen 3对标的是骁龙8 Gen 2级别的旗舰性能，而8s与8之间虽有差距，但在能效比上预期更优。更重要的是，这颗芯片采用了台积电工艺——而这恰恰是当年骁龙888的“致命伤”所在。\n\n## 二、跑分性能测试\n\n### 2.1 安兔兔综合跑分\n\n在安兔兔V10版本测试中，荣耀200 Pro综合得分稳定在175万分左右。这一成绩在当前安卓阵营中处于次旗舰第一梯队，超越多数同价位竞品。\n\n横向对比来看，搭载骁龙888的机型安兔兔V10得分普遍在111万左右，荣耀200 Pro领先幅度高达约57%。这不仅仅是跑分差距，更代表了处理器在CPU、GPU、内存、UX等各项子系统上的全面领先。\n\n### 2.2 GeekBench 6与3DMark测试\n\n在GeekBench 6测试中，荣耀200 Pro单核得分约2031分，多核得分约5603分，而骁龙888单核约1119分、多核约3680分。单核性能提升约81%，多核性能提升约52%。\n\n3DMark图形测试中，荣耀200 Pro的Wild Life Extreme得分约6547分，表明其Adreno 735 GPU在极限图形负载下依然有充足的计算余量。\n\n### 2.3 压力测试与持续性能释放\n\n跑分只看峰值还不够，持续性能才是日常体验的关键。荣耀200 Pro在安兔兔压力测试中功耗波动幅度较小，性能释放平稳。相比之下，骁龙888机型在压力测试中功耗波动幅度可达±0.8W以上，说明其电源管理策略在面对动态负载时响应迟滞，调频精度偏低。这意味着荣耀200 Pro在高强度持续使用场景（如长时间游戏、视频渲染等）中，性能下降幅度明显更小。\n\n## 三、游戏实测：性能与功耗的双重考验\n\n为了全面考察荣耀200 Pro的实际游戏表现，我们选择了《王者荣耀》和《原神》作为测试项目——前者代表主流网游场景，后者则是手机性能的真正“试金石”。\n\n### 3.1 王者荣耀测试\n\n在《王者荣耀》极高帧率+超高分辨率+极致画质设定下，荣耀200 Pro全程平均帧率119.63帧，整体曲线极为平稳，即使是团战场景也未出现卡顿或明显波动。\n\n功耗方面，平均功耗仅3.23W，帧能耗37.2 FPS/W。温控表现同样亮眼——背面芯片区域最高仅39.5℃，握持区域仅有37℃，游戏过程中几乎感受不到热量带来的影响。\n\n### 3.2 原神测试：真正的性能标尺\n\n《原神》才是见真章的时刻。在极高画质+60帧设定下，选择枫丹廷主城使用快速移动角色随机跑图进行测试：\n\n**默认模式测试**（30分钟）：平均帧率60.4帧，帧率标准差仅±0.8帧，画面流畅度非常出色。功耗方面，平均约5.65W，确实高于《王者荣耀》，但考虑到场景负载，这一功耗水平在合理范围内。\n\n**帧率增强模式**：开启GPU Turbo X的帧率增强功能后，GPU核心频率提升至920MHz，画面实时渲染帧率来到92 FPS，实测平均帧率91.09 FPS，全程无明显掉帧。功耗仅小幅增加至约6.2W，帧能耗达到14.7 FPS/W，能效表现非常出色。\n\n值得注意的是，虽然极高画质下的波动客观存在——帧率曲线偶有触及45 FPS的情况，但很快回归60 FPS，这应该是温控策略在自动决策。这种“先稳后降”的调度逻辑，在实际体验中并不会产生明显的卡顿感。\n\n## 四、温度测试：骁龙8s Gen 3 vs 骁龙888 巅峰对决\n\n这是本文最受关注的部分。我们将其作为独立章节，从散热硬件、实测数据、芯片工艺三个维度进行全面对比。\n\n### 4.1 荣耀200 Pro散热硬件解析\n\n荣耀200 Pro在散热方面下了本钱。该机搭载了荣耀数字系列史上最大的不锈钢仿生VC散热系统，总面积达5564mm²。配合第四代高导热石墨片，整套方案可实现6W/45℃的散热规格。相比传统铜VC均热板，该方案重量减轻28%、厚度减少6%-14%，VC散热面积提升19%，VC导热性能提升23%。\n\n这套散热方案的全称是“全域冷驱散热系统2.0”，不仅在VC均热板本体上做了升级，还在整机热分布均匀性上做了优化，确保热量不会集中在某一区域造成局部烫手。\n\n### 4.2 各场景实测温度汇总\n\n以下是荣耀200 Pro在不同负载场景下的实测温度数据：\n\n**王者荣耀（极高画质）** ：背面芯片区最高39.5℃，握持区域37℃。接近体温，完全无感知负担。\n\n**原神默认60帧模式**（30分钟）：正面最高44.4℃，背面最高43.5℃，握持区域约38.4℃。\n\n**原神帧率增强90帧模式**（10分钟）：机身芯片区域最高45℃，握持区域39.6℃，比默认模式提升约1℃。\n\n综合来看，荣耀200 Pro在各类场景下的SoC结温均控制在42℃以内，握持区域温度始终低于37℃。\n\n### 4.3 骁龙888的“火龙”前科\n\n骁龙888搭载三星5nm LPE工艺，这一工艺被大量测试证明存在漏电率高的问题——相比台积电同制程，三星5nm漏电率高出20%至30%，直接导致功耗和发热量显著增加。再加上Cortex-X1超大核本身功耗较高（超大核功耗达7.67W），二者叠加，使得骁龙888在高负载下频繁触发温控降频。\n\n具体实测数据如下：\n\n小米11（骁龙888）在《绝地求生》HDR高清60Hz模式30分钟后，正面最高约41℃，背面最高约40℃。而在《原神》最高画质下运行1小时后，温度反而降到约37℃，但这是因为温控已大幅介入、强制降频的结果。若持续高负载，安兔兔跑分循环测试后，机身温度可达到53℃-56℃。\n\n小米MIX 4（骁龙888）在连续30分钟《原神》高画质运行后，整机表面最高温度达46.2℃。\n\niQOO 7（骁龙888）实测30分钟游戏后，机身温度可达45℃左右，握持区有明显热感。\n\n综合多家测试，骁龙888机型在《原神》场景下普遍突破45℃，部分机型甚至接近50℃，触发屏幕强制降亮度、系统锁帧等保护机制。\n\n### 4.4 温度对比分析\n\n| 测试场景 | 荣耀200 Pro (骁龙8s Gen 3) | 骁龙888典型机型 |\n|---------|-------------------------|----------------|\n| 《王者荣耀》 | 39.5℃（芯片区）| - |\n| 《原神》30min | 44.4℃（正面）/ 43.5℃（背面）| 46.2℃（整机最高）|\n| 《原神》握持区 | 38.4℃ | 45℃+（明显烫手）|\n| 安兔兔压力测试 | SoC结温42℃以内 | 53℃-56℃ |\n\n荣耀200 Pro的最高温度比骁龙888机型大约低2-3℃，握持区域（直接影响用户体验的部位）温度差距更为明显——荣耀200 Pro仅38.4℃，而骁龙888机型普遍在45℃以上，差距接近7℃。这一温差足以让用户从“烫手难忍”变为“温热可接受”。\n\n### 4.5 温度差异的深层原因分析\n\n温差来自两方面共同作用：\n\n**工艺代差**：骁龙8s Gen 3采用台积电4nm工艺，在漏电率和晶体管控制精度上明显优于三星5nm。更高的能效意味着同等性能输出时产生的废热更少。\n\n**散热堆料**：5564mm²的大面积VC均热板将SoC热量高效导出并均匀散布，避免热量局部堆积造成“热点效应”，使得最高温度不低但握持区域温度很低。\n\n两者的协同，让荣耀200 Pro实现了“性能上去了、温度下来了”的最终效果。\n\n## 五、综合评价与购买建议\n\n荣耀200 Pro凭借骁龙8s Gen 3处理器和大面积VC散热系统的协同配合，在性能释放和温度控制两方面都交出了令人满意的答卷。《原神》60帧满帧运行，《王者荣耀》几乎无感发热，即使在最极限的游戏场景下，温度也控制在对使用体验不会造成明显影响的范围内。\n\n与骁龙888的对比更是极具意义——曾经的旗舰芯片因为三星工艺带来的发热问题，在长时间游戏场景中体验堪忧。而荣耀200 Pro不仅性能全面领先（跑分高出约57%），温控表现更是天壤之别。\n\n当然，这颗芯片也有自己的定位：它并非顶级旗舰芯片（与骁龙8 Gen 3的差距客观存在），但对于绝大多数用户的使用场景——日常办公、高清影音、主流手游、AI影像计算等——荣耀200 Pro的综合表现完全够用。\n\n**适用人群**：\n- ✅ 追求均衡体验的用户（性能够用、温控优秀、续航出色）\n- ✅ 中度游戏玩家（《王者荣耀》《和平精英》等主流网游完全无压力）\n- ✅ 注重人像拍摄的用户（荣耀200 Pro在影像方面也下足了功夫）\n- ⚠️ 极限画质追求者（如果对《原神》等游戏有全高画质+稳定60帧以上的极端需求，建议考虑骁龙8 Gen 3或更高阶机型）\n\n**一句话总结**：荣耀200 Pro用骁龙8s Gen 3这颗“准旗舰芯”，交出了一份跑分能打、游戏能扛、温控能赢的均衡答卷。从骁龙888的“火龙”时代到今天的冷静稳定，这背后不仅是芯片工艺的代际进步，更是荣耀在散热堆料与系统调度上多年积累的体现。', 'gin', '手机', 1, 'draft', '2026-05-27 03:31:24', '2026-05-27 03:31:24', 0);
INSERT INTO `articles` VALUES (27, '加码了！我自己也在用！这个 密令\"332211\" 大量领25-25！', '亲测有效！今天有25-25！\n\n这个密令我自己都在用！经常加码！\n\n注意：是淘宝app里的闪购栏目！！\n\n注意：是淘宝app里的闪购栏目！！\n\n美団直接嗖”332211”就能领\n\n美団直接嗖”332211”就能领\n\n评论区随机抽一位粉丝补贴50买零食', 'user001', '电脑', 2, 'draft', '2026-05-27 04:47:25', '2026-05-27 04:53:22', 0);
INSERT INTO `articles` VALUES (28, '2026年科技业界发展趋势观察', '这是一篇关于科技业界的文章内容，主要介绍当前行业热点、企业动态、技术方向和未来发展趋势。', 'gin', '业界', 0, 'published', '2026-05-27 14:55:29', '2026-05-27 14:55:29', 0);
INSERT INTO `articles` VALUES (29, '2026年热门手机选购指南', '这是一篇关于手机的文章内容，主要介绍热门机型、处理器、屏幕、影像、续航和购买建议。', 'man', '手机', 0, 'published', '2026-05-27 14:55:40', '2026-05-27 14:55:40', 0);
INSERT INTO `articles` VALUES (30, '轻薄本与游戏本该怎么选', '这是一篇关于电脑的文章内容，主要介绍不同类型电脑的性能表现、使用场景、配置差异和选购建议。', 'user003', '电脑', 0, 'published', '2026-05-27 14:56:12', '2026-05-27 14:56:12', 0);
INSERT INTO `articles` VALUES (31, '旗舰手机真实体验测评', '这是一篇关于测评的文章内容，主要从外观、性能、屏幕、拍照、续航和系统体验等方面进行分析。', 'manba', '测评', 0, 'published', '2026-05-27 14:56:30', '2026-05-27 14:56:30', 0);
INSERT INTO `articles` VALUES (32, '年度数码专题盘点', '这是一篇关于专题的文章内容，主要盘点年度热门数码产品、技术趋势、用户关注重点和购买建议。', 'user001', '专题', 0, 'published', '2026-05-27 14:56:42', '2026-05-27 14:56:42', 0);
INSERT INTO `articles` VALUES (33, 'Win11新功能体验介绍', '这是一篇关于Win11的文章内容，主要介绍界面变化、系统功能、兼容性表现、办公体验和升级建议。', 'manba', 'Win11', 0, 'published', '2026-05-27 14:56:51', '2026-05-27 14:56:51', 0);
INSERT INTO `articles` VALUES (34, 'Win10系统优化技巧', '这是一篇关于Win10的文章内容，主要介绍系统设置、启动项管理、存储清理、驱动更新和性能优化方法。', 'user003', 'Win10', 2, 'published', '2026-05-27 14:57:00', '2026-05-28 08:35:57', 1);
INSERT INTO `articles` VALUES (35, '微软生态产品使用体验', '这是一篇关于微软的文章内容，主要介绍Windows系统、Office办公软件、云服务和生产力工具体验。', 'man', '微软', 0, 'published', '2026-05-27 14:57:08', '2026-05-27 14:57:08', 0);
INSERT INTO `articles` VALUES (36, '5G网络应用体验介绍', '这是一篇关于5G的文章内容，主要介绍5G网络速度、低延迟应用、手机支持情况和实际使用体验。', 'gin', '5G', 1, 'published', '2026-05-27 14:57:16', '2026-05-31 12:23:40', 0);
INSERT INTO `articles` VALUES (37, '游戏设备配置推荐', '这是一篇关于游戏的文章内容，主要介绍游戏手机、游戏本、显示器、键鼠外设和性能优化建议。', 'manba', '游戏', 1, 'published', '2026-05-27 14:57:27', '2026-05-31 12:00:33', 0);
INSERT INTO `articles` VALUES (38, '直播设备搭建入门指南', '这是一篇关于直播的文章内容，主要介绍直播电脑、摄像头、麦克风、补光灯和推流软件的选择。', 'user001', '直播', 1, 'published', '2026-05-27 14:57:34', '2026-06-10 05:40:23', 0);
INSERT INTO `articles` VALUES (39, '数码产品日常选购攻略', '这是一篇关于数码的文章内容，主要介绍耳机、平板、手表、相机和智能配件的选购建议。', 'man', '数码', 1, 'published', '2026-05-27 14:57:44', '2026-06-11 10:51:20', 0);
INSERT INTO `articles` VALUES (40, '电脑手机基础知识学院', '这是一篇关于学院的文章内容，主要介绍数码设备基础知识、配置参数理解、系统使用技巧和维护方法。', 'user003', '学院', 1, 'published', '2026-05-27 14:57:59', '2026-06-10 02:44:28', 0);
INSERT INTO `articles` VALUES (41, '鸿蒙系统生态发展介绍', '这是一篇关于鸿蒙的文章内容，主要介绍鸿蒙系统的设备互联能力、生态建设、系统体验和未来发展方向。', 'manba', '鸿蒙', 2, 'published', '2026-05-27 14:58:14', '2026-06-11 11:18:02', 0);
INSERT INTO `articles` VALUES (42, '鸿蒙系统生态发展介绍', '这是一篇关于鸿蒙的文章内容，主要介绍鸿蒙系统的设备互联能力、生态建设、系统体验和未来发展方向。', 'manba', '鸿蒙', 3, 'published', '2026-05-29 09:42:33', '2026-06-10 02:44:24', 0);
INSERT INTO `articles` VALUES (43, '比亚迪汉EV深度评测：刀片电池到底强在哪', '<p>比亚迪汉EV作为国产中大型纯电轿车的标杆，自上市以来一直备受关注。今天我们从电池、续航、智能驾驶三个维度来深度剖析这款车。</p><h2>刀片电池技术</h2><p>刀片电池是比亚迪自主研发的磷酸铁锂电池，通过了严苛的针刺实验。相比传统三元锂电池，刀片电池在安全性上有质的飞跃。电池包能量密度达到150Wh/kg，支持最高170kW的快充功率。</p><h2>续航表现</h2><p>汉EV冠军版CLTC续航里程达到715公里。实测城市工况约580公里，高速工况约480公里。冬季低温环境下续航衰减约18%，在同级车型中表现优秀。</p><h2>智能驾驶</h2><p>搭载DiPilot智能驾驶辅助系统，支持高速NOA、自动泊车、遥控泊车等功能。传感器配置包括5个毫米波雷达、12个超声波雷达和8个摄像头。</p><h2>总结</h2><p>综合来看，比亚迪汉EV在20-30万价格区间具有很强的产品竞争力，刀片电池的安全性和续航表现是其核心优势。</p>', '汽车小编', '智车', 5260, 'published', '2026-06-11 11:05:50', '2026-06-11 11:05:50', 189);
INSERT INTO `articles` VALUES (44, '小鹏G6上市首月订单破3万，G9降价能否挽回销量', '<p>小鹏G6自上市以来热度不减，首月订单量超过3万台。与此同时，小鹏G9宣布大幅降价，能否扭转此前的销量颓势？</p><h2>G6产品力分析</h2><p>G6定位于中型纯电轿跑SUV，起售价20.99万元，搭载了800V高压快充平台，充电5分钟续航200公里。车内采用Xmart OS 4.0智能座舱系统，支持全场景语音交互。</p><h2>G9降价策略</h2><p>小鹏G9在此前销量不达预期后，调整价格策略，最高降幅达6万元。降价后的G9在配置和价格上的竞争力明显提升，但品牌信任度的修复需要时间。</p><h2>市场格局</h2><p>20-30万元纯电SUV市场竞争激烈，特斯拉Model Y、比亚迪宋L、理想L6等车型都在此价位段角逐。G6能否成为小鹏的爆款，还需市场验证。</p>', '新能源观察', '智车', 4321, 'published', '2026-06-11 11:05:50', '2026-06-11 12:47:13', 156);
INSERT INTO `articles` VALUES (45, '华为智选车全景：问界、智界、享界三大品牌齐发力', '<p>华为在智能汽车领域布局日渐清晰。问界、智界、享界三大品牌覆盖了从中端到高端的细分市场，形成了完整的产品矩阵。</p><h2>问界——智能增程SUV</h2><p>问界系列由华为与赛力斯合作打造，主打增程式电动SUV。新M7自上市以来月销破万，搭载华为鸿蒙座舱和ADS 2.0智驾系统，备受市场认可。</p><h2>智界——智能电动轿车</h2><p>智界是华为与奇瑞合作的产物，首款车型智界S7定位智能电动轿车。全系标配800V高压平台和CDC减震系统，智能泊车能力尤为突出。</p><h2>享界——高端豪华轿车</h2><p>享界由华为与北汽合作推出，S9车型对标奔驰S级和宝马7系。车身超过5米，轴距超过3米，是华为智选车中最豪华的车型。</p><h2>华为智驾方案</h2><p>ADS 2.0支持无图城市NCA，覆盖全国400多个城市。算力平台搭载华为自研昇腾芯片，端到端的自动驾驶能力在行业中处于领先水平。</p>', '出行风向标', '智车', 6183, 'published', '2026-06-11 11:05:50', '2026-06-14 12:31:05', 234);

-- ----------------------------
-- Table structure for click_logs
-- ----------------------------
DROP TABLE IF EXISTS `click_logs`;
CREATE TABLE `click_logs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `page` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'unknown',
  `user_id` int NULL DEFAULT NULL,
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of click_logs
-- ----------------------------

-- ----------------------------
-- Table structure for computer
-- ----------------------------
DROP TABLE IF EXISTS `computer`;
CREATE TABLE `computer`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'brand',
  `model` varchar(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'model',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'type',
  `processor` varchar(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'processor',
  `graphics` varchar(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'graphics',
  `memory` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'memory',
  `storage` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'storage',
  `price` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'price text',
  `price_value` decimal(10, 2) NULL DEFAULT NULL COMMENT 'price value',
  `accent` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'theme color',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'image filename',
  `screen_size` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'screen size',
  `resolution` varchar(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'resolution',
  `refresh_rate` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'refresh rate',
  `weight` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'weight',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_computer_brand_model`(`brand` ASC, `model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of computer
-- ----------------------------
INSERT INTO `computer` VALUES (1, 'Apple', 'MacBook Air 13 (M3)', '轻薄本', 'Apple M3', '至高 8 核 GPU', '16GB', '512GB SSD', '¥8999 起', 8999.00, '#111827', 'MacBook Air M3.png', '14英寸', NULL, '60Hz', NULL, '2026-05-26 06:28:04', '2026-05-27 02:12:55');
INSERT INTO `computer` VALUES (2, 'Apple', 'MacBook Pro 14 (M4 Pro)', '创作本', 'Apple M4 Pro', '至高 16 核 GPU', '24GB', '1TB SSD', '¥16999 起', 16999.00, '#374151', 'MacBook Pro.jpg', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (3, 'Apple', 'MacBook Air 13 (M4)', '轻薄本', 'Apple M4', '10核图形处理器', '24GB', '512GB SSD', '¥10999 起', 10999.00, '#111827', 'MacBook Air M3.png', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (4, 'Apple', 'MacBook Pro 13 (M2)', '轻薄本', 'Apple M2', '10核图形处理器', '8GB', '256GB SSD', '¥9999 起', 9999.00, '#4b5563', 'MacBook Pro.jpg', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (5, '联想', 'ThinkPad X1 Carbon', '商务本', '酷睿 Ultra 7-255H', 'Intel Arc 140T 核显', '32GB', '1TB SSD', '¥12999 起', 12999.00, '#dc2626', 'ThinkPad X1 Carbon.jpg', '14英寸', '2880x1800', '120Hz', '约1.12Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (6, '联想', '拯救者 Y7000P 2025', '游戏本', '酷睿 i7-14700HX', 'RTX 4070', '16GB', '1TB SSD', '¥7999 起', 7999.00, '#ef4444', '拯救者 Y7000P 2025.jpg', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (7, '联想', '拯救者R9000P 2025 AI元启', '游戏本', 'AMD Ryzen 9 8945HX', 'RTX 5070', '32GB', '1TB SSD', '¥11149 起', 11149.00, '#dc2626', '拯救者R9000P 2025 AI元启.jpg', '16英寸', '2560x1600', '240Hz', '约2Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (8, '联想', '拯救者Y7000P 2025 AI元启', '游戏本', '酷睿 i9 14900HX', 'RTX 5060', '16GB', '1TB SSD', '¥9499 起', 9499.00, '#ef4444', '拯救者Y7000P 2025 AI元启.jpg', '16英寸', '2560x1600', '165Hz', '约2.35Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (9, '联想', '小新Pro16GT 2026 AI元启版', '轻薄本', '酷睿 Ultra X9 388H', 'Intel Arc B390', '32GB', '1TB SSD', '¥10799起', 10799.00, '#f97316', '小新Pro16GT 2026 AI元启版.jpg', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-06-03 02:32:09');
INSERT INTO `computer` VALUES (10, '华为', 'MateBook X Pro', '轻薄本', '酷睿 Ultra 9 185H', 'Intel Arc 核显', '32GB', '2TB SSD', '¥11199 起', 11199.00, '#ef4444', 'MateBook X Pro.png', '14.2英寸', '3120x2080', '120Hz', '约980g', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (11, '华为', 'MateBook 14', '全能本', '酷睿 Ultra 5 125H', 'Intel Arc 核显', '16GB', '1TB SSD', '¥6499 起', 6499.00, '#f97316', 'MateBook 14.png', '14.2英寸', '2880x1920', '120Hz', '约1.31Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (12, '华为', 'MateBook Fold 非凡大师', '轻薄本', '麒麟X90', '集成显卡', '32GB', '2TB SSD', '¥19999 起', 19999.00, '#ef4444', 'MateBook Fold 非凡大师.png', '折叠屏', '展开态3296x2472 / 半屏2472x1648', '暂无数据', '暂无数据', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (13, '华为', 'MateBook Pro', '轻薄本', '麒麟X90', '集成显卡', '32GB', '1TB SSD', '¥7999 起', 7999.00, '#f43f5e', 'MateBook Pro.png', '14.2英寸', '3120x2080', '120Hz', '约970g', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (14, '戴尔', 'XPS 13 2024', '轻薄本', '酷睿 Ultra 7 258V', 'Intel Arc 140V 核显', '16GB', '1TB SSD', '¥16999 起', 16999.00, '#2563eb', 'XPS 13 2024.jpg', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (15, '戴尔', 'Alienware m16 R2', '游戏本', '酷睿 Ultra 9-185H', 'RTX 4070', '32GB', '1TB SSD', '¥17999 起', 17999.00, '#0ea5e9', 'Alienware m16 R2.jpg', '16英寸', '2560x1600', '240Hz', '约2.61Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (16, '戴尔', 'Latitude 5440', '商务本', '酷睿 i7 1355U', '集成显卡', '16GB', '1TB SSD', '¥7299 起', 7299.00, '#2563eb', 'Latitude 5440.png', '14英寸', '1920x1080', '60Hz', '约1.39Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (17, '戴尔', 'Latitude 5530', '商务本', '酷睿 i7 1255U', '集成显卡', '32GB', '512GB SSD', '¥5699 起', 5699.00, '#0ea5e9', 'Latitude 5530.png', '15.6英寸', '1920x1080', '60Hz', '约1.59Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (18, '戴尔', 'XPS14', '商务本', '酷睿 UltraX7 358H', 'ARC B390', '32GB', '1TB SSD', '¥25999 起', 25999.00, '#0ea5e9', 'XPS14.png', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (19, '戴尔', 'XPS16', '商务本', '酷睿 UltraX7 358H', 'ARC B390', '32GB', '1TB SSD', '¥26999 起', 26999.00, '#0ea5e9', 'XPS16.png', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (20, '惠普', '星 Book Pro 14', '轻薄本', '酷睿 Ultra 5 225H', 'Intel Arc 130T 核显', '16GB', '1TB SSD', '¥5999 起', 5999.00, '#1d4ed8', '星 Book Pro 14.png', '14英寸', '2880x1800', '120Hz', '约1.45Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (21, '惠普', '暗影精灵 10', '游戏本', '酷睿 i7-14650HX', 'RTX 4060', '16GB', '1TB SSD', '¥8299 起', 8299.00, '#2563eb', '暗影精灵 10.jpg', '16.1英寸', '2560x1440', '240Hz', '约2.4Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (22, '惠普', '暗影精灵11', '游戏本', '酷睿 i9 14900HX', 'RTX 5070', '32GB', '1TB SSD', '¥9999 起', 9999.00, '#1d4ed8', '暗影精灵11.jpg', '16英寸', '2560x1600', '240Hz', '2.43Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (23, '惠普', '战66 2025 酷睿Ultra版 16英寸', '商务本', '酷睿 Ultra 7 155H', '集成显卡', '32GB', '1TB SSD', '¥6199 起', 6199.00, '#2563eb', '战66 2025 酷睿Ultra版 16英寸.jpg', '16英寸', '1920x1200', '60Hz', '约1.75Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (24, '华硕', '灵耀 14', '轻薄本', '酷睿 Ultra 7 155H', 'Intel Arc 核显', '32GB', '1TB SSD', '¥7999 起', 7999.00, '#475569', '灵耀 14.jpg', '14英寸', '2880x1800', '120Hz', '约1.2Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (25, '华硕', 'ROG 魔霸新锐 2025', '游戏本', '锐龙 9 8940HX', 'RTX 5070', '32GB', '1TB SSD', '¥12999 起', 12999.00, '#0f172a', 'ROG 魔霸新锐2025.png', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (26, '华硕', 'ProArt创13 2026', '创作本', '锐龙 AI Max+ 395', 'Radeon 8060S', '64GB', '1TB SSD', '¥14999 起', 14999.00, '#0f172a', 'ProArt创13 2026.jpg', '13.3英寸', '2880x1800', '120Hz', '约1.2Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (27, '华硕', '无畏14 2024', '轻薄本', '酷睿 i5 13500H', '集成显卡', '16GB', '1TB SSD', '¥3799 起', 3799.00, '#475569', '无畏14 2024.png', '14英寸', '2880x1800', '120Hz', '约1.4Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (28, '华硕', '天选4 13代酷睿版', '游戏本', '酷睿 i9 13900H', 'RTX 4060', '16GB', '1TB SSD', '¥10499 起', 10499.00, '#64748b', '天选4 13代酷睿版.png', '15.6英寸', '2560x1440', '165Hz', '约2.1Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (29, '华硕', 'ROG 幻16Air 酷睿版', '游戏本', '酷睿 Ultra 9 185H', 'RTX 4060', '32GB', '1TB SSD', '¥13499 起', 13499.00, '#64748b', 'ROG 幻16Air 酷睿版.jpg', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (30, '华硕', 'ROG 幻16Air 锐龙AI版', '游戏本', 'Ryzen AI9 HX370', 'RTX 4060', '32GB', '1TB SSD', '¥14999 起', 14999.00, '#64748b', 'ROG 幻16Air 锐龙AI版.jpg', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (31, '宏碁', '掠夺者 Neo 16', '游戏本', '酷睿 i9-14900HX', 'RTX 4070', '32GB', '1TB SSD', '¥11999 起', 11999.00, '#16a34a', '掠夺者 Neo 16.jpg', '16英寸', '2560x1600', '165Hz', '约2.6Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (32, '宏碁', '非凡 Go Pro', '轻薄本', '酷睿 Ultra 7 155H', 'Intel Arc 核显', '32GB', '1TB SSD', '¥6999 起', 6999.00, '#65a30d', '非凡 Go Pro.jpg', '14英寸', '2880x1800', '90Hz', '约1.3Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (33, '宏碁', '掠夺者·刀锋8', '游戏本', '酷睿 Ultra 9 288V', 'RTX 5070', '32GB', '2TB SSD', '¥19999 起', 19999.00, '#16a34a', '掠夺者·刀锋8.jpg', '8英寸', '1920x1200', '暂无数据', '暂无数据', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (34, '宏碁', '非凡 X14', '全能本', '酷睿 i5 13500H', 'RTX 4050', '16GB', '1TB SSD', '¥7299 起', 7299.00, '#65a30d', '非凡 X14.jpg', '14.5英寸', '2560x1600', '120Hz', '约1.5Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (35, '机械革命', '蛟龙 16 Pro', '游戏本', '锐龙 9 7945HX', 'RTX 4070', '32GB', '1TB SSD', '¥8999 起', 8999.00, '#7c3aed', '蛟龙 16 Pro.png', '16英寸', '2560x1600', '240Hz', '约2.3Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (36, '机械革命', '蛟龙15K', '游戏本', 'Ryzen 7 7735H', 'RTX 3050', '16GB', '512GB SSD', '¥5699 起', 5699.00, '#7c3aed', '蛟龙15K.png', '15.6英寸', '1920x1080', '165Hz', '约2.1Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (37, '机械革命', '无界15X 酷睿版 2024', '轻薄本', '酷睿 Ultra 7 155H', '集成显卡', '32GB', '1TB SSD', '¥6999 起', 6999.00, '#2563eb', '无界15X 酷睿版 2024.png', '15.6英寸', '2560x1440', '120Hz', '约1.7Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (38, '七彩虹', '将星 X15 AT', '游戏本', '酷睿 i7-14650HX', 'RTX 4060', '16GB', '1TB SSD', '¥6999 起', 6999.00, '#ec4899', '将星 X15 AT.png', '15.6英寸', '1920x1080', '144Hz', '约2.1Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (39, '七彩虹', '隐星 P16 TA', '游戏本', '酷睿 i9-14900HX', 'RTX 4070', '32GB', '1TB SSD', '¥9999 起', 9999.00, '#f97316', '隐星 P16 TA.png', '16英寸', '2560x1600', '165Hz', '约2.4Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (40, '七彩虹', '隐星 P16', '游戏本', '酷睿 i7 12650H', 'RTX 4060', '16GB', '512GB SSD', '¥5999 起', 5999.00, '#ec4899', '隐星 P16.png', '16英寸', '2560x1600', '165Hz', '约2.3Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (41, '七彩虹', 'E14', '轻薄本', 'Ryzen 7 7735HS', 'Radeon 680M', '32GB', '1TB SSD', '¥3799 起', 3799.00, '#f97316', 'E14.png', '14英寸', '2240x1400', '60Hz', '约1.4Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (42, '火影', '众颜 U6', '轻薄本', '酷睿 i5-12500H', 'Intel Iris Xe', '16GB', '512GB SSD', '¥3999 起', 3999.00, '#dc2626', '众颜 U6.jpg', '16英寸', '2560x1600', '120Hz', '约1.8Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (43, '火影', 'T9 Plus', '游戏本', '酷睿 i7-14650HX', 'RTX 4060', '16GB', '1TB SSD', '¥6499 起', 6499.00, '#111827', 'T9 Plus.jpg', '16英寸', '2560x1600', '165Hz', '约2.3Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (44, '火影', '众颜U6 2024', '轻薄本', 'Ryzen 7 8845HS', '集成显卡', '32GB', '1TB SSD', '价格面议', NULL, '#dc2626', '众颜U6 2024.jpg', '16英寸', '2560x1600', '120Hz', '约1.8Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (45, '火影', 'T9 系列', '游戏本', '酷睿 i7', 'RTX 系列独显', '16GB', '1TB SSD', '价格面议', NULL, '#111827', 'T9 系列.jpg', '16英寸', '2560x1600', '165Hz', '约2.3Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (46, '荣耀', 'MagicBook Pro 16', '全能本', '酷睿 Ultra 7 155H', 'RTX 4060', '32GB', '1TB SSD', '¥8999 起', 8999.00, '#0ea5e9', 'MagicBook Pro 16.png', '16英寸', '3072x1920', '165Hz', '约1.86Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (47, '荣耀', 'MagicBook Pro 14', '轻薄本', '酷睿 Ultra 5 285H', 'Intel Arc 140T核显', '16GB', '1TB SSD', '¥5999 起', 5999.00, '#38bdf8', 'MagicBook Pro 14.png', NULL, NULL, NULL, NULL, '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (48, '荣耀', 'MagicBook Pro 16 2026', '轻薄本', '酷睿 Ultra X9 388H', '集成显卡', '32GB', '1TB SSD', '¥10999 起', 10999.00, '#0ea5e9', 'MagicBook Pro 16 2026.png', '16英寸', '3072x1920', '165Hz', '约1.86Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (49, '荣耀', 'MagicBook Pro 16 HUNTER版', '全能本', '酷睿 Ultra 7 155H', 'RTX 4060', '32GB', '1TB SSD', '价格面议', NULL, '#38bdf8', 'MagicBook Pro 16.png', '16英寸', '3072x1920', '165Hz', '约1.86Kg', '2026-05-26 06:28:04', '2026-05-26 06:28:04');
INSERT INTO `computer` VALUES (50, '荣耀', '荣耀MagicBook Pro 14 2025', '轻薄本', '酷睿 Ultra 5 255H/ultra 9 285H', 'Intel® Arc™ 130T GPU/Intel® Arc™ 140T GPU', '32GB', '1TB SSD', '6799', NULL, '#38bdf8', 'MagicBook Pro 14 2025.png', '14英寸', '3120*2080', '60/120Hz', '约1.37/1.39Kg', '2026-05-27 09:36:03', '2026-05-27 09:36:03');
INSERT INTO `computer` VALUES (51, '小米', 'XiaomiBook Pro14', '轻薄本', '酷睿Ultra X7-358H', 'Intel Arc B390', '32G', '1TB SSD', '7999起', 7999.00, '#2563eb', 'XiaomiBook Pro14.png', '14英寸', '2880x1800', '120Hz', '1.0KG', '2026-06-03 02:19:56', '2026-06-03 02:19:56');

-- ----------------------------
-- Table structure for phone_models
-- ----------------------------
DROP TABLE IF EXISTS `phone_models`;
CREATE TABLE `phone_models`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '手机ID',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌',
  `model` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机型号',
  `processor` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理器',
  `battery` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电池容量文本，例如 5000mAh',
  `battery_value` int NULL DEFAULT 0 COMMENT '电池容量数值，对应前端 batteryValue',
  `price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '价格文本，例如 ¥4999 起',
  `price_value` int NULL DEFAULT 0 COMMENT '价格数值，对应前端 priceValue',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片文件名，例如 Mate60.jpg',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '手机详细链接',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_model`(`model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 83 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '手机型号表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of phone_models
-- ----------------------------
INSERT INTO `phone_models` VALUES (1, '华为', 'HUAWEI Mate 60', '麒麟9000S', '4750mAh', 4750, '¥4999 起', 4999, 'Mate60.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (2, '华为', 'HUAWEI Mate 60 Pro', '麒麟9000S', '5000mAh', 5000, '¥5699 起', 5699, 'Mate60 Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (3, '华为', 'HUAWEI Mate 60 Pro+', '麒麟9000S', '5000mAh', 5000, '¥7999 起', 7999, 'Mate60Pro+.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (4, '华为', 'HUAWEI Mate 60 RS 非凡大师', '麒麟9000S', '5000mAh', 5000, '¥11999 起', 11999, 'Mate60RS.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (5, '华为', 'HUAWEI Mate 70', '麒麟9010', '5300mAh', 5300, '¥5499 起', 5499, 'Mate 70.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (6, '华为', 'HUAWEI Mate 70 Pro', '麒麟9020', '5500mAh', 5500, '¥6499 起', 6499, 'mate70pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (7, '华为', 'HUAWEI Mate 70 RS 非凡大师', '麒麟9020', '5700mAh', 5700, '¥11999 起', 11999, 'Mate70RS.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (8, '华为', 'HUAWEI Mate 80', '麒麟9020', '5750mAh', 5750, '¥4699 起', 4699, 'Mate 80.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (9, '华为', 'HUAWEI Mate 80 Pro', '麒麟9030 / 麒麟9030 Pro', '5750mAh', 5750, '¥5999 起', 5999, 'Mate 80 Pro.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (10, '华为', 'HUAWEI Mate 80 Pro Max', '麒麟9030 Pro', '6000mAh', 6000, '¥6999 起', 6999, 'Mate 80 Pro Max.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (11, '华为', 'HUAWEI Mate 80 RS 非凡大师', '麒麟9030 Pro', '6000mAh', 6000, '¥11999 起', 11999, 'Mate80RS.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (12, '华为', 'HUAWEI P60', '骁龙8+ Gen1', '4815mAh', 4815, '¥4488 起', 4488, 'P60.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (13, '华为', 'HUAWEI P60 Pro', '骁龙8+ Gen1', '4815mAh', 4815, '¥6188 起', 6188, 'P60Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (14, '华为', 'HUAWEI P60 Art', '骁龙8+ Gen1', '5060mAh', 5060, '¥8988 起', 8988, 'P60Art.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (15, '华为', 'HUAWEI Pura 70', '麒麟9010', '4900mAh', 4900, '¥4999 起', 4999, 'Pura70.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (16, '华为', 'HUAWEI Pura 70 Pro', '麒麟9020', '5050mAh', 5050, '¥5999 起', 5999, 'Pura70Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (17, '华为', 'HUAWEI Pura 70 Pro+', '麒麟9020', '5050mAh', 5050, '¥7499 起', 7499, 'Pura70Pro+.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (18, '华为', 'HUAWEI Pura 70 Ultra', '麒麟9020', '5200mAh', 5200, '¥9999 起', 9999, 'Pura70Ultra.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (19, '华为', 'HUAWEI Pura 80', '官网未标注', '5600mAh', 5600, '¥5299 起', 5299, 'Pura80.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (20, '华为', 'HUAWEI Pura 80 Pro', '麒麟9020', '5700mAh', 5700, '¥6299 起', 6299, 'Pura80Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (21, '华为', 'HUAWEI Pura 80 Pro+', '麒麟9020', '5700mAh', 5700, '¥7699 起', 7699, 'Pura80Pro+.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (22, '华为', 'HUAWEI Pura 80 Ultra', '麒麟9020', '5700mAh', 5700, '¥10999 起', 10999, 'Pura80Ultra.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (23, '华为', 'HUAWEI Pura 90', '麒麟9010S', '6500mAh', 6500, '¥5599 起', 5599, 'Pura90.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (24, '华为', 'HUAWEI Pura 90 Pro', '麒麟9030S', '6000mAh', 6000, '¥6599 起', 6599, 'Pura90Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (25, '华为', 'HUAWEI Pura 90 Pro Max', '麒麟9030S', '6000mAh', 6000, '¥7999 起', 7999, 'Pura90ProMax.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (26, '小米', '小米  17', '骁龙 8Elite Gen5', '7100mAh', 6100, '¥4,499 起', 4499, 'xm17.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (27, '小米', '小米 17 Pro', '骁龙 8Elite Gen5', '6300mAh', 6300, '¥5,299 起', 5299, 'xm17Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (28, '小米', '小米 17 Pro Max', '骁龙 8Elite Gen5', '7500mAh', 7500, '¥5,999 起', 5999, 'xm17ProMax.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (29, '小米', '小米 17 Max', '骁龙 8Elite Gen5', '8000mAh', 8000, '暂未开售', NULL, 'xm17Max.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (30, '小米', '小米 17 Ultra', '骁龙 8Elite Gen5', '6800mAh', 6800, '¥6,999 起', 6999, 'xm17Ultra.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (31, '小米', '小米 17 Ultra徕卡版', '骁龙 8Elite Gen5', '6800mAh', 6800, '¥7,499 起', 7499, 'xm17Ultra For LEICA.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (32, '小米', '小米 15s Pro', 'Xring O1', '6100mAh', 6100, '¥5,299 起', 5299, 'xm15sPro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (33, '小米', '小米 15 Pro', '骁龙 8 至尊版', '6100mAh', 6100, '¥5,299 起', 5299, 'xm15Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (34, '小米', '小米 15', '骁龙 8 至尊版', '5400mAh', 5400, '¥4,499 起', 4499, 'xm15.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (35, '小米', '小米 14 Ultra', '骁龙 8 Gen3', '5300mAh', 5300, '¥6,499 起', 6499, 'xm14Ultra.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (36, '小米', '小米 14 Pro', '骁龙 8 Gen3', '5400mAh', 5400, '¥4,999 起', 4999, 'xm14Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (37, '小米', '小米 14', '骁龙 8 Gen3', '4610mAh', 4610, '¥3,999 起', 3999, 'xm14.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (38, '小米', 'REDMI K90 Max', '天玑9500', '8550mAh', 8550, '¥3,499 起', 3499, 'K90Max.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (39, '小米', 'REDMI K90 Pro Max', '骁龙 8 Elite Gen5', '7500mAh', 7500, '¥3,999 起', 3999, 'K90ProMax.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (40, '小米', 'REDMI K90 ', '骁龙 8 至尊版', '7100mAh', 7100, '¥2,599 起', 2599, 'K90.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (41, '小米', 'Redmi K80 Ultra', '天玑9400+', '6500mAh', 6500, '¥2,599 起', 2599, 'K80Ultra.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (42, '小米', 'Redmi K80 Pro', '骁龙 8 至尊版', '6000mAh', 6000, '¥3,699 起', 3699, 'K80Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (43, '小米', 'Redmi K80', '骁龙 8 Gen3', '6550mAh', 6550, '¥2,599 起', 2599, 'K80.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (44, 'OPPO', 'OPPO Find X9 Ultra', '骁龙8 Elite Gen5', '7050mAh', 7050, '¥7,499 起', 7499, 'FindX9 Ultra.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (45, 'OPPO', 'OPPO Find X9s Pro', '天玑 9500', '7025mAh', 7025, '¥5,299 起', 5299, 'FindX9s Pro.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (46, 'OPPO', 'OPPO Find N6', '骁龙8 Elite', '6000mAh', 6000, '¥9,999 起', 9999, 'FindN6.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (47, 'OPPO', 'OPPO Find X9 Pro', '天玑 9500', '7500mAh', 7500, '¥4,799 起', 4799, 'FindX9 Pro.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (48, 'OPPO', 'OPPO Find X9', '天玑 9500', '7500mAh', 7500, '¥3,999 起', 3999, 'FindX9.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (49, 'OPPO', 'OPPO Find X8 Ultra', '骁龙8 至尊版', '6100mAh', 6100, '¥5,999 起', 5999, 'FindX8 Ultra.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (50, 'OPPO', 'OPPO Find X8s+', '天玑 9400+', '6000mAh', 6000, '¥3,619 起', 3619, 'FindX8s+.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (51, 'OPPO', 'OPPO Find X8s', '天玑 9400+', '5700mAh', 5700, '¥3,399 起', 3399, 'FindX8s.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (52, 'OPPO', 'OPPO Find X8 Pro', '天玑 9400', '5910mAh', 5910, '¥5,299 起', 5299, 'FindX8 Pro.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (53, 'OPPO', 'OPPO Find X8', '天玑 9400', '5630mAh', 5630, '¥3,399 起', 3399, 'FindX8.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (54, 'OPPO', '一加 15', '骁龙 8Elite Gen5', '7300mAh', 7300, '¥4,499 起', 4499, '1+15.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (55, 'OPPO', '一加 13', '骁龙 8 至尊版', '6000mAh', 6000, '¥4,499 起', 4499, '1+13.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (56, 'OPPO', '一加 12', '骁龙 8 Gen3', '5400mAh', 5400, '¥4,299 起', 4299, '1+12.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (57, 'vivo', 'vivo X300 U;tra', '骁龙 8Elite Gen5', '6600mAh', 6600, '¥6,999 起', 6999, 'X300Ultra.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (58, 'vivo', 'vivo X300 Pro', '天玑 9500', '6510mAh', 6510, '¥5,599 起', 5599, 'X300Pro.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (59, 'vivo', 'vivo X300s', '天玑 9500', '7100mAh', 7100, '¥4,999 起', 4999, 'X300s.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (60, 'vivo', 'vivo X300', '天玑 9500', '6040mAh', 6040, '¥4,599 起', 4599, 'X300.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (61, 'vivo', 'iQOO 15', '骁龙 8Elite Gen5', '7000mAh', 7000, '¥4,599 起', 4599, 'iQOO15.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (62, 'vivo', 'iQOO 13', '骁龙 8 至尊版', '6150mAh', 6150, '¥3,999 起', 3999, 'iQOO13.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (63, '荣耀', '荣耀 Magic7 Pro', '骁龙 8 至尊版', '5850mAh', 5850, '¥5,699 起', 5699, 'Magic7Pro.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (64, '魅族', '魅族 21 Pro', '骁龙 8 Gen 3', '5050mAh', 5050, '¥4,999 起', 4999, 'MEIZU 21Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (65, 'Apple', 'iPhone 17 Pro Max', 'A19 Pro', '4823mAh', 4823, '¥9,999 起', 9999, '17ProMax.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (66, 'Apple', 'iPhone 17 Pro', 'A19 Pro', '3988mAh', 3988, '¥8,999 起', 8999, '17Pro.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (67, 'Apple', 'iPhone Air', 'A19 Pro(5核CPU)', '3036mAh', 3036, '¥7,999 起', 7999, 'iPhone Air.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (68, 'Apple', 'iPhone 17', 'A19', '3692mAh', 3692, '¥5,999 起', 5999, '17.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (69, 'Apple', 'iPhone 17e', 'A19(4核GPU)', '4005mAh', 4005, '¥4,499 起', 4499, '17e.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (70, 'Apple', 'iPhone 16 Pro Max', 'A18Pro', '4685mAh', 4685, '¥9,999 起', 9999, '16ProMax.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (71, 'Apple', 'iPhone 16 Pro', 'A18Pro', '3582mAh', 3582, '¥8,999 起', 8999, '16Pro.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (72, 'Apple', 'iPhone 16Plus', 'A18', '4674mAh', 4674, '¥5,999 起', 5999, '16Plus.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (73, 'Apple', 'iPhone 16', 'A18', '3561mAh', 3561, '¥5,199 起', 5199, '16.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (74, 'Apple', 'iPhone 16e', 'A18', '3561mAh', 3561, '¥4,499 起', 4499, '16e.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (75, 'Apple', 'iPhone 15 Pro Max', 'A17Pro', '4422mAh', 4422, '¥9,999 起', 9999, '15ProMax.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (76, 'Apple', 'iPhone 15 Pro', 'A17Pro', '3274mAh', 3274, '¥8,999 起', 8999, '15Pro.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (77, 'Apple', 'iPhone 15Plus', 'A16', '4383mAh', 4383, '¥5,999 起', 5999, '15Plus.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (78, 'Apple', 'iPhone 15', 'A16', '3349mAh', 3349, '¥5,199 起', 5199, '15.png', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (79, '三星', 'Samsung Galaxy S26 Ultra', '骁龙 8Elite Gen5 for Galaxy', '5000mAh', 5000, '¥9,999 起', 9999, 'Galaxy-S26-Ultra.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (80, '三星', 'Samsung Galaxy S26+', '骁龙 8Elite Gen5 for Galaxy', '4900mAh', 4900, '¥7,999 起', 7999, 'S26.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (81, '三星', 'Samsung Galaxy S26', '骁龙 8Elite Gen5 for Galaxy', '4300mAh', 4300, '¥5,999 起', 5999, 'S26.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);
INSERT INTO `phone_models` VALUES (82, '三星', 'Samsung Galaxy S25 Ultra', '骁龙 8 至尊版 for Galaxy', '5000mAh', 5000, '¥9,699 起', 9699, 'S25Ultra.jpg', '2026-05-21 12:38:51', '2026-05-21 12:38:51', NULL);

-- ----------------------------
-- Table structure for system_logs
-- ----------------------------
DROP TABLE IF EXISTS `system_logs`;
CREATE TABLE `system_logs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `operator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'system',
  `module` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '系统',
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'success',
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'info',
  `ip` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 290 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of system_logs
-- ----------------------------
INSERT INTO `system_logs` VALUES (1, 'user001', '登录认证', '用户登录', 'success', 'info', '59.138.63.231', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '登录成功', '2026-05-28 08:35:53');
INSERT INTO `system_logs` VALUES (2, 'system', '文章管理', '收藏文章', 'success', 'info', '59.138.63.231', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '收藏成功', '2026-05-28 08:35:57');
INSERT INTO `system_logs` VALUES (3, 'user001', '登录认证', '管理员登录', 'fail', 'error', '59.138.63.231', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '管理员账号或密码错误', '2026-05-28 08:36:45');
INSERT INTO `system_logs` VALUES (4, 'admin1', '登录认证', '管理员登录', 'success', 'info', '59.138.63.231', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '管理员登录成功', '2026-05-28 08:37:24');
INSERT INTO `system_logs` VALUES (5, 'user001', '登录认证', '用户登录', 'success', 'info', '59.138.63.231', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '登录成功', '2026-05-28 09:06:52');
INSERT INTO `system_logs` VALUES (6, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-05-28 14:05:32');
INSERT INTO `system_logs` VALUES (7, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-05-28 14:05:44');
INSERT INTO `system_logs` VALUES (8, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-28 14:05:58');
INSERT INTO `system_logs` VALUES (9, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-05-28 14:06:08');
INSERT INTO `system_logs` VALUES (10, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-28 14:06:20');
INSERT INTO `system_logs` VALUES (11, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-05-28 14:06:32');
INSERT INTO `system_logs` VALUES (12, 'system', '系统接口', 'POST /app', 'fail', 'error', '124.198.131.22', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-05-28 19:42:39');
INSERT INTO `system_logs` VALUES (13, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-05-29 01:05:29');
INSERT INTO `system_logs` VALUES (14, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-05-29 01:05:29');
INSERT INTO `system_logs` VALUES (15, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-05-29 01:05:39');
INSERT INTO `system_logs` VALUES (16, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-05-29 01:05:39');
INSERT INTO `system_logs` VALUES (17, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-05-29 01:05:50');
INSERT INTO `system_logs` VALUES (18, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-29 01:05:50');
INSERT INTO `system_logs` VALUES (19, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-05-29 01:06:01');
INSERT INTO `system_logs` VALUES (20, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-05-29 01:06:01');
INSERT INTO `system_logs` VALUES (21, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-05-29 01:06:11');
INSERT INTO `system_logs` VALUES (22, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-29 01:06:11');
INSERT INTO `system_logs` VALUES (23, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-05-29 01:06:23');
INSERT INTO `system_logs` VALUES (24, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-05-29 01:06:23');
INSERT INTO `system_logs` VALUES (25, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-29 06:39:15');
INSERT INTO `system_logs` VALUES (26, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-05-29 06:39:19');
INSERT INTO `system_logs` VALUES (27, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-05-29 06:39:22');
INSERT INTO `system_logs` VALUES (28, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-29 06:39:26');
INSERT INTO `system_logs` VALUES (29, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-05-29 06:39:30');
INSERT INTO `system_logs` VALUES (30, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-05-29 06:39:35');
INSERT INTO `system_logs` VALUES (31, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-05-29 06:39:39');
INSERT INTO `system_logs` VALUES (32, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-05-29 06:39:44');
INSERT INTO `system_logs` VALUES (33, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-29 06:39:50');
INSERT INTO `system_logs` VALUES (34, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-05-29 06:39:55');
INSERT INTO `system_logs` VALUES (35, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-05-29 06:40:00');
INSERT INTO `system_logs` VALUES (36, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-29 06:40:07');
INSERT INTO `system_logs` VALUES (37, 'system', '系统接口', 'POST /sdk', 'fail', 'error', '39.100.86.191', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', '接口不存在', '2026-05-29 08:11:21');
INSERT INTO `system_logs` VALUES (38, 'manba', '文章管理', '新增文章', 'success', 'info', '112.49.95.203', 'Apifox/1.0.0 (https://apifox.com)', '新增文章成功', '2026-05-29 09:42:33');
INSERT INTO `system_logs` VALUES (39, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-05-29 10:41:02');
INSERT INTO `system_logs` VALUES (40, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.22', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-05-29 10:51:03');
INSERT INTO `system_logs` VALUES (41, 'system', '系统接口', 'POST /', 'fail', 'error', '124.198.131.22', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-05-29 11:33:26');
INSERT INTO `system_logs` VALUES (42, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-05-30 10:57:37');
INSERT INTO `system_logs` VALUES (43, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-05-30 10:57:46');
INSERT INTO `system_logs` VALUES (44, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-30 10:57:55');
INSERT INTO `system_logs` VALUES (45, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-05-30 10:58:06');
INSERT INTO `system_logs` VALUES (46, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-05-30 10:58:16');
INSERT INTO `system_logs` VALUES (47, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-05-30 10:58:27');
INSERT INTO `system_logs` VALUES (48, 'system', '系统接口', 'POST /', 'fail', 'error', '176.65.139.27', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', '接口不存在', '2026-05-30 12:45:13');
INSERT INTO `system_logs` VALUES (49, 'system', '系统接口', 'POST /api', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-05-30 13:53:51');
INSERT INTO `system_logs` VALUES (50, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-05-30 23:11:03');
INSERT INTO `system_logs` VALUES (51, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-05-30 23:11:03');
INSERT INTO `system_logs` VALUES (52, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-05-30 23:11:15');
INSERT INTO `system_logs` VALUES (53, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-05-30 23:11:15');
INSERT INTO `system_logs` VALUES (54, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-05-30 23:11:27');
INSERT INTO `system_logs` VALUES (55, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-30 23:11:28');
INSERT INTO `system_logs` VALUES (56, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-05-30 23:11:39');
INSERT INTO `system_logs` VALUES (57, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-05-30 23:11:39');
INSERT INTO `system_logs` VALUES (58, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-30 23:11:53');
INSERT INTO `system_logs` VALUES (59, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-05-30 23:11:54');
INSERT INTO `system_logs` VALUES (60, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-05-30 23:12:06');
INSERT INTO `system_logs` VALUES (61, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-05-30 23:12:07');
INSERT INTO `system_logs` VALUES (62, 'system', '系统接口', 'POST /api/ai-chat', 'success', 'info', '59.138.63.231', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '请求成功', '2026-05-31 10:51:41');
INSERT INTO `system_logs` VALUES (63, 'system', '系统接口', 'POST /api/ai-chat', 'success', 'info', '59.138.63.231', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '请求成功', '2026-05-31 10:52:56');
INSERT INTO `system_logs` VALUES (64, 'user001', '登录认证', '用户登录', 'success', 'info', '160.16.73.200', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '登录成功', '2026-05-31 12:00:45');
INSERT INTO `system_logs` VALUES (65, 'gin', '登录认证', '用户登录', 'success', 'info', '160.16.146.216', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '登录成功', '2026-05-31 12:04:58');
INSERT INTO `system_logs` VALUES (66, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-05-31 16:54:19');
INSERT INTO `system_logs` VALUES (67, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-05-31 16:54:32');
INSERT INTO `system_logs` VALUES (68, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-05-31 16:54:43');
INSERT INTO `system_logs` VALUES (69, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-05-31 16:54:57');
INSERT INTO `system_logs` VALUES (70, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-05-31 16:55:08');
INSERT INTO `system_logs` VALUES (71, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-05-31 16:55:20');
INSERT INTO `system_logs` VALUES (72, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-01 15:40:33');
INSERT INTO `system_logs` VALUES (73, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-01 15:40:34');
INSERT INTO `system_logs` VALUES (74, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-01 15:40:48');
INSERT INTO `system_logs` VALUES (75, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-01 15:40:49');
INSERT INTO `system_logs` VALUES (76, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-01 15:41:02');
INSERT INTO `system_logs` VALUES (77, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-01 15:41:04');
INSERT INTO `system_logs` VALUES (78, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-01 15:41:18');
INSERT INTO `system_logs` VALUES (79, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-01 15:41:19');
INSERT INTO `system_logs` VALUES (80, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-01 15:41:33');
INSERT INTO `system_logs` VALUES (81, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-01 15:41:34');
INSERT INTO `system_logs` VALUES (82, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-01 15:41:48');
INSERT INTO `system_logs` VALUES (83, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-01 15:41:49');
INSERT INTO `system_logs` VALUES (84, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-02 13:00:39');
INSERT INTO `system_logs` VALUES (85, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-02 13:54:00');
INSERT INTO `system_logs` VALUES (86, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-02 14:14:09');
INSERT INTO `system_logs` VALUES (87, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-02 14:50:44');
INSERT INTO `system_logs` VALUES (88, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-02 14:51:00');
INSERT INTO `system_logs` VALUES (89, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-02 14:51:14');
INSERT INTO `system_logs` VALUES (90, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-02 14:51:30');
INSERT INTO `system_logs` VALUES (91, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-02 14:51:43');
INSERT INTO `system_logs` VALUES (92, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-02 14:51:59');
INSERT INTO `system_logs` VALUES (93, 'admin1', '登录认证', '管理员登录', 'success', 'info', '112.51.228.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '管理员登录成功', '2026-06-03 02:17:51');
INSERT INTO `system_logs` VALUES (94, 'system', '电脑型号', '新增电脑型号', 'success', 'info', '112.51.228.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '新增电脑型号成功', '2026-06-03 02:19:56');
INSERT INTO `system_logs` VALUES (95, 'system', '系统接口', 'POST /api/ai-chat', 'success', 'info', '112.51.228.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '请求成功', '2026-06-03 02:26:30');
INSERT INTO `system_logs` VALUES (96, 'system', '系统接口', 'POST /api/ai-chat', 'success', 'info', '112.51.228.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '请求成功', '2026-06-03 02:26:46');
INSERT INTO `system_logs` VALUES (97, 'system', '系统接口', 'POST /api/ai-chat', 'success', 'info', '112.51.228.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '请求成功', '2026-06-03 02:26:58');
INSERT INTO `system_logs` VALUES (98, 'system', '系统接口', 'POST /api/ai-chat', 'success', 'info', '112.51.228.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '请求成功', '2026-06-03 02:27:23');
INSERT INTO `system_logs` VALUES (99, 'gin', '登录认证', '用户登录', 'success', 'info', '107.148.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '登录成功', '2026-06-03 02:38:37');
INSERT INTO `system_logs` VALUES (100, 'admin1', '登录认证', '管理员登录', 'success', 'info', '107.148.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '管理员登录成功', '2026-06-03 02:40:20');
INSERT INTO `system_logs` VALUES (101, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-03 02:45:51');
INSERT INTO `system_logs` VALUES (102, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-03 02:46:03');
INSERT INTO `system_logs` VALUES (103, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-03 02:46:16');
INSERT INTO `system_logs` VALUES (104, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-03 02:46:27');
INSERT INTO `system_logs` VALUES (105, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-03 02:46:39');
INSERT INTO `system_logs` VALUES (106, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-03 02:46:51');
INSERT INTO `system_logs` VALUES (107, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-03 08:08:54');
INSERT INTO `system_logs` VALUES (108, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-03 08:09:04');
INSERT INTO `system_logs` VALUES (109, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-03 08:09:17');
INSERT INTO `system_logs` VALUES (110, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-03 08:09:28');
INSERT INTO `system_logs` VALUES (111, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-03 08:09:40');
INSERT INTO `system_logs` VALUES (112, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-03 08:09:51');
INSERT INTO `system_logs` VALUES (113, 'system', '系统接口', 'POST /app', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-03 09:48:54');
INSERT INTO `system_logs` VALUES (114, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-03 19:26:06');
INSERT INTO `system_logs` VALUES (115, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-03 19:26:18');
INSERT INTO `system_logs` VALUES (116, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-03 19:26:29');
INSERT INTO `system_logs` VALUES (117, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-03 19:26:40');
INSERT INTO `system_logs` VALUES (118, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-03 19:26:52');
INSERT INTO `system_logs` VALUES (119, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-03 19:27:03');
INSERT INTO `system_logs` VALUES (120, 'system', '系统接口', 'POST /mcp', 'fail', 'error', '45.156.129.75', 'python-httpx/0.28.1', '接口不存在', '2026-06-03 21:01:20');
INSERT INTO `system_logs` VALUES (121, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-03 21:50:08');
INSERT INTO `system_logs` VALUES (122, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-04 00:36:12');
INSERT INTO `system_logs` VALUES (123, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-04 00:36:24');
INSERT INTO `system_logs` VALUES (124, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-04 00:36:35');
INSERT INTO `system_logs` VALUES (125, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-04 00:36:45');
INSERT INTO `system_logs` VALUES (126, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-04 00:36:58');
INSERT INTO `system_logs` VALUES (127, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-04 00:37:09');
INSERT INTO `system_logs` VALUES (128, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-04 02:37:19');
INSERT INTO `system_logs` VALUES (129, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-04 11:23:49');
INSERT INTO `system_logs` VALUES (130, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-04 14:49:04');
INSERT INTO `system_logs` VALUES (131, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-04 19:45:28');
INSERT INTO `system_logs` VALUES (132, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-04 22:20:21');
INSERT INTO `system_logs` VALUES (133, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-04 22:20:21');
INSERT INTO `system_logs` VALUES (134, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-04 22:20:34');
INSERT INTO `system_logs` VALUES (135, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-04 22:20:34');
INSERT INTO `system_logs` VALUES (136, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-04 22:20:45');
INSERT INTO `system_logs` VALUES (137, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-04 22:20:45');
INSERT INTO `system_logs` VALUES (138, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-04 22:20:56');
INSERT INTO `system_logs` VALUES (139, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-04 22:20:56');
INSERT INTO `system_logs` VALUES (140, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-04 22:21:08');
INSERT INTO `system_logs` VALUES (141, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-04 22:21:09');
INSERT INTO `system_logs` VALUES (142, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-04 22:21:20');
INSERT INTO `system_logs` VALUES (143, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-04 22:21:20');
INSERT INTO `system_logs` VALUES (144, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-04 23:08:24');
INSERT INTO `system_logs` VALUES (145, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-05 08:44:04');
INSERT INTO `system_logs` VALUES (146, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-05 09:42:20');
INSERT INTO `system_logs` VALUES (147, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-05 09:42:32');
INSERT INTO `system_logs` VALUES (148, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-05 09:42:44');
INSERT INTO `system_logs` VALUES (149, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-05 09:42:55');
INSERT INTO `system_logs` VALUES (150, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-05 09:43:07');
INSERT INTO `system_logs` VALUES (151, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-05 09:43:15');
INSERT INTO `system_logs` VALUES (152, 'system', '系统接口', 'POST /app', 'fail', 'error', '', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-05 18:31:49');
INSERT INTO `system_logs` VALUES (153, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-05 19:28:33');
INSERT INTO `system_logs` VALUES (154, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-05 20:42:12');
INSERT INTO `system_logs` VALUES (155, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-05 20:42:23');
INSERT INTO `system_logs` VALUES (156, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-05 20:42:35');
INSERT INTO `system_logs` VALUES (157, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-05 20:42:46');
INSERT INTO `system_logs` VALUES (158, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-05 20:42:58');
INSERT INTO `system_logs` VALUES (159, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-05 20:43:10');
INSERT INTO `system_logs` VALUES (160, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-06 01:56:34');
INSERT INTO `system_logs` VALUES (161, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-06 01:56:46');
INSERT INTO `system_logs` VALUES (162, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-06 01:56:59');
INSERT INTO `system_logs` VALUES (163, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-06 01:57:09');
INSERT INTO `system_logs` VALUES (164, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-06 01:57:21');
INSERT INTO `system_logs` VALUES (165, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-06 01:57:32');
INSERT INTO `system_logs` VALUES (166, 'system', '系统接口', 'POST /api', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-06 03:48:48');
INSERT INTO `system_logs` VALUES (167, 'system', '系统接口', 'POST /', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-06 05:08:17');
INSERT INTO `system_logs` VALUES (168, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-06 14:12:46');
INSERT INTO `system_logs` VALUES (169, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-06 17:38:20');
INSERT INTO `system_logs` VALUES (170, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-06 18:40:41');
INSERT INTO `system_logs` VALUES (171, 'system', '系统接口', 'POST /', 'fail', 'error', '45.198.224.22', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36 Assetnote/1.0.0', '接口不存在', '2026-06-06 19:32:51');
INSERT INTO `system_logs` VALUES (172, 'system', '系统接口', 'POST /', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-06 21:41:27');
INSERT INTO `system_logs` VALUES (173, 'system', '系统接口', 'POST /api', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-06 23:34:14');
INSERT INTO `system_logs` VALUES (174, 'system', '系统接口', 'POST /api', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-07 07:29:44');
INSERT INTO `system_logs` VALUES (175, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-07 10:02:55');
INSERT INTO `system_logs` VALUES (176, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-07 10:03:02');
INSERT INTO `system_logs` VALUES (177, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-07 10:03:02');
INSERT INTO `system_logs` VALUES (178, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-07 10:03:11');
INSERT INTO `system_logs` VALUES (179, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-07 10:03:11');
INSERT INTO `system_logs` VALUES (180, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-07 10:03:20');
INSERT INTO `system_logs` VALUES (181, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-07 10:03:20');
INSERT INTO `system_logs` VALUES (182, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-07 10:03:30');
INSERT INTO `system_logs` VALUES (183, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-07 10:03:30');
INSERT INTO `system_logs` VALUES (184, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-07 10:03:40');
INSERT INTO `system_logs` VALUES (185, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-07 10:03:40');
INSERT INTO `system_logs` VALUES (186, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-07 10:03:49');
INSERT INTO `system_logs` VALUES (187, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-07 14:43:23');
INSERT INTO `system_logs` VALUES (188, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-07 15:27:11');
INSERT INTO `system_logs` VALUES (189, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-07 15:27:11');
INSERT INTO `system_logs` VALUES (190, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-07 15:27:22');
INSERT INTO `system_logs` VALUES (191, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-07 15:27:22');
INSERT INTO `system_logs` VALUES (192, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-07 15:27:33');
INSERT INTO `system_logs` VALUES (193, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-07 15:27:33');
INSERT INTO `system_logs` VALUES (194, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-07 15:27:44');
INSERT INTO `system_logs` VALUES (195, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-07 15:27:44');
INSERT INTO `system_logs` VALUES (196, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-07 15:27:55');
INSERT INTO `system_logs` VALUES (197, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-07 15:27:55');
INSERT INTO `system_logs` VALUES (198, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-07 15:28:06');
INSERT INTO `system_logs` VALUES (199, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-07 15:28:06');
INSERT INTO `system_logs` VALUES (200, 'system', '系统接口', 'POST /', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-07 16:28:40');
INSERT INTO `system_logs` VALUES (201, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-07 23:08:12');
INSERT INTO `system_logs` VALUES (202, 'system', '系统接口', 'POST /_next', 'fail', 'error', '', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-08 03:21:42');
INSERT INTO `system_logs` VALUES (203, 'system', '系统接口', 'POST /app', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-08 04:32:32');
INSERT INTO `system_logs` VALUES (204, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-08 06:15:39');
INSERT INTO `system_logs` VALUES (205, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-08 07:03:57');
INSERT INTO `system_logs` VALUES (206, 'system', '系统接口', 'POST /api', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-08 11:48:11');
INSERT INTO `system_logs` VALUES (207, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-08 13:00:39');
INSERT INTO `system_logs` VALUES (208, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-08 13:00:40');
INSERT INTO `system_logs` VALUES (209, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-08 13:00:41');
INSERT INTO `system_logs` VALUES (210, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-08 13:00:42');
INSERT INTO `system_logs` VALUES (211, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-08 13:00:44');
INSERT INTO `system_logs` VALUES (212, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-08 13:00:45');
INSERT INTO `system_logs` VALUES (213, 'user001', '登录认证', '用户登录', 'success', 'info', '112.51.229.126', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '登录成功', '2026-06-08 14:44:40');
INSERT INTO `system_logs` VALUES (214, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-08 21:23:53');
INSERT INTO `system_logs` VALUES (215, 'system', '系统接口', 'POST /app', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 00:59:25');
INSERT INTO `system_logs` VALUES (216, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 02:51:28');
INSERT INTO `system_logs` VALUES (217, 'system', '系统接口', 'POST /', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 04:35:16');
INSERT INTO `system_logs` VALUES (218, 'system', '系统接口', 'POST /api', 'fail', 'error', '192.159.99.55', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 05:59:53');
INSERT INTO `system_logs` VALUES (219, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 06:16:47');
INSERT INTO `system_logs` VALUES (220, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 06:17:27');
INSERT INTO `system_logs` VALUES (221, 'system', '系统接口', 'POST /', 'fail', 'error', '', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 06:31:05');
INSERT INTO `system_logs` VALUES (222, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 07:59:23');
INSERT INTO `system_logs` VALUES (223, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 09:45:58');
INSERT INTO `system_logs` VALUES (224, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 12:13:24');
INSERT INTO `system_logs` VALUES (225, 'system', '系统接口', 'POST /', 'fail', 'error', '45.198.224.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36 Assetnote/1.0.0', '接口不存在', '2026-06-09 13:25:17');
INSERT INTO `system_logs` VALUES (226, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 16:01:10');
INSERT INTO `system_logs` VALUES (227, 'system', '系统接口', 'POST /', 'fail', 'error', '45.198.224.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36 Assetnote/1.0.0', '接口不存在', '2026-06-09 16:06:36');
INSERT INTO `system_logs` VALUES (228, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-09 16:11:58');
INSERT INTO `system_logs` VALUES (229, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-09 16:11:58');
INSERT INTO `system_logs` VALUES (230, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-09 16:12:10');
INSERT INTO `system_logs` VALUES (231, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-09 16:12:10');
INSERT INTO `system_logs` VALUES (232, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-09 16:12:20');
INSERT INTO `system_logs` VALUES (233, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-09 16:12:20');
INSERT INTO `system_logs` VALUES (234, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-09 16:12:31');
INSERT INTO `system_logs` VALUES (235, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-09 16:12:31');
INSERT INTO `system_logs` VALUES (236, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-09 16:12:41');
INSERT INTO `system_logs` VALUES (237, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-09 16:12:41');
INSERT INTO `system_logs` VALUES (238, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-09 16:12:51');
INSERT INTO `system_logs` VALUES (239, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-09 16:12:51');
INSERT INTO `system_logs` VALUES (240, 'system', '系统接口', 'POST /_next', 'fail', 'error', '', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 17:55:55');
INSERT INTO `system_logs` VALUES (241, 'system', '系统接口', 'POST /app', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 22:24:19');
INSERT INTO `system_logs` VALUES (242, 'system', '系统接口', 'POST /', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-09 23:30:00');
INSERT INTO `system_logs` VALUES (243, 'admin1', '登录认证', '管理员登录', 'success', 'info', '112.51.229.126', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '管理员登录成功', '2026-06-10 02:36:25');
INSERT INTO `system_logs` VALUES (244, 'system', '系统接口', 'POST /api', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-10 03:20:15');
INSERT INTO `system_logs` VALUES (245, 'user001', '登录认证', '用户登录', 'success', 'info', '142.91.109.23', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '登录成功', '2026-06-10 04:59:20');
INSERT INTO `system_logs` VALUES (246, 'user001', '登录认证', '用户登录', 'success', 'info', '142.91.109.23', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '登录成功', '2026-06-10 04:59:43');
INSERT INTO `system_logs` VALUES (247, 'user001', '用户信息', '修改用户', 'success', 'info', '112.51.229.126', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '修改用户成功', '2026-06-10 05:33:37');
INSERT INTO `system_logs` VALUES (248, 'user001', '用户信息', '修改用户', 'success', 'info', '112.51.229.126', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '修改用户成功', '2026-06-10 05:35:09');
INSERT INTO `system_logs` VALUES (249, 'user001', '用户信息', '修改用户', 'success', 'info', '112.51.229.126', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '修改用户成功', '2026-06-10 05:35:32');
INSERT INTO `system_logs` VALUES (250, 'system', '系统接口', 'POST /', 'fail', 'error', '45.198.224.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36 Assetnote/1.0.0', '接口不存在', '2026-06-10 06:26:37');
INSERT INTO `system_logs` VALUES (251, 'system', '系统接口', 'POST /', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-10 15:04:01');
INSERT INTO `system_logs` VALUES (252, 'system', '系统接口', 'POST /app', 'fail', 'error', '192.159.99.55', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-10 16:05:10');
INSERT INTO `system_logs` VALUES (253, 'system', '系统接口', 'POST /api', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-10 16:14:51');
INSERT INTO `system_logs` VALUES (254, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-10 22:02:38');
INSERT INTO `system_logs` VALUES (255, 'system', '系统接口', 'POST /api', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-11 02:22:36');
INSERT INTO `system_logs` VALUES (256, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-11 06:21:36');
INSERT INTO `system_logs` VALUES (257, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-11 06:21:36');
INSERT INTO `system_logs` VALUES (258, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-11 06:21:46');
INSERT INTO `system_logs` VALUES (259, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-11 06:21:46');
INSERT INTO `system_logs` VALUES (260, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-11 06:21:57');
INSERT INTO `system_logs` VALUES (261, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-11 06:21:58');
INSERT INTO `system_logs` VALUES (262, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-11 06:22:09');
INSERT INTO `system_logs` VALUES (263, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; U; Android 4.2.2; he-il; NEO-X5-116A Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30', '接口不存在', '2026-06-11 06:22:09');
INSERT INTO `system_logs` VALUES (264, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', '接口不存在', '2026-06-11 06:22:20');
INSERT INTO `system_logs` VALUES (265, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-11 06:22:20');
INSERT INTO `system_logs` VALUES (266, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-11 06:22:32');
INSERT INTO `system_logs` VALUES (267, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-11 06:22:32');
INSERT INTO `system_logs` VALUES (268, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-11 08:14:35');
INSERT INTO `system_logs` VALUES (269, 'user001', '登录认证', '用户登录', 'success', 'info', '112.51.229.126', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '登录成功', '2026-06-11 11:11:01');
INSERT INTO `system_logs` VALUES (270, 'system', '系统接口', 'POST /', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-11 12:03:55');
INSERT INTO `system_logs` VALUES (271, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-11 12:13:28');
INSERT INTO `system_logs` VALUES (272, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-11 14:25:22');
INSERT INTO `system_logs` VALUES (273, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-11 17:34:17');
INSERT INTO `system_logs` VALUES (274, 'system', '系统接口', 'POST /api', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-11 19:16:15');
INSERT INTO `system_logs` VALUES (275, 'system', '系统接口', 'POST /_next', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-11 19:33:43');
INSERT INTO `system_logs` VALUES (276, 'system', '系统接口', 'POST /app', 'fail', 'error', '124.198.131.39', 'Mozilla/5.0 (rondo2012@atomicmail.io)', '接口不存在', '2026-06-12 02:21:08');
INSERT INTO `system_logs` VALUES (277, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.135 Mobile Safari/537.36', '接口不存在', '2026-06-12 04:08:58');
INSERT INTO `system_logs` VALUES (278, 'system', '系统接口', 'POST /', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-12 04:08:58');
INSERT INTO `system_logs` VALUES (279, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-12 04:09:08');
INSERT INTO `system_logs` VALUES (280, 'system', '系统接口', 'POST /_next', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-12 04:09:09');
INSERT INTO `system_logs` VALUES (281, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-12 04:09:19');
INSERT INTO `system_logs` VALUES (282, 'system', '系统接口', 'POST /api', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 14; SM-F9560 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36', '接口不存在', '2026-06-12 04:09:20');
INSERT INTO `system_logs` VALUES (283, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Linux; Android 9; AFTWMST22 Build/PS7233; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.152 Mobile Safari/537.36', '接口不存在', '2026-06-12 04:09:31');
INSERT INTO `system_logs` VALUES (284, 'system', '系统接口', 'POST /_next/server', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-12 04:09:31');
INSERT INTO `system_logs` VALUES (285, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-12 04:09:41');
INSERT INTO `system_logs` VALUES (286, 'system', '系统接口', 'POST /app', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.', '接口不存在', '2026-06-12 04:09:42');
INSERT INTO `system_logs` VALUES (287, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', '接口不存在', '2026-06-12 04:09:53');
INSERT INTO `system_logs` VALUES (288, 'system', '系统接口', 'POST /api/route', 'fail', 'error', '160.119.71.12', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1', '接口不存在', '2026-06-12 04:09:53');
INSERT INTO `system_logs` VALUES (289, 'gin', '登录认证', '用户登录', 'success', 'info', '112.49.95.166', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '登录成功', '2026-06-12 05:21:57');

-- ----------------------------
-- Table structure for user_favorite_devices
-- ----------------------------
DROP TABLE IF EXISTS `user_favorite_devices`;
CREATE TABLE `user_favorite_devices`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `device_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `device_brand` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `device_model` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `device_price` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `device_specs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_device`(`username` ASC, `device_type` ASC, `device_model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_favorite_devices
-- ----------------------------
INSERT INTO `user_favorite_devices` VALUES (1, 'user001', 'phone', 'Apple', 'iPhone 15', '5999', 'A16芯片，6.1英寸屏幕，128GB');
INSERT INTO `user_favorite_devices` VALUES (2, 'user001', 'phone', '华为', 'HUAWEI Mate 60', '¥4999 起', '处理器：麒麟9000S；电池：4750mAh');
INSERT INTO `user_favorite_devices` VALUES (3, 'user001', 'computer', 'Apple', 'MacBook Pro 14 M4 Pro', '¥16999 起', '处理器：Apple M4 Pro；显卡：至高 16 核 GPU；内存：24GB；硬盘：1TB SSD');
INSERT INTO `user_favorite_devices` VALUES (4, 'admin1', 'phone', 'Apple', 'iPhone 15', '¥5,199 起', '处理器：A16；电池：3349mAh');
INSERT INTO `user_favorite_devices` VALUES (5, 'gin', 'phone', 'Apple', 'iPhone 16 Pro', '¥8,999 起', '处理器：A18Pro；电池：3582mAh');
INSERT INTO `user_favorite_devices` VALUES (6, 'gin', 'phone', '魅族', '魅族 21 Pro', '¥4,999 起', '处理器：骁龙 8 Gen 3；电池：5050mAh');
INSERT INTO `user_favorite_devices` VALUES (13, 'user001', 'computer', '荣耀', '荣耀MagicBook Pro 14 2025', '6799', '处理器：酷睿 Ultra 5 255H/ultra 9 285H；显卡：Intel® Arc™ 130T GPU/Intel® Arc™ 140T GPU；内存：32GB；硬盘：1TB SSD');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'user',
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (2, 'user001', '654321', '2026-05-14 13:29:23', '123456@qq.com', 'user', '热爱科技，专注硬件评测与数码产品分析。');
INSERT INTO `users` VALUES (4, 'manba', '123456', '2026-05-14 13:52:02', '11@qq.com', 'user', NULL);
INSERT INTO `users` VALUES (5, 'user003', '123456', '2026-05-15 13:42:40', 'user003@qq.com', 'user', NULL);
INSERT INTO `users` VALUES (6, 'man', '123456', '2026-05-20 05:05:54', '114@qq.com', 'user', NULL);
INSERT INTO `users` VALUES (7, 'gin', '123456', '2026-05-20 08:02:34', 'cole36620@gmail.com', 'user', 'oh my gin');
INSERT INTO `users` VALUES (8, 'gin1', '123456', '2026-05-20 08:17:08', 'gin@gmail.com', 'user', NULL);
INSERT INTO `users` VALUES (9, 'admin1', '123456', '2026-05-25 12:44:54', 'admin@gmail.com', 'ADMIN', NULL);

SET FOREIGN_KEY_CHECKS = 1;
