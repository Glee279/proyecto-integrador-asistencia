export interface AsistenciaCheckOutRequest {
    tipo: 'MANUAL' | 'QR';
    codigoQr?: string;
}
