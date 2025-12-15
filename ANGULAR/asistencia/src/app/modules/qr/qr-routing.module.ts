import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { QrPageComponent } from './qr-page/qr-page.component';

const routes: Routes = [
  {
    path: '',
    component: QrPageComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class QrRoutingModule { }
