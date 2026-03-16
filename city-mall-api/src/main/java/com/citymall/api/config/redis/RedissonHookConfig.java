package com.citymall.api.config.redis;

import org.redisson.api.RedissonClient;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConditionalOnClass(RedissonClient.class)
@ConditionalOnProperty(prefix = "redisson", name = "enabled", havingValue = "true")
public class RedissonHookConfig {
}
