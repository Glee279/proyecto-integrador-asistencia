import { Component } from '@angular/core';
import { ReportesService } from '../service/reportes.service';
import { ChartType } from 'angular-google-charts';
import { SedeService } from '../../administracion/services/sede.service';

@Component({
  selector: 'app-reportes-page',
  templateUrl: './reportes-page.component.html',
  styleUrls: ['./reportes-page.component.css']
})
export class ReportesPageComponent {

  fecIni = '2025-12-01';
  fecFin = '2025-12-31';

  sedes: any[] = [];
  idSedeSeleccionada: number | null = null;

  totalAsistencias = 0;
  totalTardanzas = 0;

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

  buscar() {
    this.cargarPuntualidad();
    this.cargarAsistencia();
  }

  constructor(private reportesService: ReportesService,
    private sedeService: SedeService
  ) { }

  ngOnInit() {
    this.cargarSedes();
    this.cargarPuntualidad();
    this.cargarAsistencia();
  }

  cargarSedes() {
    this.sedeService.listar().subscribe(data => {
      this.sedes = data;
    });
  }

  cargarPuntualidad() {
    this.reportesService
      .reportePuntualidad(3, this.fecIni, this.fecFin)
      .subscribe(data => {

        const puntuales = data.filter(d => d.estadoPuntualidad === 'PUNTUAL').length;
        const tardanzas = data.filter(d => d.estadoPuntualidad === 'TARDE').length;

        this.totalTardanzas = tardanzas;

        this.pieChartData = [
          ['Puntual', puntuales],
          ['Tardanza', tardanzas]
        ];
      });
  }

  cargarAsistencia() {
    this.reportesService
      .reporteAsistencia(this.fecIni, this.fecFin, this.idSedeSeleccionada)
      .subscribe(data => {

        this.totalAsistencias = data.length;

        const agrupado: { [key: string]: number } = {};

        data.forEach(a => {
          const fecha = a.fecEntrada.substring(0, 10);
          agrupado[fecha] = (agrupado[fecha] || 0) + 1;
        });

        this.barChartData = Object.keys(agrupado).map(fecha => [
          fecha,
          agrupado[fecha]
        ]);
      });
  }


}
