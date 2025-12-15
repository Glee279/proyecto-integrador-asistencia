package com.integration.final_proyect.service;

import java.util.List;

import com.integration.final_proyect.dto.usuario.CambiarPasswordRequestDTO;
import com.integration.final_proyect.dto.usuario.ResetPasswordResponseDTO;
import com.integration.final_proyect.dto.usuario.UsuarioCreateRequestDTO;
import com.integration.final_proyect.dto.usuario.UsuarioCreateResponseDTO;
import com.integration.final_proyect.dto.usuario.UsuarioResponseDTO;
import com.integration.final_proyect.dto.usuario.UsuarioUpdateRequestDTO;

public interface UsuarioService {

    UsuarioCreateResponseDTO crearUsuario(UsuarioCreateRequestDTO dto);

    UsuarioResponseDTO actualizarUsuario(Long idUsuario, UsuarioUpdateRequestDTO dto);

    UsuarioResponseDTO obtenerPorId(Long idUsuario);

    UsuarioResponseDTO obtenerMiPerfil(String username);

    void cambiarPassword(String username, CambiarPasswordRequestDTO dto);

    ResetPasswordResponseDTO resetearPassword(Long idUsuario);

    void cambiarEstado(Long idUsuario);

    List<UsuarioResponseDTO> listarUsuarios();

    List<UsuarioResponseDTO> buscarUsuarios(String texto);

}
