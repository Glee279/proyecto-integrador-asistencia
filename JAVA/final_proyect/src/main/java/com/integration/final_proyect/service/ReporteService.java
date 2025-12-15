package com.integration.final_proyect.service;

import java.time.LocalDate;
import java.util.List;

import com.integration.final_proyect.dto.reporte.ReporteAsistenciaDTO;
import com.integration.final_proyect.dto.reporte.ReportePuntualidadDTO;

public interface ReporteService {

    List<ReporteAsistenciaDTO> reporteAsistencia (Long idUsuario, Long idSede, LocalDate fecIni, LocalDate fecFin);

    List<ReportePuntualidadDTO> reportePuntualidad (Long idUsuario, LocalDate fecIni, LocalDate fecFin);

}
