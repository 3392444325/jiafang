package com.zhiyun;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class ZhiyunApplication {
    public static void main(String[] args) {
        SpringApplication.run(ZhiyunApplication.class, args);
    }
}
