package com.integration.final_proyect.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.integration.final_proyect.dto.reporte.ReporteAsistenciaDTO;
import com.integration.final_proyect.dto.reporte.ReportePuntualidadDTO;
import com.integration.final_proyect.service.ReporteService;

@RestController
@RequestMapping("/reportes")
public class ReporteController {

    @Autowired
    private ReporteService reporteService;

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/fechas")
    public ResponseEntity<?> generarReportePorFechas(

            @RequestParam String tipo,

            @RequestParam(required = false) Long idUsuario,
            @RequestParam(required = false) Long idSede,

            @RequestParam
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate fecIni,

            @RequestParam
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate fecFin
    ) {

        switch (tipo.toUpperCase()) {
            case "ASISTENCIA": {
                List<ReporteAsistenciaDTO> data = reporteService.reporteAsistencia(idUsuario, idSede, fecIni, fecFin);
                return ResponseEntity.ok(data);
            }

            case "PUNTUALIDAD": {
                if (idUsuario == null) {
                    return ResponseEntity.badRequest().body("Para puntualidad se requiere idUsuario");
                }
                List<ReportePuntualidadDTO> data = reporteService.reportePuntualidad(idUsuario, fecIni, fecFin);
                return ResponseEntity.ok(data);
            }
            default:
                return ResponseEntity.badRequest()
                        .body("Tipo de reporte no válido. Use ASISTENCIA o PUNTUALIDAD");
        }
    }
}
