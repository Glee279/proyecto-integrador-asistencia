package com.integration.final_proyect.service;

import java.util.List;

import com.integration.final_proyect.dto.rol.RolCreateRequestDTO;
import com.integration.final_proyect.dto.rol.RolResponseDTO;

public interface RolService {

    void crearRol(RolCreateRequestDTO dto);

    void asignarRol(Long idUsuario, Long idRol);

    void quitarRol(Long idUsuario, Long idRol);

    void actualizarRol(Long idRol, String nombre);

    void modificarEstadoRol(Long idRol);

    List<RolResponseDTO> listarRoles();

    List<RolResponseDTO> rolesPorUsuario(Long idUsuario);

}
