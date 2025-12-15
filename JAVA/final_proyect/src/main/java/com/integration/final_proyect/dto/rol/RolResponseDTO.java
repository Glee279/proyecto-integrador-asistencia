package com.integration.final_proyect.dto.rol;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RolResponseDTO {
    private Long idRol;
    private String nombre;
    private String estado;
}