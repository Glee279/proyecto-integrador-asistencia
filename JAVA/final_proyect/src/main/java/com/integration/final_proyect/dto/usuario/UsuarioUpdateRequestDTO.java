package com.integration.final_proyect.dto.usuario;

import lombok.Data;

@Data
public class UsuarioUpdateRequestDTO {

    private String area;
    private String modalidad;
    private String horaIni;
    private String horaFin;
    private String apelPat;
    private String apelMat;
    private String priNombre;
    private String segNombre;
    private String dni;
    private String telefono;
    private String direccion;
    private String correoPer;
    private boolean regenerarUsuario;

}
