package com.integration.final_proyect.dto.qr_token;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QrTokenCreateRequestDTO {

    private Long idSede;
    private Integer minutos;

}