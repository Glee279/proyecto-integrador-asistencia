import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { QrRoutingModule } from './qr-routing.module';
import { QrPageComponent } from './qr-page/qr-page.component';


@NgModule({
  declarations: [
    QrPageComponent
  ],
  imports: [
    CommonModule,
    QrRoutingModule
  ]
})
export class QrModule { }
