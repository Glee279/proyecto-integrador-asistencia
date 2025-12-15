import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { HistorialRoutingModule } from './historial-routing.module';
import { HistorialPageComponent } from './historial-page/historial-page.component';
import { FormsModule } from '@angular/forms';
import { GoogleChartsModule } from 'angular-google-charts';


@NgModule({
  declarations: [
    HistorialPageComponent
  ],
  imports: [
    CommonModule,
    HistorialRoutingModule,
    FormsModule,
    GoogleChartsModule
  ]
})
export class HistorialModule { }
