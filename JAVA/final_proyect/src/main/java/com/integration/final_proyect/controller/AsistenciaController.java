package com.integration.final_proyect.controller;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.integration.final_proyect.dto.asistencia.AsistenciaCheckInRequestDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaCheckOutRequestDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaEstadoDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaHistorialResponseDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaResponseDTO;
import com.integration.final_proyect.service.AsistenciaService;

@RestController
@RequestMapping("/asistencia")
public class AsistenciaController {

    private final AsistenciaService asistenciaService;

    public AsistenciaController(AsistenciaService asistenciaService) {
        this.asistenciaService = asistenciaService;
    }

    @PreAuthorize("hasAnyRole('ADMIN','EMPLEADO')")
    @PostMapping("/check-in")
    public ResponseEntity<AsistenciaResponseDTO> checkIn(
            @RequestBody AsistenciaCheckInRequestDTO dto) {
        return ResponseEntity.ok(asistenciaService.checkIn(dto));
    }

    @PreAuthorize("hasAnyRole('ADMIN','EMPLEADO')")
    @PostMapping("/check-out")
    public ResponseEntity<AsistenciaResponseDTO> checkOut(
            @RequestBody AsistenciaCheckOutRequestDTO dto) {
        return ResponseEntity.ok(asistenciaService.checkOut(dto));
    }

    @PreAuthorize("hasAnyRole('ADMIN','EMPLEADO')")
    @GetMapping("/historial")
    public ResponseEntity<List<AsistenciaHistorialResponseDTO>> historial() {
        return ResponseEntity.ok(asistenciaService.historial());
    }

    @PreAuthorize("hasAnyRole('ADMIN','EMPLEADO')")
    @GetMapping("/estadohoy")
    public ResponseEntity<AsistenciaEstadoDTO> estadoHoy() {
        return ResponseEntity.ok(asistenciaService.estadoHoy());
    }

    @PreAuthorize("hasAnyRole('ADMIN','EMPLEADO')")
    @GetMapping("/historial/propio")
    public ResponseEntity<List<AsistenciaHistorialResponseDTO>> historial(
            @RequestParam(required = false) @DateTimeFormat(iso = ISO.DATE) LocalDate fechaInicio,
            @RequestParam(required = false) @DateTimeFormat(iso = ISO.DATE) LocalDate fechaFin) {
        return ResponseEntity.ok(
                asistenciaService.historialEmpleado(
                        convertToDate(fechaInicio),
                        convertToDate(fechaFin)));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/historial/admin")
    public ResponseEntity<List<AsistenciaHistorialResponseDTO>> historialAdmin(
            @RequestParam(required = false) Long idUsuario,
            @RequestParam(required = false) @DateTimeFormat(iso = ISO.DATE) LocalDate fechaInicio,
            @RequestParam(required = false) @DateTimeFormat(iso = ISO.DATE) LocalDate fechaFin) {
        return ResponseEntity.ok(
                asistenciaService.historialAdmin(idUsuario,
                        convertToDate(fechaInicio),
                        convertToDate(fechaFin)));
    }

    public Date convertToDate(LocalDate localDate) {
        return (localDate != null) ? Date.valueOf(localDate) : null;
    }

}
