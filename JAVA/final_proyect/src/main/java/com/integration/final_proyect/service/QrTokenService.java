package com.integration.final_proyect.service;

import com.integration.final_proyect.dto.qr_token.QrActivoResponseDTO;
import com.integration.final_proyect.dto.qr_token.QrTokenCreateRequestDTO;
import com.integration.final_proyect.dto.qr_token.QrTokenResponseDTO;
import com.integration.final_proyect.dto.qr_token.QrTokenValidarResponseDTO;

public interface QrTokenService {

    QrTokenResponseDTO generarQr(QrTokenCreateRequestDTO dto);

    QrTokenValidarResponseDTO validarQr(String codigoQr);

    void expirarQr(Long idQr);

    QrActivoResponseDTO obtenerQrActivoPorSede(Long idSede);

}
