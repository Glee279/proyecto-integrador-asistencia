package com.integration.final_proyect.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.integration.final_proyect.dto.rol.AsignarRolRequestDTO;
import com.integration.final_proyect.dto.rol.QuitarRolRequestDTO;
import com.integration.final_proyect.dto.rol.RolCreateRequestDTO;
import com.integration.final_proyect.dto.rol.RolResponseDTO;
import com.integration.final_proyect.dto.rol.RolUpdateRequestDTO;
import com.integration.final_proyect.service.RolService;

@RestController
@RequestMapping("/roles")
public class RolController {

    private final RolService rolService;

    public RolController(RolService rolService) {
        this.rolService = rolService;
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<Void> crear (@RequestBody RolCreateRequestDTO dto) {
        rolService.crearRol(dto);
        return ResponseEntity.ok().build();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/asignar")
    public ResponseEntity<Void> asignarRol (@RequestBody AsignarRolRequestDTO dto) {
        rolService.asignarRol(dto.getIdUsuario(), dto.getIdRol());
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/quitar")
    public ResponseEntity<Void> quitarRol(@RequestBody QuitarRolRequestDTO dto) {
        rolService.quitarRol(dto.getIdUsuario(), dto.getIdRol());
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> actualizarRol(@PathVariable Long id,@RequestBody RolUpdateRequestDTO dto) {
        rolService.actualizarRol(id, dto.getNombre());
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{id}/estado")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> cambiarEstado(@PathVariable Long id) {
        rolService.modificarEstadoRol(id);
        return ResponseEntity.ok().build();
    }


    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping
    public ResponseEntity<List<RolResponseDTO>> listar() {
        return ResponseEntity.ok(rolService.listarRoles());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/usuario/{idUsuario}")
    public ResponseEntity<List<RolResponseDTO>> rolesPorUsuario(@PathVariable Long idUsuario) {
        return ResponseEntity.ok(
            rolService.rolesPorUsuario(idUsuario)
        );
    }

}
