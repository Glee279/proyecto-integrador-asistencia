package com.integration.final_proyect.dto.asistencia;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AsistenciaEstadoDTO {

    private boolean tieneEntrada;
    private boolean tieneSalida;

}
