package com.integration.final_proyect.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.integration.final_proyect.config.SecurityUtil;
import com.integration.final_proyect.dto.justificacion.JustificacionCreateRequestDTO;
import com.integration.final_proyect.dto.justificacion.JustificacionResponseDTO;
import com.integration.final_proyect.dto.justificacion.JustificacionRevisionRequestDTO;
import com.integration.final_proyect.service.JustificacionService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/justificaciones")
@RequiredArgsConstructor
public class JustificacionController {

    private final JustificacionService service;

    // EMPLEADO: crear
    @PreAuthorize("hasRole('EMPLEADO')")
    @PostMapping
    public JustificacionResponseDTO crear(@RequestBody JustificacionCreateRequestDTO dto) {
        Long idUsuario = SecurityUtil.getIdUsuarioAutenticado();
        return service.registrar(idUsuario, dto);
    }

    // EMPLEADO: listar MIS justificaciones
    @PreAuthorize("hasRole('EMPLEADO')")
    @GetMapping("/mis-justificaciones")
    public List<JustificacionResponseDTO> listarMis(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecIni,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecFin
    ) {
        Long idUsuario = SecurityUtil.getIdUsuarioAutenticado();
        return service.listarPorUsuario(idUsuario, fecIni, fecFin);
    }

    // ADMIN: listar general con filtros
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin")
    public List<JustificacionResponseDTO> listarAdmin(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecIni,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecFin,
            @RequestParam(required = false) Long idUsuario,
            @RequestParam(required = false) String estado
    ) {
        return service.listarAdmin(fecIni, fecFin, idUsuario, estado);
    }

    // ADMIN: revisar
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/revision")
    public void revisar(@RequestBody JustificacionRevisionRequestDTO dto) {
        Long idAdmin = SecurityUtil.getIdUsuarioAutenticado();
        service.revisar(idAdmin, dto);
    }
}
