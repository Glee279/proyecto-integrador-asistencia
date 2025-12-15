package com.integration.final_proyect.dto;

import java.util.List;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AuthResponseDTO {

    private String token;
    private String usuario;
    private Long idUsuario;
    private List<String> roles;
    private String modalidad;

}
