import { Component } from '@angular/core';
import { HistorialService } from '../service/historial.service';
import { AuthService } from '../../auth/services/auth.service';

@Component({
  selector: 'app-historial-page',
  templateUrl: './historial-page.component.html',
  styleUrls: ['./historial-page.component.css']
})
export class HistorialPageComponent {

  roles: string[] = [];

  constructor(private historialService: HistorialService,
    private authService: AuthService
  ) {
    this.roles = this.authService.getRoles();
  }

  isAdmin(): boolean {
    return this.roles.includes('ADMIN');
  }

  isEmpleado(): boolean {
    return this.roles.includes('EMPLEADO');
  }

  historial: any[] = [];
  fechaInicio = '';
  fechaFin = '';
  idUsuario: number | undefined = undefined;
  loading = false;

  buscar() {
    if (this.isEmpleado()) {
      this.loading = true;
      this.historialService.historialPropio(this.fechaInicio, this.fechaFin)
        .subscribe({
          next: (data) => {
            this.historial = data;
            this.loading = false;
          },
          error: () => this.loading = false
        });
    } else if (this.isAdmin()) {
      this.loading = true;
      this.historialService.historialAdmin(this.idUsuario, this.fechaInicio, this.fechaFin)
        .subscribe({
          next: (data) => {
            this.historial = data;
            this.loading = false;
          },
          error: () => this.loading = false
        });
    }
  }

}
