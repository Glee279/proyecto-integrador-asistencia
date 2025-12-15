import { Component, OnInit } from '@angular/core';
import { AsistenciaService } from '../../services/asistencia.service';
import { EstadoAsistencia } from '../../models/estado-asistencia';
import { DeviceService } from 'src/app/core/services/device.service';
import { Modalidad } from '../../models/modalidad';
import { AuthService } from 'src/app/modules/auth/services/auth.service';

@Component({
  selector: 'app-asistencia-page',
  templateUrl: './asistencia-page.component.html',
  styleUrls: ['./asistencia-page.component.css']
})
export class AsistenciaPageComponent implements OnInit {

  estado: EstadoAsistencia = 'SIN_MARCAR';

  modalidad!: Modalidad; // 'REMOTO' | 'PRESENCIAL'

  loading = false;
  isMobile: boolean;
  tieneEntrada = false;
  tieneSalida = false;
  canUseQR = false;

  constructor(
    private asistenciaService: AsistenciaService,
    private deviceService: DeviceService,
    private authService: AuthService
  ) {
    this.isMobile = this.deviceService.isMobile();
    this.modalidad = this.authService.getModalidad()!;
  }

  async ngOnInit() {
    this.canUseQR = await this.deviceService.hasCamera();
    this.cargarEstado();
  }

  cargarEstado() {
    this.asistenciaService.estadoHoy().subscribe({
      next: (resp: any) => {
        if (!resp.tieneEntrada) this.estado = 'SIN_MARCAR';
        else if (resp.tieneEntrada && !resp.tieneSalida) this.estado = 'ENTRADA';
        else this.estado = 'SALIDA';
      },
      error: () => {
        this.estado = 'SIN_MARCAR';
      }
    });
  }

  puedeEntradaManual(): boolean {
    return (
      this.estado === 'SIN_MARCAR' &&
      this.modalidad === 'REMOTO' &&
      !this.isMobile
    );
  }

  puedeEntradaQR(): boolean {
    return (
      this.estado === 'SIN_MARCAR' &&
      this.isMobile
    );
  }

  puedeSalidaManual(): boolean {
    return (
      this.estado === 'ENTRADA' &&
      this.modalidad === 'REMOTO'
    );
  }

  puedeSalidaQR(): boolean {
    return (
      this.estado === 'ENTRADA' &&
      this.isMobile
    );
  }

  marcarEntradaManual(): void {
    this.loading = true;

    this.asistenciaService.checkIn({ tipo: 'MANUAL' })
      .subscribe({
        next: () => {
          this.cargarEstado();
          this.loading = false;
        },
        error: () => {
          alert('Error al marcar entrada');
          this.loading = false;
        }
      });
  }

  marcarSalidaManual(): void {
    this.loading = true;

    this.asistenciaService.checkOut({ tipo: 'MANUAL' })
      .subscribe({
        next: () => {
          this.cargarEstado();
          this.loading = false;
        },
        error: () => {
          alert('Error al marcar salida');
          this.loading = false;
        }
      });
  }
}

