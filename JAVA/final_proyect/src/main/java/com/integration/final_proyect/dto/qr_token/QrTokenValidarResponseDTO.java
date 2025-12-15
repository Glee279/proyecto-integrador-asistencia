package com.integration.final_proyect.dto.qr_token;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class QrTokenValidarResponseDTO {

    private Boolean valido;
    private Long idSede;

}