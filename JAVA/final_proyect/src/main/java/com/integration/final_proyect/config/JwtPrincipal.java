package com.integration.final_proyect.config;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class JwtPrincipal {

    private String username;
    private Long idUsuario;
    
}