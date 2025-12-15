package com.integration.final_proyect.dto.usuario;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UsuarioCreateResponseDTO {

    private Long idUsuario;
    private String usuario;
    private String passwordTemporal;
    private String correoCor;
    private String estado;

}
