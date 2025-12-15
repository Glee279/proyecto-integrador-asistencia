import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, Router } from '@angular/router';
import { AuthService } from 'src/app/modules/auth/services/auth.service';

@Injectable({
  providedIn: 'root'
})
export class RoleGuard implements CanActivate {

  constructor(
    private authService: AuthService,
    private router: Router
  ) { }

  canActivate(route: ActivatedRouteSnapshot): boolean {
    const expectedRoles: string[] = route.data['roles'] || [];
    const userRoles = this.authService.getRoles();

    if (userRoles.includes('ADMIN')) return true;

    const hasRole = expectedRoles.some(r => userRoles.includes(r));
    if (!hasRole) {
      this.router.navigate(['/']);
      return false;
    }
    return true;
  }

}
