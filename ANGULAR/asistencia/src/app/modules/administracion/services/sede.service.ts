import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/app/environment';

@Injectable({
  providedIn: 'root'
})
export class SedeService {

  private API = `${environment.apiUrl}/sedes`;

  constructor(private http: HttpClient) {}

  listar() {
    return this.http.get<any[]>(this.API);
  }
}
