import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AsistenciaRoutingModule } from './asistencia-routing.module';
import { AsistenciaPageComponent } from './pages/asistencia-page/asistencia-page.component';


@NgModule({
  declarations: [
    AsistenciaPageComponent
  ],
  imports: [
    CommonModule,
    AsistenciaRoutingModule
  ]
})
export class AsistenciaModule { }
