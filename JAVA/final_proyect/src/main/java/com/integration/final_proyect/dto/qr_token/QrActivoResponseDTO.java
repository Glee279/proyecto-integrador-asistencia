package com.integration.final_proyect.dto.qr_token;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class QrActivoResponseDTO {

    private Long idQr;
    private String codigoQr;
    private Long idSede;
    private LocalDateTime fecGenerado;
    private LocalDateTime fecExpira;
    private String estado;

}
