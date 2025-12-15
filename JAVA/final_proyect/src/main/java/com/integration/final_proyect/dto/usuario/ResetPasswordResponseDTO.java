package com.integration.final_proyect.dto.usuario;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ResetPasswordResponseDTO {

    private String passwordTemporal;

}
