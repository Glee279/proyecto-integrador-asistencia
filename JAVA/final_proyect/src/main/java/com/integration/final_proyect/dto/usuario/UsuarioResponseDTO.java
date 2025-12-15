package com.integration.final_proyect.dto.usuario;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UsuarioResponseDTO {

    private Long idUsuario;
    private String usuario;
    private String dni;
    private String nombres;
    private String area;
    private String modalidad;
    private String horaIni;
    private String horaFin;
    private String telefono;
    private String direccion;
    private String correoPer;
    private String correoCor;
    private String estado;

}
