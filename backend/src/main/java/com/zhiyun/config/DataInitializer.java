package com.zhiyun.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.zhiyun.entity.*;
import com.zhiyun.repository.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.*;

/**
 * 数据库种子初始化器 —— 移植自 prisma/seed.mjs
 * 仅在数据库为空（无分类）时执行，避免重复写入
 */
@Slf4j
@Component
@org.springframework.core.annotation.Order(1)
public class DataInitializer implements CommandLineRunner {

    private static final ObjectMapper M = new ObjectMapper();

    @Autowired private CategoryRepository categoryRepo;
    @Autowired private ProductRepository productRepo;
    @Autowired private UserRepository userRepo;
    @Autowired private AddressRepository addressRepo;
    @Autowired private ReviewRepository reviewRepo;
    @Autowired private OrderRepository orderRepo;
    @Autowired private OrderItemRepository orderItemRepo;
    @Autowired private LeadRepository leadRepo;

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(10);

    @Override
    public void run(String... args) throws Exception {
        if (categoryRepo.count() > 0) {
            log.info("数据库已存在种子数据，跳过初始化");
            return;
        }
        log.info("开始写入种子数据...");

        // 分类
        Map<String, Category> cats = new LinkedHashMap<>();
        for (Object[] c : new Object[][]{
                {"duvets", "被芯", "Duvets & Comforters", "云感深睡，四季安然", 1},
                {"pillows", "枕芯", "Pillows", "承托之道，一夜安眠", 2},
                {"bedding-sets", "床品套件", "Bedding Sets", "肌肤的第二层触感", 3},
                {"summer", "夏凉系列", "Summer Series", "清风入梦，凉而不冰", 4},
                {"gifts", "礼盒系列", "Gift Boxes", "以东方之礼，赠重要之人", 5}
        }) {
            Category cat = new Category();
            cat.setSlug((String) c[0]);
            cat.setName((String) c[1]);
            cat.setNameEn((String) c[2]);
            cat.setTagline((String) c[3]);
            cat.setSort((Integer) c[4]);
            cats.put(cat.getSlug(), categoryRepo.save(cat));
        }

        // 商品
        Map<String, Product> prods = new LinkedHashMap<>();
        for (Object[] p : buildProducts()) {
            Product prod = new Product();
            prod.setSlug((String) p[0]);
            prod.setName((String) p[1]);
            prod.setSubtitle((String) p[2]);
            prod.setDescription((String) p[4]);
            prod.setStory((String) p[5]);
            prod.setPriceFen((Integer) p[6]);
            prod.setCompareAtFen((Integer) p[7]);
            prod.setImages((String) p[8]);
            prod.setMaterial((String) p[9]);
            prod.setSpecs((String) p[10]);
            prod.setFeatured((Boolean) p[11]);
            prod.setSales((Integer) p[12]);
            prod.setStock((Integer) p[13]);
            prod.setCategoryId(cats.get(p[3]).getId());
            prod.setStatus("ACTIVE");
            prods.put(prod.getSlug(), productRepo.save(prod));
        }

        // 用户
        Map<String, User> users = new LinkedHashMap<>();
        for (Object[] u : new Object[][]{
                {"admin@zhiyun.cn", "织云管理员", "ADMIN", "admin123456", null},
                {"demo@zhiyun.cn", "沈知微", "CUSTOMER", "demo123456", "13800006666"},
                {"linww@example.com", "林晚晚", "CUSTOMER", "123456", null},
                {"chenyu@example.com", "陈屿", "CUSTOMER", "123456", null},
                {"suhe@example.com", "苏合", "CUSTOMER", "123456", null},
                {"gubc@example.com", "顾北辰", "CUSTOMER", "123456", null},
                {"baijin@example.com", "白槿", "CUSTOMER", "123456", null},
                {"jiangli@example.com", "江离", "CUSTOMER", "123456", null}
        }) {
            User user = new User();
            user.setEmail((String) u[0]);
            user.setName((String) u[1]);
            user.setRole((String) u[2]);
            user.setPasswordHash(encoder.encode((String) u[3]));
            user.setPhone((String) u[4]);
            users.put(user.getEmail(), userRepo.save(user));
        }

        // 默认地址
        Address addr = new Address();
        addr.setUserId(users.get("demo@zhiyun.cn").getId());
        addr.setName("沈知微");
        addr.setPhone("13800006666");
        addr.setProvince("浙江省");
        addr.setCity("杭州市");
        addr.setDistrict("西湖区");
        addr.setDetail("天目山路织云里 8 幢 1201 室");
        addr.setIsDefault(true);
        addressRepo.save(addr);

        // 评价
        for (Object[] r : new Object[][]{
                {"cloud-goose-down-duvet", "linww@example.com", 5, "像睡进一朵云里。北方的冬天暖气很足，这床被居然完全不闷，蓬松度名不虚传。"},
                {"cloud-goose-down-duvet", "chenyu@example.com", 5, "给父母买的，二老说比国外买的某大牌还要暖和轻盈，客服也很耐心。"},
                {"silk-mulberry-duvet", "suhe@example.com", 5, "蚕丝被贴身的那种柔软很难形容，就是睡下去不想起来。包装也极有质感，送礼体面。"},
                {"deep-sleep-pillow", "gubc@example.com", 4, "颈椎承托区的设计确实到位，温感微微发热很舒服，唯一希望出个更矮的款。"},
                {"zero-pressure-pillow", "linww@example.com", 5, "慢回弹真的零压，侧睡肩膀不酸了。已经回购第二只给男朋友。"},
                {"mu-jin-60s-set", "baijin@example.com", 5, "暮金色比图片更温柔，缎纹的垂坠感一铺上床整个卧室都高级了。"},
                {"monet-garden-set", "jiangli@example.com", 5, "印花渐变太美了，没有任何色差和异味，朋友以为是美术馆的联名。"},
                {"wedding-gift-box", "chenyu@example.com", 5, "闺蜜结婚送的，苏绣礼盒一打开全场惊叹，绣工确实是大师级。"}
        }) {
            Review review = new Review();
            review.setProductId(prods.get(r[0]).getId());
            review.setUserId(users.get(r[1]).getId());
            review.setRating((Integer) r[2]);
            review.setContent((String) r[3]);
            reviewRepo.save(review);
        }

        // 示例订单
        Map<String, Object> addrJson = new LinkedHashMap<>();
        addrJson.put("name", "沈知微");
        addrJson.put("phone", "13800006666");
        addrJson.put("region", "浙江省 杭州市 西湖区");
        addrJson.put("detail", "天目山路织云里 8 幢 1201 室");
        String addrJsonStr = M.writeValueAsString(addrJson);

        Date d1 = new Date(System.currentTimeMillis() - 2L * 86400 * 1000);
        Order o1 = new Order();
        o1.setOrderNo("ZY20260905-238801");
        o1.setStatus("PAID");
        o1.setTotalFen(339800);
        o1.setUserId(users.get("demo@zhiyun.cn").getId());
        o1.setAddressJson(addrJsonStr);
        o1.setCreatedAt(d1);
        o1.setPaidAt(d1);
        o1.setPayMethod("WECHAT");
        o1 = orderRepo.save(o1);
        addOrderItem(o1, prods.get("cloud-goose-down-duvet"), "/images/products/p01.svg", 1);
        addOrderItem(o1, prods.get("zero-pressure-pillow"), "/images/products/p04.svg", 1);

        Order o2 = new Order();
        o2.setOrderNo("ZY20260906-410927");
        o2.setStatus("PENDING_PAYMENT");
        o2.setTotalFen(129900);
        o2.setUserId(users.get("demo@zhiyun.cn").getId());
        o2.setAddressJson(addrJsonStr);
        o2 = orderRepo.save(o2);
        addOrderItem(o2, prods.get("mu-jin-60s-set"), "/images/products/p05.svg", 1);

        // 商机线索
        for (Object[] l : new Object[][]{
                {"FRANCHISE", "陈立寒", "13900001111", "意向杭州西湖区门店，面积约 80㎡，预算 30–50 万", "NEW"},
                {"GROUP_BUY", "林晓鸥", "13700002222", "公司年会采购 40 套枕芯，希望一个月内交付", "CONTACTED"},
                {"COOPERATION", "郑屿舟", "13600003333", "拟洽谈酒店渠道供应链合作", "CLOSED"}
        }) {
            Lead lead = new Lead();
            lead.setType((String) l[0]);
            lead.setName((String) l[1]);
            lead.setPhone((String) l[2]);
            lead.setNote((String) l[3]);
            lead.setStatus((String) l[4]);
            leadRepo.save(lead);
        }

        log.info("种子数据写入完成: 分类 {} · 商品 {} · 用户 {} · 评价 8 · 订单 2 · 线索 3",
                cats.size(), prods.size(), users.size());
    }

