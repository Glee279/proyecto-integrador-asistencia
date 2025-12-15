package com.integration.final_proyect.dto.reporte;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ReportePuntualidadDTO {

    private Long idUsuario;
    private String nombreCompleto;
    private LocalDateTime fecEntrada;
    private String horaProgramada;
    private Integer minutosTardanza;
    private String estadoPuntualidad;

}
