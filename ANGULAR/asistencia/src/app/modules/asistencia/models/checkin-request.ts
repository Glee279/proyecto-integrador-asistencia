export interface AsistenciaCheckInRequest {
    tipo: 'MANUAL' | 'QR';
    codigoQr?: string;
}
