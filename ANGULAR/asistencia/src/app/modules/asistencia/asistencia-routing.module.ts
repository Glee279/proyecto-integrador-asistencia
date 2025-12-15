import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AsistenciaPageComponent } from './pages/asistencia-page/asistencia-page.component';

const routes: Routes = [
  {
    path: '',
    component: AsistenciaPageComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AsistenciaRoutingModule { }
