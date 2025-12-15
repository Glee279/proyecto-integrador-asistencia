package com.integration.final_proyect.dto.usuario;

import lombok.Data;

@Data
public class CambiarPasswordRequestDTO {

    private String passwordActual;
    private String passwordNueva;

}
