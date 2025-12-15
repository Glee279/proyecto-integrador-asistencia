package com.integration.final_proyect.service;

import java.sql.Date;
import java.util.List;

import com.integration.final_proyect.dto.asistencia.AsistenciaCheckInRequestDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaCheckOutRequestDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaEstadoDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaHistorialResponseDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaResponseDTO;

public interface AsistenciaService {

    AsistenciaResponseDTO checkIn(AsistenciaCheckInRequestDTO dto);

    AsistenciaResponseDTO checkOut(AsistenciaCheckOutRequestDTO dto);

    List<AsistenciaHistorialResponseDTO> historial();
    
    AsistenciaEstadoDTO estadoHoy();
    
    List<AsistenciaHistorialResponseDTO> historialEmpleado(Date fechaInicio, Date fechaFin);
    
    List<AsistenciaHistorialResponseDTO> historialAdmin(Long idUsuario, Date fechaInicio, Date fechaFin);
}
