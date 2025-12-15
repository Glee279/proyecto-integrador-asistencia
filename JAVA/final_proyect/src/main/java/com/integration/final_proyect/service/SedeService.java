package com.integration.final_proyect.service;

import java.util.List;

import com.integration.final_proyect.dto.sede.SedeCreateRequestDTO;
import com.integration.final_proyect.dto.sede.SedeResponseDTO;

public interface SedeService {

    SedeResponseDTO crearSede(SedeCreateRequestDTO dto);

    List<SedeResponseDTO> listarSedes();

    void cambiarEstado(Long idSede);

}
