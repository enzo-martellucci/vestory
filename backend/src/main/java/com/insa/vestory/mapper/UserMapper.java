package com.insa.vestory.mapper;

import com.insa.vestory.dto.RegisterResponse;
import com.insa.vestory.entity.User;
import org.mapstruct.Mapper;

@Mapper
public interface UserMapper {

    RegisterResponse toRegisterResponse(User user);
}
