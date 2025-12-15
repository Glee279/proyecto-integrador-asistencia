package com.integration.final_proyect.dto.asistencia;

import lombok.Data;

@Data
public class AsistenciaCheckInRequestDTO {

    private String tipo;      // MANUAL | QR
    private String codigoQr;   // obligatorio solo si tipo = QR

}
