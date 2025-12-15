package com.integration.final_proyect.service;

import com.integration.final_proyect.dto.AuthRequestDTO;
import com.integration.final_proyect.dto.AuthResponseDTO;

public interface AuthService {

    AuthResponseDTO login(AuthRequestDTO loginRequest);

}
