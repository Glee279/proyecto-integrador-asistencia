import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/app/environment';

@Injectable({
  providedIn: 'root'
})
@Injectable({ providedIn: 'root' })
export class JustificacionesService {

  private API = `${environment.apiUrl}/justificaciones`;

  constructor(private http: HttpClient) { }

  crear(data: any) {
    return this.http.post(this.API, data);
  }

  listar(fecIni: string, fecFin: string) {
    return this.http.get<any[]>(`${this.API}/mis-justificaciones`, {
      params: { fecIni, fecFin }
    });
  }

}