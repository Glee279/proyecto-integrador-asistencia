package com.integration.final_proyect.service;

import java.time.LocalDate;
import java.util.List;

import com.integration.final_proyect.dto.justificacion.JustificacionCreateRequestDTO;
import com.integration.final_proyect.dto.justificacion.JustificacionResponseDTO;
import com.integration.final_proyect.dto.justificacion.JustificacionRevisionRequestDTO;

public interface JustificacionService {

    JustificacionResponseDTO registrar(Long idUsuarioAutenticado, JustificacionCreateRequestDTO dto);

    List<JustificacionResponseDTO> listarPorUsuario(Long idUsuario, LocalDate fecIni, LocalDate fecFin);

    void revisar(Long idRevisionAutenticado, JustificacionRevisionRequestDTO dto);

    List<JustificacionResponseDTO> listarAdmin(LocalDate fecIni, LocalDate fecFin, Long idUsuario, String estado);

}
