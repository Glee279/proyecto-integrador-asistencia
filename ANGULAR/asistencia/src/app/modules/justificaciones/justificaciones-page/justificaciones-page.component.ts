import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AuthService } from '../../auth/services/auth.service';
import { JustificacionesService } from '../services/justificaciones.service';

@Component({
  selector: 'app-justificaciones-page',
  templateUrl: './justificaciones-page.component.html',
  styleUrls: ['./justificaciones-page.component.css']
})
export class JustificacionesPageComponent {

  fecIni = '';
  fecFin = '';

  justificaciones: any[] = [];

  formJustificacion!: FormGroup;
  submitted = false;

  constructor(
    private fb: FormBuilder,
    private service: JustificacionesService
  ) {}

  ngOnInit(): void {
    this.setMesActual();
    this.initForm();
    this.cargarMisJustificaciones();
  }

  private setMesActual(): void {
    const hoy = new Date();
    this.fecIni = new Date(hoy.getFullYear(), hoy.getMonth(), 1).toISOString().substring(0,10);
    this.fecFin = new Date(hoy.getFullYear(), hoy.getMonth() + 1, 0).toISOString().substring(0,10);
  }

  private initForm(): void {
    this.formJustificacion = this.fb.group({
      titulo: ['', Validators.required],
      descripcion: ['', Validators.required],
      fecEvento: ['', Validators.required],
      tipJustificacion: ['', Validators.required],
      archivoUrl: ['']
    });
  }

  enviar(): void {
    this.submitted = true;
    if (this.formJustificacion.invalid) return;

    this.service.crear(this.formJustificacion.value).subscribe(() => {
      this.formJustificacion.reset();
      this.submitted = false;
      this.cargarMisJustificaciones();
    });
  }

  cargarMisJustificaciones(): void {
    this.service.listar(this.fecIni, this.fecFin)
      .subscribe(data => this.justificaciones = data);
  }
}