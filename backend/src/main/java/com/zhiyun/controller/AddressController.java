package com.zhiyun.controller;

import com.zhiyun.dto.AddressDto;
import com.zhiyun.dto.Ok;
import com.zhiyun.dto.SafeUser;
import com.zhiyun.entity.Address;
import com.zhiyun.exception.BizException;
import com.zhiyun.service.AddressService;
import com.zhiyun.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 收货地址 —— 移植自 app/api/addresses/route.ts 与 [id]/route.ts
 */
@RestController
@RequestMapping("/addresses")
public class AddressController {

    @Autowired private AddressService addressService;
    @Autowired private AuthService authService;

    @GetMapping
    public Map<String, Object> list() {
        SafeUser u = requireLogin();
        List<Address> list = addressService.list(u.id());
        List<AddressDto> dtos = list.stream().map(AddressDto::from).toList();
        return Map.of("addresses", dtos);
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody Map<String, Object> body) {
        SafeUser u = requireLogin();
        Boolean isDefault = body.get("isDefault") instanceof Boolean b ? b : null;
        String id = addressService.create(u.id(),
                (String) body.get("name"), (String) body.get("phone"),
                (String) body.get("province"), (String) body.get("city"),
                (String) body.get("district"), (String) body.get("detail"), isDefault);
        return Map.of("ok", true, "id", id);
    }

    @PutMapping("/{id}")
    public Ok update(@PathVariable String id, @RequestBody Map<String, Object> body) {
        SafeUser u = requireLogin();
        addressService.update(id, u.id(),
                (String) body.get("name"), (String) body.get("phone"),
                (String) body.get("province"), (String) body.get("city"),
                (String) body.get("district"), (String) body.get("detail"));
        return Ok.yes();
    }

    @PatchMapping("/{id}")
    public Ok setDefault(@PathVariable String id) {
        SafeUser u = requireLogin();
        addressService.setDefault(id, u.id());
        return Ok.yes();
    }

    @DeleteMapping("/{id}")
    public Ok delete(@PathVariable String id) {
        SafeUser u = requireLogin();
        addressService.delete(id, u.id());
        return Ok.yes();
    }

    private SafeUser requireLogin() {
        SafeUser u = authService.getCurrentUser();
        if (u == null) throw BizException.unauthorized("请先登录");
        return u;
    }
}
