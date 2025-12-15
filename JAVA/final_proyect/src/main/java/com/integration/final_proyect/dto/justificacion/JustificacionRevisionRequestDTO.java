package com.integration.final_proyect.dto.justificacion;

import lombok.Data;

@Data
public class JustificacionRevisionRequestDTO {

    private Long IdJustificacion;     // usuario admin
    private String estado;       // A | R
    private String comentario;

}
