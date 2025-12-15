import { Component } from '@angular/core';
import { AuthService } from 'src/app/modules/auth/services/auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent {

  roles: string[] = [];
  isOpen = false;

  constructor(
    private authService: AuthService,
    private router: Router
  ) {
    this.roles = this.authService.getRoles();
  }

  isAdmin(): boolean {
    return this.roles.includes('ADMIN');
  }

  isEmpleado(): boolean {
    return this.roles.includes('EMPLEADO');
  }

  toggle(): void {
    this.isOpen = !this.isOpen;
  }

  close(): void {
    this.isOpen = false;
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/auth/login']);
  }
}
