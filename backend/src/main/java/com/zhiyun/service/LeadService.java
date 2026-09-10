package com.zhiyun.service;

import com.zhiyun.entity.Lead;
import com.zhiyun.exception.BizException;
import com.zhiyun.repository.LeadRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;

/**
 * 商机线索服务 —— 移植自 app/api/leads/route.ts
 * 招商 / 团购 / 合作表单共用提交端点
 */
@Service
public class LeadService {

    private static final Set<String> LEAD_TYPES = Set.of("FRANCHISE", "GROUP_BUY", "COOPERATION");

    @Autowired private LeadRepository leadRepo;

    @Transactional
    public String submit(String type, String name, String phone, String note) {
        String t = (type != null && LEAD_TYPES.contains(type)) ? type : "COOPERATION";
        String n = name == null ? "" : name.trim();
        String p = phone == null ? "" : phone.trim();
        String nt = note == null ? "" : note.trim();

        if (n.isEmpty() || !p.matches("^1\\d{10}$")) {
            throw BizException.bad("请填写姓名与 11 位手机号码");
        }

        Lead lead = new Lead();
        lead.setType(t);
        lead.setName(n);
        lead.setPhone(p);
        lead.setNote(nt.isEmpty() ? null : nt);
        return leadRepo.save(lead).getId();
    }
}
