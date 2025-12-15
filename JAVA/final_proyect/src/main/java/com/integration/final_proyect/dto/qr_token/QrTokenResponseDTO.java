package com.integration.final_proyect.dto.qr_token;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class QrTokenResponseDTO {

    private Long idQr;
    private String codigoQr;
    private String fecGenerado;
    private String fecExpira;
    private Long idSede;
    private String estado;

}