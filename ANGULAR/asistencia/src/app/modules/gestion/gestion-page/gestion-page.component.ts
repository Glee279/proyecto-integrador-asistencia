import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { GestionService } from '../services/gestion.service';

@Component({
  selector: 'app-gestion-page',
  templateUrl: './gestion-page.component.html',
  styleUrls: ['./gestion-page.component.css']
})
export class GestionPageComponent implements OnInit {

  formFiltros!: FormGroup;
  formRevision!: FormGroup;

  justificaciones: any[] = [];
  revisionVisible = false;
  seleccionada: any;

  constructor(
    private fb: FormBuilder,
    private service: GestionService
  ) {}

  ngOnInit(): void {
    this.initFiltros();
    this.initRevision();
    this.setMesActual();
    this.buscar();
  }

  private initFiltros(): void {
    this.formFiltros = this.fb.group({
      fecIni: ['', Validators.required],
      fecFin: ['', Validators.required],
      idUsuario: [''],
      estado: ['']
    });
  }

  private initRevision(): void {
    this.formRevision = this.fb.group({
      estado: ['', Validators.required],
      comentario: ['', Validators.required]
    });
  }

  private setMesActual(): void {
    const hoy = new Date();
    const ini = new Date(hoy.getFullYear(), hoy.getMonth(), 1);
    const fin = new Date(hoy.getFullYear(), hoy.getMonth() + 1, 0);

    this.formFiltros.patchValue({
      fecIni: ini.toISOString().substring(0, 10),
      fecFin: fin.toISOString().substring(0, 10)
    });
  }

  buscar(): void {
    if (this.formFiltros.invalid) return;

    const { fecIni, fecFin, idUsuario, estado } = this.formFiltros.value;

    this.service
      .listarAdmin(fecIni, fecFin, idUsuario || null, estado || null)
      .subscribe(data => this.justificaciones = data);
  }

  abrirRevision(j: any): void {
    this.seleccionada = j;
    this.revisionVisible = true;
    this.formRevision.reset();
  }

  enviarRevision(): void {
    if (this.formRevision.invalid) return;

    const payload = {
      idJustificacion: this.seleccionada.idJustificacion,
      ...this.formRevision.value
    };

    this.service.revisar(payload).subscribe(() => {
      this.revisionVisible = false;
      this.buscar();
    });
  }
}
