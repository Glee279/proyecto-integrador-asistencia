import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ReportesRoutingModule } from './reportes-routing.module';
import { ReportesPageComponent } from './reportes-page/reportes-page.component';
import { GoogleChartsModule } from 'angular-google-charts';
import { FormsModule } from '@angular/forms';


@NgModule({
  declarations: [
    ReportesPageComponent
  ],
  imports: [
    CommonModule,
    ReportesRoutingModule,
    GoogleChartsModule,
    FormsModule
  ]
})
export class ReportesModule { }
