import { Injectable } from '@angular/core';
import { AsistenciaCheckInRequest } from '../models/checkin-request';
import { HttpClient } from '@angular/common/http';
import { AsistenciaCheckOutRequest } from '../models/checkout-request';
import { environment } from 'src/app/environment';

@Injectable({
  providedIn: 'root'
})
export class AsistenciaService {

  private API = `${environment.apiUrl}/asistencia`;

  constructor(private http: HttpClient) {}

  checkIn(request: AsistenciaCheckInRequest) {
    return this.http.post(`${this.API}/check-in`, request);
  }

  checkOut(request: AsistenciaCheckOutRequest) {
    return this.http.post(`${this.API}/check-out`, request);
  }

  historial() {
    return this.http.get(`${this.API}/historial`);
  }

  estadoHoy() {
    return this.http.get(`${this.API}/estadohoy`);
  }

}
