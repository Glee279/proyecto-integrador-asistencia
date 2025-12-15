package com.integration.final_proyect.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.integration.final_proyect.dto.usuario.CambiarPasswordRequestDTO;
import com.integration.final_proyect.dto.usuario.ResetPasswordResponseDTO;
import com.integration.final_proyect.dto.usuario.UsuarioCreateRequestDTO;
import com.integration.final_proyect.dto.usuario.UsuarioCreateResponseDTO;
import com.integration.final_proyect.dto.usuario.UsuarioResponseDTO;
import com.integration.final_proyect.dto.usuario.UsuarioUpdateRequestDTO;
import com.integration.final_proyect.service.UsuarioService;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController (UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<UsuarioCreateResponseDTO> crear (@RequestBody UsuarioCreateRequestDTO dto) {
        return ResponseEntity.ok(usuarioService.crearUsuario(dto));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{idUsuario}")
    public ResponseEntity<UsuarioResponseDTO> actualizarUsuario (@PathVariable Long idUsuario, @RequestBody UsuarioUpdateRequestDTO request) {
        return ResponseEntity.ok(usuarioService.actualizarUsuario(idUsuario, request));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/{id}")
    public ResponseEntity<UsuarioResponseDTO> obtenerPorId (@PathVariable Long id) {
        return ResponseEntity.ok(usuarioService.obtenerPorId(id));
    }

    @PreAuthorize("hasAnyRole('ADMIN','EMPLEADO')")
    @GetMapping("/me")
    public ResponseEntity<UsuarioResponseDTO> miPerfil(Authentication auth) {
        return ResponseEntity.ok(usuarioService.obtenerMiPerfil(auth.getName()));
    }

    @PreAuthorize("hasAnyRole('ADMIN','EMPLEADO')")
    @PutMapping("/cambiar-password")
    public ResponseEntity<Void> cambiarPassword (@RequestBody CambiarPasswordRequestDTO dto, Authentication auth) {
        usuarioService.cambiarPassword(auth.getName(), dto);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{idUsuario}/reset-password")
    public ResponseEntity<ResetPasswordResponseDTO> resetPassword (@PathVariable Long idUsuario) {
        return ResponseEntity.ok(usuarioService.resetearPassword(idUsuario));
    }

    @PreAuthorize("hasAnyRole('ADMIN','EMPLEADO')")
    @PutMapping("/{idUsuario}/estado")
    public ResponseEntity<Void> cambiarEstado (@PathVariable Long idUsuario) {
        usuarioService.cambiarEstado(idUsuario);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping
    public ResponseEntity<List<UsuarioResponseDTO>> listarUsuarios() {
        return ResponseEntity.ok(usuarioService.listarUsuarios());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/buscar")
    public ResponseEntity<List<UsuarioResponseDTO>> buscar (@RequestParam String texto) {
        return ResponseEntity.ok(usuarioService.buscarUsuarios(texto));
    }

}

