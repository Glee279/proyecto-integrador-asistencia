import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AprobacionesRoutingModule } from './aprobaciones-routing.module';
import { AprobacionesPageComponent } from './aprobaciones-page/aprobaciones-page.component';


@NgModule({
  declarations: [
    AprobacionesPageComponent
  ],
  imports: [
    CommonModule,
    AprobacionesRoutingModule
  ]
})
export class AprobacionesModule { }
