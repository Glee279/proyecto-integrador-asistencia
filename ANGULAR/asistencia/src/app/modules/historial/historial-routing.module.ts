import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HistorialPageComponent } from './historial-page/historial-page.component';

const routes: Routes = [
  {
    path: '',
    component: HistorialPageComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class HistorialRoutingModule { }
