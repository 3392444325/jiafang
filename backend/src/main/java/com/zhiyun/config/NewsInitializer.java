package com.zhiyun.config;

import com.zhiyun.entity.News;
import com.zhiyun.repository.NewsRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 新闻种子初始化器 —— 把原 NewsView 内置的 8 篇文章迁入 news 表。
 * 独立于 DataInitializer（其仅在分类为空时执行），这里仅当 news 表为空时写入，
 * 保证老库升级后也能自动获得新闻数据。
 */
@Slf4j
@Component
@Order(2)
@RequiredArgsConstructor
public class NewsInitializer implements CommandLineRunner {

    private static final String[][] SEEDS = {
            // {date, category, featured, title, excerpt}
            {"2026-08-28", "新品发布", "1", "「莫奈花园」第二季上市：把睡莲的黄昏，织进一套四件套",
                    "延续与前 GUCCI 印花设计总监的联名合作，第二季以《睡莲·黄昏》为灵感，新增四组暮金色号与十六色渐变直喷工艺，全球限量 3,000 套，每套附艺术家签名编号。"},
            {"2026-08-10", "品牌新闻", "0", "织云与前 GUCCI 印花设计总监完成三年续约",
                    "双方将在未来三年推出四季联名系列，并联合设立「东方织造印花实验室」。"},
            {"2026-07-20", "媒体报道", "0", "《时尚家居》年度榜单：织云蝉联「年度鹅绒被」",
                    "评审团评价：「云绒」系列以 95 白鹅绒与 27 项原材检测，重新定义了国产高端被芯的标尺。"},
            {"2026-06-18", "活动回顾", "0", "世界睡眠日·深睡论坛在杭州西子湖畔举办",
                    "织云联合睡眠研究机构发布《城市深睡白皮书》，并预告「深睡 2.0」系列。"},
            {"2026-05-30", "品牌新闻", "0", "全国第 1,200 家门店落地成都 IFS",
                    "新店以「东方织造美术馆」为概念，陈列 38 年来 12 件典藏织品。"},
            {"2026-04-12", "新品发布", "0", "「青岚」天丝夏凉系列全新升级",
                    "全新兰精天丝 500 织法，接触瞬凉 1.8℃，凉而不冰。"},
            {"2026-03-08", "媒体报道", "0", "央视《大国匠心》专题记录：43 道工序的织造",
                    "镜头深入织云工坊，记录一道被芯从绒朵到成品的完整旅程。"},
            {"2026-01-15", "品牌新闻", "0", "织云发布《2025 可持续发展报告》",
                    "原材可追溯率提升至 86%，循环再生计划全年回收旧被 4.2 万床。"},
    };

    private static final String BODY_SUFFIX =
            "如需了解更多详情，欢迎莅临织云线下门店，或关注官方微信公众号「织云家纺」。\n\n"
            + "织云 ZHIYUN LIVING，以东方织造，致一世安眠。";

    private final NewsRepository newsRepo;

    @Override
    public void run(String... args) {
        if (newsRepo.count() > 0) {
            log.info("news 表已有数据，跳过新闻种子初始化");
            return;
        }
        log.info("开始写入新闻种子数据...");
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        for (String[] s : SEEDS) {
            News n = new News();
            n.setTitle(s[3]);
            n.setCategory(s[1]);
            n.setExcerpt(s[4]);
            n.setContent(s[4] + "\n\n" + BODY_SUFFIX);
            n.setFeatured("1".equals(s[2]));
            n.setPublished(true);
            n.setCover("1".equals(s[2]) ? "/images/heroes/hero-3.jpg" : null);
            Date date;
            try { date = df.parse(s[0]); } catch (ParseException e) { date = new Date(); }
            n.setPublishedAt(date);
            n.setCreatedAt(date);
            newsRepo.save(n);
        }
        log.info("新闻种子数据写入完成，共 {} 篇", SEEDS.length);
    }
}
