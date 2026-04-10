package com.citymall.api.module.customer.entity;


import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.citymall.api.common.entity.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @author cqkir
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("member_user")
public class MemberUser extends BaseEntity {

    @TableField("c_status")
    private String cStatus;

    @TableField("user_id")
    private String userId;

    @TableField("mobile")
    private String mobile;

    @TableField("nickname")
    private String nickname;

    @TableField("avatar")
    private String avatar;

    @TableField("gender")
    private String gender;

    @TableField("openid")
    private String openid;

    @TableField("union_id")
    private String unionId;
}