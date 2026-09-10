package com.zhiyun.service;

import com.zhiyun.dto.SafeUser;
import com.zhiyun.entity.*;
import com.zhiyun.exception.BizException;
import com.zhiyun.repository.*;
import com.zhiyun.util.Cuid;
import com.zhiyun.util.FormatUtil;
import com.zhiyun.util.JsonUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class OrderService {

    @Autowired private OrderRepository orderRepo;
    @Autowired private OrderItemRepository orderItemRepo;
    @Autowired private CartItemRepository cartRepo;
    @Autowired private ProductRepository productRepo;
    @Autowired private AddressRepository addressRepo;

    /** 我的订单列表 */
    @Transactional(readOnly = true)
    public List<Map<String, Object>> listOrders(String userId) {
        List<Order> orders = orderRepo.findByUserIdWithItems(userId);
        return orders.stream().map(this::toSummary).toList();
    }

    /** 订单详情 */
    @Transactional(readOnly = true)
    public Map<String, Object> getOrderDetail(String id, SafeUser user) {
        Order order = orderRepo.findByIdWithItems(id)
                .orElseThrow(() -> BizException.notFound("订单不存在"));
        if (user == null || !order.getUserId().equals(user.id())) {
            throw BizException.notFound("订单不存在");
        }
        return toDetail(order);
    }

    /** 创建订单（事务：建单 → 扣库存/增销量 → 清购物车 → 可选存地址） */
    @Transactional
    public Map<String, Object> createOrder(String userId, String name, String phone,
                                           String province, String city, String district,
                                           String detail, Boolean saveAddress) {
        if (anyBlank(name, phone, province, city, detail)) {
            throw BizException.bad("请填写完整收货信息");
        }
        List<CartItem> items = cartRepo.findByUserIdWithProduct(userId);
        if (items.isEmpty()) throw BizException.bad("购物车是空的");

        int totalFen = items.stream()
                .mapToInt(it -> it.getProduct().getPriceFen() * it.getQty())
                .sum();

        Map<String, Object> addr = new LinkedHashMap<>();
        addr.put("name", name);
        addr.put("phone", phone);
        String region = joinNonBlank(" ", province, city, district);
        addr.put("region", region);
        addr.put("detail", detail);
        String addressJson = JsonUtil.write(addr);

        Order order = new Order();
        order.setOrderNo(FormatUtil.genOrderNo());
        order.setStatus("PENDING_PAYMENT");
        order.setTotalFen(totalFen);
        order.setUserId(userId);
        order.setAddressJson(addressJson);
        order.setItems(new ArrayList<>()); // items 改为显式保存，不依赖级联
        order = orderRepo.save(order);

        List<OrderItem> oiList = new ArrayList<>();
        for (CartItem it : items) {
            OrderItem oi = new OrderItem();
            oi.setProductId(it.getProductId());
            oi.setNameSnap(it.getProduct().getName());
            List<String> imgs = JsonUtil.parseStringList(it.getProduct().getImages());
            oi.setImageSnap(imgs.isEmpty() ? "/images/products/p01.svg" : imgs.get(0));
            oi.setPriceFen(it.getProduct().getPriceFen());
            oi.setQty(it.getQty());
            oi.setOrderId(order.getId());
            oi.setOrder(order);
            oiList.add(oi);
        }
        orderItemRepo.saveAll(oiList); // 显式持久化订单明细
        order.setItems(oiList);

        // 条件更新扣库存 + 增销量（库存不足抛错回滚整单）
        for (CartItem it : items) {
            Product p = productRepo.findById(it.getProductId()).orElseThrow();
            int updated = productRepo.deductStock(p.getId(), it.getQty());
            if (updated == 0) {
                throw BizException.bad("「" + p.getName() + "」库存不足，仅剩 " + Math.max(0, p.getStock()) + " 件");
            }
        }
        // 清购物车
        cartRepo.deleteByUserId(userId);

        // 可选保存地址
        if (Boolean.TRUE.equals(saveAddress)) {
            long count = addressRepo.countByUserId(userId);
            Address a = new Address();
            a.setUserId(userId);
            a.setName(name); a.setPhone(phone);
            a.setProvince(province); a.setCity(city);
            a.setDistrict(district == null || district.isBlank() ? null : district);
            a.setDetail(detail);
            a.setIsDefault(count == 0);
            addressRepo.save(a);
        }

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("ok", true);
        res.put("id", order.getId());
        res.put("orderNo", order.getOrderNo());
        return res;
    }

    /** 模拟支付 */
    @Transactional
    public String payOrder(String id, SafeUser user, String method) {
        if (method == null || !Set.of("WECHAT", "ALIPAY", "CARD").contains(method)) {
            method = "WECHAT";
        }
        Order order = orderRepo.findById(id)
                .orElseThrow(() -> BizException.notFound("订单不存在"));
        if (user == null || !order.getUserId().equals(user.id())) {
            throw BizException.notFound("订单不存在");
        }
        if (!"PENDING_PAYMENT".equals(order.getStatus())) {
            throw BizException.bad("当前订单状态不可支付");
        }
        order.setStatus("PAID");
        order.setPaidAt(new Date());
        order.setPayMethod(method);
        orderRepo.save(order);
        return method;
    }

    private Map<String, Object> toSummary(Order o) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", o.getId());
        m.put("orderNo", o.getOrderNo());
        m.put("status", o.getStatus());
        m.put("totalFen", o.getTotalFen());
        m.put("createdAt", o.getCreatedAt());
        m.put("paidAt", o.getPaidAt());
        m.put("payMethod", o.getPayMethod());
        m.put("items", o.getItems().stream().map(it -> {
            Map<String, Object> im = new LinkedHashMap<>();
            im.put("id", it.getId());
            im.put("nameSnap", it.getNameSnap());
            im.put("imageSnap", it.getImageSnap());
            im.put("priceFen", it.getPriceFen());
            im.put("qty", it.getQty());
            return im;
        }).toList());
        return m;
    }

    private Map<String, Object> toDetail(Order o) {
        Map<String, Object> m = toSummary(o);
        m.put("addressJson", o.getAddressJson());
        return m;
    }

    private boolean anyBlank(String... ss) {
        for (String s : ss) if (s == null || s.trim().isEmpty()) return true;
        return false;
    }

    private String joinNonBlank(String sep, String... parts) {
        StringBuilder sb = new StringBuilder();
        for (String p : parts) {
            if (p != null && !p.isBlank()) {
                if (sb.length() > 0) sb.append(sep);
                sb.append(p);
            }
        }
        return sb.toString();
    }
}
