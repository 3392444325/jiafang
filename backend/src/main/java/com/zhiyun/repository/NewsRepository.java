package com.zhiyun.repository;

import com.zhiyun.entity.News;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface NewsRepository extends JpaRepository<News, String> {

    /** 后台：全部文章（含未发布），按创建时间倒序 */
    List<News> findAllByOrderByCreatedAtDesc();

    /** 前台：已发布文章，头条优先、其余按发布时间倒序 */
    List<News> findByPublishedTrueOrderByFeaturedDescCreatedAtDesc();

    /** 前台：已发布文章详情（未发布视为不存在） */
    Optional<News> findByIdAndPublishedTrue(String id);
}
