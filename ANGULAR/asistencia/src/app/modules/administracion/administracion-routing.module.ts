import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AdministracionPageComponent } from './administracion-page/administracion-page.component';

const routes: Routes = [
  {
    path: '',
    component: AdministracionPageComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdministracionRoutingModule { }
