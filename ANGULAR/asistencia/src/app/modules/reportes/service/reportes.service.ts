import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/app/environment';

@Injectable({
  providedIn: 'root'
})
export class ReportesService {

  private API = `${environment.apiUrl}/reportes`;

  constructor(private http: HttpClient) { }

  reporteAsistenciaEmpleado(idUsuario: number, fecIni: string, fecFin: string) {
    return this.http.get<any[]>(`${this.API}/fechas`, {
      params: {
        tipo: 'ASISTENCIA',
        idUsuario,
        fecIni,
        fecFin
      }
    });
  }

  reporteAsistencia(fecIni: string, fecFin: string, idSede?: number | null) {
    const params: any = {
      tipo: 'ASISTENCIA',
      fecIni,
      fecFin
    };

    if (idSede) params.idSede = idSede;

    return this.http.get<any[]>(`${this.API}/fechas`, { params });
  }

  reportePuntualidad(idUsuario: number, fecIni: string, fecFin: string) {
    return this.http.get<any[]>(`${this.API}/fechas`, {
      params: {
        tipo: 'PUNTUALIDAD',
        idUsuario,
        fecIni,
        fecFin
      }
    });
  }
}
