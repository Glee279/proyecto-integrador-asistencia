package com.integration.final_proyect.dto.reporte;

import java.time.LocalDate;

import lombok.Data;

@Data
public class ReporteFechaRequestDTO {

    private Long idUsuario;
    private Long idSede;
    private LocalDate fecIni;
    private LocalDate fecFin;

}
