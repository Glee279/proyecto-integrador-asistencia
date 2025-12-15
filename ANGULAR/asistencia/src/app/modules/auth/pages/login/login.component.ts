import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {

  loginForm: FormGroup;

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) {
    this.loginForm = this.fb.group({
      usuario: ['', Validators.required],
      password: ['', Validators.required]
    });
  }



  isInvalid(field: string): boolean {
    const control = this.loginForm.get(field);
    return !!(control && control.invalid && control.touched);
  }


  login(): void {

 
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

  
    const { usuario, password } = this.loginForm.value;

    this.authService.login({
      usuario,
      password
    }).subscribe({
      next: (resp) => {
        this.authService.saveToken(resp.token);
        this.router.navigate(['/']);
      },
      error: (err) => {
        console.error('ERROR LOGIN', err);
        alert('Credenciales inválidas');
      }
    });
  }
}
