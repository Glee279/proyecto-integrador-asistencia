import { Component } from '@angular/core';
import { ChartType } from 'angular-google-charts';
import { AuthService } from 'src/app/modules/auth/services/auth.service';
import { ReportesService } from 'src/app/modules/reportes/service/reportes.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {

  fecIni = '';
  fecFin = '';

  idSedeSeleccionada: number | null = null;

  totalAsistencias = 0;
  totalTardanzas = 0;
  porcentajePuntualidad = 0;

  asistenciaVsFaltasColumns = ['Tipo', 'Cantidad'];
  asistenciaVsFaltasData: any[] = [];

  pieChartType = ChartType.PieChart;
  pieChartColumns = ['Estado', 'Cantidad'];
  pieChartData: any[] = [];
  pieChartOptions = {
    pieHole: 0.4,
    legend: { position: 'bottom' }
  };

  barChartType = ChartType.ColumnChart;
  barChartColumns = ['Fecha', 'Asistencias'];
  barChartData: any[] = [];
  barChartOptions = {
    legend: { position: 'none' }
  };

  constructor(
    private authService: AuthService,
    private reportesService: ReportesService
  ) { }

  isAdmin(): boolean {
    return this.authService.getRoles().includes('ADMIN');
  }

  isEmpleado(): boolean {
    return this.authService.getRoles().includes('EMPLEADO');
  }

  get idUsuario(): number | null {
    return this.authService.getIdUsuario();
  }

  ngOnInit(): void {
    if (!this.authService.isAuthenticated()) return;

    this.setMesActual();
    this.cargarDashboardInicial();
  }

  private setMesActual(): void {
    const hoy = new Date();
    const firstDay = new Date(hoy.getFullYear(), hoy.getMonth(), 1);
    const lastDay = new Date(hoy.getFullYear(), hoy.getMonth() + 1, 0);

    this.fecIni = firstDay.toISOString().substring(0, 10);
    this.fecFin = lastDay.toISOString().substring(0, 10);
  }

  private cargarDashboardInicial(): void {

    if (this.isAdmin()) {
      this.cargarAsistenciaAdmin();
      return;
    }

    if (this.isEmpleado()) {
      this.cargarDashboardEmpleado();
      return;
    }
  }

  private cargarDashboardEmpleado(): void {

  }

  private cargarAsistenciaAdmin(): void {
    this.reportesService
      .reporteAsistencia(this.fecIni, this.fecFin, this.idSedeSeleccionada)
      .subscribe({
        next: (data) => this.procesarAsistencia(data),
        error: (err) => console.error('Error reporte asistencia ADMIN', err)
      });
  }

  private contarDiasLaborables(fecIni: string, fecFin: string): number {
    let count = 0;

    const inicio = new Date(fecIni);
    const fin = new Date(fecFin);
    const hoy = new Date();

    for (let d = new Date(inicio); d <= fin && d <= hoy; d.setDate(d.getDate() + 1)) {
      const dia = d.getDay();
      if (dia >= 1 && dia <= 5) count++;
    }

    return count;
  }

  private cargarAsistenciasVsFaltas(asistenciasReales: number): void {
    const diasLaborables = this.contarDiasLaborables(this.fecIni, this.fecFin);

    let esperado = 0;

    if (this.isEmpleado()) {
      esperado = diasLaborables;
    } else if (this.isAdmin()) {
      const empleadosActivos = 20;
      esperado = empleadosActivos * diasLaborables;
    }

    const faltas = Math.max(esperado - asistenciasReales, 0);

    this.asistenciaVsFaltasData = [
      ['Asistencias', asistenciasReales],
      ['Faltas', faltas]
    ];
  }

  private procesarAsistencia(data: any[]): void {

    this.totalAsistencias = data.length;

    this.cargarAsistenciasVsFaltas(this.totalAsistencias);

    const agrupado: { [key: string]: number } = {};

    let puntuales = 0;
    let tardanzas = 0;

    data.forEach(a => {
      if (!a?.fecEntrada) return;

      const fecha = a.fecEntrada.substring(0, 10);
      agrupado[fecha] = (agrupado[fecha] || 0) + 1;

      if (a.estado === 'PUNTUAL') puntuales++;
      if (a.estado === 'TARDE') tardanzas++;
    });

    this.barChartData = Object.keys(agrupado).map(fecha => [
      fecha,
      agrupado[fecha]
    ]);

    const totalEvaluados = puntuales + tardanzas;

    this.porcentajePuntualidad = totalEvaluados
      ? Math.round((puntuales / totalEvaluados) * 100)
      : 0;

    this.totalTardanzas = tardanzas;


    this.pieChartData = [
      ['Puntual (%)', this.porcentajePuntualidad],
      ['Tardanza (%)', 100 - this.porcentajePuntualidad]
    ];
  }


  private cargarPuntualidadEmpleado(): void {
    if (!this.idUsuario) {
      console.warn('Token sin idUsuario');
      return;
    }

    this.reportesService
      .reportePuntualidad(this.idUsuario, this.fecIni, this.fecFin)
      .subscribe({
        next: (data) => this.procesarPuntualidad(data),
        error: (err) => console.error('Error reporte puntualidad EMPLEADO', err)
      });
  }

  private procesarPuntualidad(data: any[]): void {
    const puntuales = data.filter(d => d.estadoPuntualidad === 'PUNTUAL').length;
    const tardanzas = data.filter(d => d.estadoPuntualidad === 'TARDE').length;

    const total = puntuales + tardanzas;

    this.pieChartData = [
      ['Puntual (%)', total ? Math.round((puntuales / total) * 100) : 0],
      ['Tardanza (%)', total ? Math.round((tardanzas / total) * 100) : 0]
    ];

    this.totalTardanzas = tardanzas;
  }
}
