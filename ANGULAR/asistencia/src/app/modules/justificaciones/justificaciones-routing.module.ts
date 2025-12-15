import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { JustificacionesPageComponent } from './justificaciones-page/justificaciones-page.component';

const routes: Routes = [
  {
    path: '',
    component: JustificacionesPageComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class JustificacionesRoutingModule { }
