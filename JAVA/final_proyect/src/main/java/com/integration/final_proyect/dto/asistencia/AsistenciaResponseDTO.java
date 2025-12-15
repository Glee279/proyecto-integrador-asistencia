package com.integration.final_proyect.dto.asistencia;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AsistenciaResponseDTO {

    private Long idAsistencia;
    private String mensaje;

}
