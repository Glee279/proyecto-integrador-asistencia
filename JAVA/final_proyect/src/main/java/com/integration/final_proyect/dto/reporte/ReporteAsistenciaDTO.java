package com.integration.final_proyect.dto.reporte;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ReporteAsistenciaDTO {

    private Long idAsistencia;
    private Long idUsuario;
    private String nombreCompleto;
    private Long idSede;
    private LocalDateTime fecEntrada;
    private LocalDateTime fecSalida;
    private String tipo;
    private String estado;

}
