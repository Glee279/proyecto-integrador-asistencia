import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './core/guards/auth.guard';
import { LayoutComponent } from './layout/layout.component';
import { RoleGuard } from './core/guards/role.guard';

const routes: Routes = [
  {
    path: 'auth',
    loadChildren: () =>
      import('./modules/auth/auth.module').then(m => m.AuthModule)
  },
  {
    path: '',
    component: LayoutComponent,
    canActivate: [AuthGuard],
    children: [
      {
        path: '',
        loadChildren: () =>
          import('./modules/dashboard/dashboard.module').then(m => m.DashboardModule)
      },
      { path: 'asistencia',       canActivate: [RoleGuard], data: { roles: ['EMPLEADO'] }, loadChildren: () => import('./modules/asistencia/asistencia.module').then(m => m.AsistenciaModule) },
      { path: 'historial',        canActivate: [RoleGuard], data: { roles: ['EMPLEADO','ADMIN'] }, loadChildren: () => import('./modules/historial/historial.module').then(m => m.HistorialModule) },
      { path: 'justificaciones',  canActivate: [RoleGuard], data: { roles: ['EMPLEADO'] }, loadChildren: () => import('./modules/justificaciones/justificaciones.module').then(m => m.JustificacionesModule) },

      { path: 'qr',               canActivate: [RoleGuard], data: { roles: ['ADMIN'] },    loadChildren: () => import('./modules/qr/qr.module').then(m => m.QrModule) },
      { path: 'reportes',         canActivate: [RoleGuard], data: { roles: ['ADMIN'] },    loadChildren: () => import('./modules/reportes/reportes.module').then(m => m.ReportesModule) },
      { path: 'aprobaciones',     canActivate: [RoleGuard], data: { roles: ['ADMIN'] },    loadChildren: () => import('./modules/aprobaciones/aprobaciones.module').then(m => m.AprobacionesModule) },
      { path: 'gestion',          canActivate: [RoleGuard], data: { roles: ['ADMIN'] },    loadChildren: () => import('./modules/gestion/gestion.module').then(m => m.GestionModule) },
      { path: 'administracion',   canActivate: [RoleGuard], data: { roles: ['ADMIN'] },    loadChildren: () => import('./modules/administracion/administracion.module').then(m => m.AdministracionModule) },
    ]
  },
  {
    path: '**',
    redirectTo: ''
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
