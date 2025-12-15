import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { JustificacionesRoutingModule } from './justificaciones-routing.module';
import { JustificacionesPageComponent } from './justificaciones-page/justificaciones-page.component';
import { ReactiveFormsModule } from '@angular/forms';


@NgModule({
  declarations: [
    JustificacionesPageComponent
  ],
  imports: [
    CommonModule,
    JustificacionesRoutingModule,
    ReactiveFormsModule
  ]
})
export class JustificacionesModule { }
