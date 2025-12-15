package com.integration.final_proyect.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.integration.final_proyect.dto.sede.SedeCreateRequestDTO;
import com.integration.final_proyect.dto.sede.SedeResponseDTO;
import com.integration.final_proyect.service.SedeService;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/sedes")
public class SedeController {

    private final SedeService service;

    public SedeController(SedeService service) {
        this.service = service;
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<SedeResponseDTO> crear(@RequestBody SedeCreateRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(service.crearSede(dto));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping
    public ResponseEntity<List<SedeResponseDTO>> listar() {
        return ResponseEntity.ok(service.listarSedes());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PatchMapping("/{id}/estado")
    public ResponseEntity<Void> cambiarEstado(@PathVariable Long id) {
        service.cambiarEstado(id);
        return ResponseEntity.noContent().build();
    }
}
