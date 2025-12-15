import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/app/environment';

@Injectable({
  providedIn: 'root'
})
export class GestionService {

  private API = `${environment.apiUrl}/justificaciones`;

  constructor(private http: HttpClient) {}

  listarAdmin(
    fecIni: string,
    fecFin: string,
    idUsuario?: number,
    estado?: string
  ): Observable<any[]> {

    let params = new HttpParams()
      .set('fecIni', fecIni)
      .set('fecFin', fecFin);

    if (idUsuario) params = params.set('idUsuario', idUsuario);
    if (estado) params = params.set('estado', estado);

    return this.http.get<any[]>(`${this.API}/admin`, { params });
  }

  revisar(data: {
    idJustificacion: number;
    estado: string;
    comentario: string;
  }): Observable<void> {
    return this.http.put<void>(`${this.API}/revision`, data);
  }
}
