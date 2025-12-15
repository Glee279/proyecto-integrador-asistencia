import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AprobacionesPageComponent } from './aprobaciones-page/aprobaciones-page.component';

const routes: Routes = [
  {
    path: '',
    component: AprobacionesPageComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AprobacionesRoutingModule { }
