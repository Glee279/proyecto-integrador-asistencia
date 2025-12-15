package com.integration.final_proyect.dto.justificacion;

import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class JustificacionResponseDTO {

    private Long idJustificacion;
    private Long idUsuario;
    private String titulo;
    private String descripcion;
    private LocalDate fecEvento;
    private LocalDateTime fecRegistro;
    private LocalDateTime fecRevision;
    private String comentario;
    private String tipJustificacion;
    private String estado; // P | A | R
    private String archivoUrl;

}
