package com.integration.final_proyect.dto.justificacion;

import java.time.LocalDate;

import lombok.Data;

@Data
public class JustificacionCreateRequestDTO {

    private String titulo;
    private String descripcion;
    private LocalDate fecEvento;   // fecha del evento
    private String tipJustificacion; // T | A
    private String archivoUrl;     // opcional

}
