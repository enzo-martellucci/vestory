package com.insa.vestory.mapper;

import com.insa.vestory.dto.UserResponse;
import com.insa.vestory.entity.User;
import org.mapstruct.Mapper;

@Mapper
public interface UserMapper {

    UserResponse toResponse(User user);
}
