import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/app/environment';

@Injectable({
  providedIn: 'root'
})
export class HistorialService {

  private API = `${environment.apiUrl}/asistencia`;

  constructor(private http: HttpClient) { }

  historialPropio(fechaInicio?: string, fechaFin?: string) {
    let params: any = {};
    if (fechaInicio) params.fechaInicio = fechaInicio;
    if (fechaFin) params.fechaFin = fechaFin;
    return this.http.get<any[]>(`${this.API}/historial/propio`, { params });
  }

  historialAdmin(idUsuario?: number, fechaInicio?: string, fechaFin?: string) {
    const params: any = {};
    if (idUsuario && idUsuario > 0) {
      params.idUsuario = idUsuario;
    }
    if (fechaInicio) params.fechaInicio = fechaInicio;
    if (fechaFin) params.fechaFin = fechaFin;

    return this.http.get<any[]>(`${this.API}/historial/admin`, { params });
  }

}
