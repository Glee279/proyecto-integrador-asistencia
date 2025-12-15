import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { GestionRoutingModule } from './gestion-routing.module';
import { GestionPageComponent } from './gestion-page/gestion-page.component';
import { ReactiveFormsModule } from '@angular/forms';


@NgModule({
  declarations: [
    GestionPageComponent
  ],
  imports: [
    CommonModule,
    GestionRoutingModule,
    ReactiveFormsModule
  ]
})
export class GestionModule { }
