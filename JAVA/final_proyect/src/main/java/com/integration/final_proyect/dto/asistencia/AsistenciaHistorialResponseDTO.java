package com.integration.final_proyect.dto.asistencia;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class AsistenciaHistorialResponseDTO {

    private Long idAsistencia;
    private LocalDateTime fecEntrada;
    private LocalDateTime fecSalida;
    private String tipAsistencia;
    private String estado;
    private String sede;

    public AsistenciaHistorialResponseDTO(
            Long idAsistencia,
            LocalDateTime fecEntrada,
            LocalDateTime fecSalida,
            String tipAsistencia,
            String estado,
            String sede) {

        this.idAsistencia = idAsistencia;
        this.fecEntrada = fecEntrada;
        this.fecSalida = fecSalida;
        this.tipAsistencia = tipAsistencia;
        this.estado = estado;
        this.sede = sede;
    }
}
