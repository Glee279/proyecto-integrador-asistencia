package com.integration.final_proyect.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.integration.final_proyect.dto.qr_token.QrActivoResponseDTO;
import com.integration.final_proyect.dto.qr_token.QrTokenCreateRequestDTO;
import com.integration.final_proyect.dto.qr_token.QrTokenResponseDTO;
import com.integration.final_proyect.dto.qr_token.QrTokenValidarResponseDTO;
import com.integration.final_proyect.service.QrTokenService;

@RestController
@RequestMapping("/qr-tokens")
public class QrTokenController {

    private final QrTokenService service;

    public QrTokenController(QrTokenService service) {
        this.service = service;
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<QrTokenResponseDTO> generar(@RequestBody QrTokenCreateRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.generarQr(dto));
    }

    @PreAuthorize("hasAnyRole('ADMIN','EMPLEADO')")
    @GetMapping("/validar/{codigoQr}")
    public ResponseEntity<QrTokenValidarResponseDTO> validar(@PathVariable String codigoQr) {
        return ResponseEntity.ok(service.validarQr(codigoQr));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PatchMapping("/{idQr}/expirar")
    public ResponseEntity<Void> expirar(@PathVariable Long idQr) {
        service.expirarQr(idQr);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/activo")
    public ResponseEntity<QrActivoResponseDTO> obtenerQrActivo (@RequestParam Long idSede) {
        return ResponseEntity.ok(service.obtenerQrActivoPorSede(idSede));
    }

}