    private void addOrderItem(Order o, Product p, String imageSnap, int qty) {
        OrderItem oi = new OrderItem();
        oi.setOrderId(o.getId());
        oi.setProductId(p.getId());
        oi.setNameSnap(p.getName());
        oi.setImageSnap(imageSnap);
        oi.setPriceFen(p.getPriceFen());
        oi.setQty(qty);
        orderItemRepo.save(oi);
    }

    /** 商品定义数组：slug, name, subtitle, categorySlug, description, story, priceFen, compareAtFen, images(json), material, specs(json), featured, sales, stock */
    private List<Object[]> buildProducts() throws Exception {
        List<Object[]> list = new ArrayList<>();
        list.add(new Object[]{"cloud-goose-down-duvet", "「云绒」95白鹅绒被", "95% 白鹅绒 · 100支防绒棉面料", "duvets",
                "甄选北纬45°黄金绒带95%白鹅绒，蓬松度800+，如云朵般轻盈包裹。100支全棉防绒面料，静音柔滑，锁温透气兼得。",
                "一朵云的重量，约等于一夜安眠。织云走遍东北与西伯利亚绒源地，只为找到那束绒朵饱满、干净无杂的白鹅绒——以28年羽绒工艺，织就这张值得托付终身的被。",
                299900, 368000,
                M.writeValueAsString(List.of("/images/products/p01.svg", "/images/scenes/scene-2.svg", "/images/products/p06.svg")),
                "填充：95%白鹅绒；面料：100支全棉防绒布",
                M.writeValueAsString(List.of(
                        Map.of("label", "填充物", "value", "95% 白鹅绒（蓬松度 800+）"),
                        Map.of("label", "面料", "value", "100支全棉防绒面料"),
                        Map.of("label", "克重", "value", "冬款约 1100g / 200×230cm"),
                        Map.of("label", "工艺", "value", "立衬分区 · 五重防钻绒"))),
                true, 1286, 200});

        list.add(new Object[]{"silk-mulberry-duvet", "「云丝」桑蚕丝长丝被", "100% 桑蚕丝长丝 · 手工定位", "duvets",
                "选用江浙优质蚕区100%桑蚕丝长丝，绵韧贴身、轻盈透气。传统手工定位工艺，丝胎经年不移位，四季皆宜。",
                "一颗茧，可抽丝千米。织云只取一级桑蚕丝长丝，沿袭江南蚕坊手工拉制定位古法——让千年的温柔，落在你枕畔。",
                388000, null,
                M.writeValueAsString(List.of("/images/products/p02.svg", "/images/scenes/scene-1.svg")),
                "填充：100% 桑蚕丝长丝；面料：60支天丝棉",
                M.writeValueAsString(List.of(
                        Map.of("label", "填充物", "value", "100% 桑蚕丝长丝"),
                        Map.of("label", "面料", "value", "60支天丝棉混纺"),
                        Map.of("label", "工艺", "value", "手工定位 · 丝胎免翻新"),
                        Map.of("label", "净重", "value", "约 2000g / 200×230cm"))),
                true, 862, 150});

        list.add(new Object[]{"deep-sleep-pillow", "「深睡」托玛琳抗菌枕", "分区承托 · 温感自热", "pillows",
                "三区立体承托设计，仰睡侧睡各得其所；内芯融合托玛琳矿物颗粒，温感自热，促进颈部微循环，抗菌防螨率99%。",
                "好枕头，是颈椎的年假。织云联合睡眠实验室，历经217次人体工学测试——只为让你入睡的第一分钟，就开始深睡。",
                49900, 59900,
                M.writeValueAsString(List.of("/images/products/p03.svg", "/images/products/p04.svg")),
                "内芯：托玛琳复合颗粒 + 高弹纤维；面料：60支抗菌针织棉",
                M.writeValueAsString(List.of(
                        Map.of("label", "结构", "value", "三区承托（侧睡/仰睡/颈椎承托）"),
                        Map.of("label", "功能", "value", "温感自热 · 99%抗菌防螨"),
                        Map.of("label", "尺寸", "value", "48×74cm"),
                        Map.of("label", "认证", "value", "德国红点设计奖获奖系列"))),
                true, 2301, 500});

        list.add(new Object[]{"zero-pressure-pillow", "「云朵」零压枕", "慢回弹记忆棉 · 云感零压", "pillows",
                "5秒慢回弹记忆棉，随头颈曲线温柔包裹，压力分散零死角。外层天珠棉面料，亲肤可机洗。",
                "把头交给一朵云。零压，不是没有支撑，而是每一寸都被恰好接住。",
                39900, null,
                M.writeValueAsString(List.of("/images/products/p04.svg", "/images/scenes/scene-3.svg")),
                "内芯：高密度慢回弹记忆棉；面料：天珠棉",
                M.writeValueAsString(List.of(
                        Map.of("label", "内芯", "value", "高密度慢回弹记忆棉"),
                        Map.of("label", "回弹", "value", "5 秒慢回弹"),
                        Map.of("label", "尺寸", "value", "50×30cm 波浪双高"),
                        Map.of("label", "外套", "value", "可拆洗天珠棉外套"))),
                false, 3105, 500});

        list.add(new Object[]{"mu-jin-60s-set", "「暮金」60支长绒棉四件套", "60支新疆长绒棉 · 活性印染", "bedding-sets",
                "60支新疆长绒棉，缎纹织造，触感如丝。暮金色调取自黄昏最后一缕光，活性印染，久洗如新。",
                "暮色四合时，最想回到的地方。以日落时分的天光为灵感，把一天的疲惫，温柔收进这一床暮金里。",
                129900, 159900,
                M.writeValueAsString(List.of("/images/products/p05.svg", "/images/scenes/scene-1.svg", "/images/scenes/scene-4.svg")),
                "面料：60支新疆长绒棉缎纹",
                M.writeValueAsString(List.of(
                        Map.of("label", "面料", "value", "60支新疆长绒棉 · 贡缎缎纹"),
                        Map.of("label", "工艺", "value", "活性印染 · 环保固色"),
                        Map.of("label", "配置", "value", "被套×1 床单×1 枕套×2"),
                        Map.of("label", "尺寸", "value", "适用 200×230cm 被芯"))),
                true, 1789, 300});

        list.add(new Object[]{"yue-bai-100s-set", "「月白」100支贡缎四件套", "100支贡缎 · 素色美学", "bedding-sets",
                "100支贡缎素织，经纬密度冠绝同业，光如月色流转。无印染添加，本色即高级。",
                "月白，是中国人最含蓄的奢华。不着一色，自有万色——织得进月光，也睡得下星河。",
                189900, null,
                M.writeValueAsString(List.of("/images/products/p06.svg", "/images/scenes/scene-2.svg")),
                "面料：100支精梳棉贡缎",
                M.writeValueAsString(List.of(
                        Map.of("label", "面料", "value", "100支精梳长绒棉贡缎"),
                        Map.of("label", "工艺", "value", "素织免染 · 本色呈现"),
                        Map.of("label", "配置", "value", "被套×1 床单×1 枕套×2"),
                        Map.of("label", "光泽", "value", "缎面月光光泽"))),
                false, 756, 200});

        list.add(new Object[]{"tencel-cool-quilt", "「青岚」天丝凉感夏被", "兰精天丝 · 接触瞬凉", "summer",
                "奥地利兰精天丝纤维，Q-max凉感系数0.36，触肤瞬凉2-3℃。轻盈如岚，吸湿透气，空调房与闷热夜的两全法。",
                "夏夜的凉，应当像山间青岚——拂面而不浸骨。以森林之势取材，归还森林以敬意。",
                89900, 109900,
                M.writeValueAsString(List.of("/images/products/p07.svg", "/images/scenes/scene-5.svg")),
                "面料：100% 兰精天丝；填充：凉感纤维",
                M.writeValueAsString(List.of(
                        Map.of("label", "凉感值", "value", "Q-max ≥ 0.36（A类优等）"),
                        Map.of("label", "面料", "value", "100% 奥地利兰精天丝"),
                        Map.of("label", "净重", "value", "约 800g / 200×230cm"),
                        Map.of("label", "洗涤", "value", "可机洗 · 免翻晒"))),
                true, 4021, 600});

        list.add(new Object[]{"kids-anti-mite-pillow", "「稚梦」儿童抗菌防螨枕", "A类母婴级 · 分龄承托", "pillows",
                "国家A类母婴安全标准，物理防螨无化学添加。分龄高度设计，守护3-12岁每一个成长期的颈椎。",
                "孩子的睡眠里，藏着长高的秘密。像守护第一颗乳牙一样，守护他的第一只枕头。",
                29900, null,
                M.writeValueAsString(List.of("/images/products/p08.svg", "/images/scenes/scene-3.svg")),
                "内芯：抗菌中空纤维；面料：A类精梳棉",
                M.writeValueAsString(List.of(
                        Map.of("label", "标准", "value", "GB 18401 A类母婴级"),
                        Map.of("label", "防螨", "value", "物理防螨 · 无化学助剂"),
                        Map.of("label", "分龄", "value", "3-6岁 / 7-12岁 双档高度"),
                        Map.of("label", "尺寸", "value", "40×60cm"))),
                false, 1544, 400});

        list.add(new Object[]{"wedding-gift-box", "「锦瑟和鸣」新婚十件套礼盒", "婚嫁臻礼 · 苏绣纹样", "gifts",
                "取意「锦瑟无端五十弦」，十件套涵盖鹅绒被、贡缎套件、蚕丝枕与新婚对枕。苏绣缠枝莲纹，一针一线皆是祝福。",
                "琴瑟在御，莫不静好。织云婚嫁系列与苏州绣娘合作，把「白头偕老」四个字，绣进了往后每一个晨昏。",
                599900, 699900,
                M.writeValueAsString(List.of("/images/products/p09.svg", "/images/scenes/scene-4.svg", "/images/products/p02.svg")),
                "组合：鹅绒被+贡缎四件套+蚕丝对枕等十件",
                M.writeValueAsString(List.of(
                        Map.of("label", "套内", "value", "十件套（详见商品参数页）"),
                        Map.of("label", "工艺", "value", "苏绣缠枝莲纹 · 手工盘金"),
                        Map.of("label", "礼盒", "value", "织云专属漆器礼盒 · 提袋"),
                        Map.of("label", "服务", "value", "免费礼品包装 · 可定制贺卡"))),
                true, 328, 80});

        list.add(new Object[]{"monet-garden-set", "「莫奈花园」大师联名四件套", "印象派印花 · 艺术家纺", "bedding-sets",
                "与前GUCCI印花设计总监联名，以莫奈《睡莲》为底本，数码直喷十六色渐变印花，把吉维尼花园搬进卧室。",
                "当莫奈的睡莲在枕畔泛起柔光，梦也有了颜色。艺术不必悬挂于墙——它可以被盖在身上。",
                219900, null,
                M.writeValueAsString(List.of("/images/products/p10.svg", "/images/scenes/scene-5.svg")),
                "面料：80支长绒棉数码印花",
                M.writeValueAsString(List.of(
                        Map.of("label", "联名", "value", "前GUCCI印花设计总监工作室"),
                        Map.of("label", "印花", "value", "16色数码直喷 · 渐变无级"),
                        Map.of("label", "面料", "value", "80支长绒棉斜纹"),
                        Map.of("label", "配置", "value", "被套×1 床单×1 枕套×2"))),
                true, 967, 200});

        list.add(new Object[]{"linen-pillowcase-pair", "「原野」亚麻枕套对枕", "雨露麻 · 天然肌理", "bedding-sets",
                "欧洲雨露麻，天然褶皱纹理与哑光质感，越洗越柔软。中性大地色系，任意床品皆可相融。",
                "亚麻是布料里的原野风。它不讨好肌肤，却让肌肤记得自由。",
                39900, null,
                M.writeValueAsString(List.of("/images/products/p11.svg", "/images/scenes/scene-1.svg")),
                "面料：100% 欧洲雨露麻",
                M.writeValueAsString(List.of(
                        Map.of("label", "面料", "value", "100% 欧洲雨露麻（4.2支）"),
                        Map.of("label", "规格", "value", "48×74cm 对装"),
                        Map.of("label", "风格", "value", "天然褶皱 · 哑光肌理"),
                        Map.of("label", "洗涤", "value", "可机洗 · 越洗越柔"))),
                false, 688, 300});

        list.add(new Object[]{"wool-winter-duvet", "「暖山」澳洲羊毛冬被", "澳洲美利奴羊毛 · 恒温锁暖", "duvets",
                "澳洲美利奴细支羊毛，天然卷曲锁住静止空气，恒温锁暖不闷汗。羊毛脂亲肤，湿气管理能力是棉的2倍。",
                "山有暖意，被有羊毛。最古老的御寒智慧，配得上最现代的一夜好眠。",
                249900, 289900,
                M.writeValueAsString(List.of("/images/products/p12.svg", "/images/scenes/scene-6.svg")),
                "填充：100% 澳洲美利奴羊毛；面料：全棉防羽布",
                M.writeValueAsString(List.of(
                        Map.of("label", "填充物", "value", "100% 澳洲美利奴羊毛"),
                        Map.of("label", "功能", "value", "恒温锁暖 · 吸湿排汗"),
                        Map.of("label", "克重", "value", "约 1600g / 200×230cm"),
                        Map.of("label", "认证", "value", "Woolmark 国际羊毛局认证"))),
                false, 542, 150});

        return list;
    }
}
